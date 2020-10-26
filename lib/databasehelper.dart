import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //making singleton
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //completed

  //Database Strings
  static final dbname = "notekeeper.db";
  static final tablename = "notes";
  static final version = 1;

  //columns
  static final col_id = "id";
  static final col_note = "note";
  static final col_priority = "priority";
  static final col_date = "date";

  //database instance
  Database _database;

  //database getter
  Future<Database> get database async {
    //if already exists
    if (_database != null) return _database;

    //if dosent exist create database
    _database = await openDatabase(dbname, version: 1);

    //create table
    await _database.execute('''
        CREATE table IF NOT EXISTS $tablename(
        $col_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $col_note Text NOT NULL,
        $col_date Text NOT NULL,
        $col_priority INTEGER NOT NULL
        );
      ''');
    return _database;
  }

  //query all
  Future<List<Map<String, dynamic>>> queryall(int showstatus) async {
    var db = await database;
    List<Map<String, dynamic>> data = await db
        .rawQuery("select * from $tablename where $col_priority = $showstatus");
    return data.isEmpty ? null : data;
  }

  //insert
  Future<int> insert(
      String input_note, String input_date, int input_priority) async {
    var db = await database;
    Map<String, dynamic> row = {
      col_note: '$input_note'.trim(),
      col_date: '$input_date',
      col_priority: input_priority
    };
    int result = await db.insert(tablename, row);
    return result;
  }

  //bulk delete
  Future<int> bulkdelete(var array) async {
    print(array);
    array.forEach((value) async {
      await delete(value);
    });
  }

  //delete
  Future<int> delete(int id) async {
    var db = await database;
    int result =
        await db.delete(tablename, where: '$col_id = ?', whereArgs: [id]);
    return result;
  }

  //update
  Future<int> update(int id, String note, int priority) async {
    var db = await database;
    var targerid = col_id;
    Map<String, dynamic> row = {
      col_note: '$note'.trim(),
      col_priority: priority
    };
    int result = await db
        .update(tablename, row, where: '$targerid = ?', whereArgs: [id]);
    return result;
  }

  //bulk hide
  Future<int> bulkhide(var array, int status) async {
    print(array);
    var db = await database;
    array.forEach((value) async {
      await db.rawUpdate(
          "UPDATE $tablename SET $col_priority = $status WHERE $col_id = ?",
          [value]);
    });
  }
}

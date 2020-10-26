import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    iconTheme: IconThemeData(color: Colors.blueAccent),
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      textTheme: TextTheme(
        headline6: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            letterSpacing: 2,
            fontSize: 25),
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blueAccent,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xff2A2D36),
    iconTheme: IconThemeData(color: Colors.amberAccent),
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      textTheme: TextTheme(
        headline6: TextStyle(
            color: Colors.amberAccent,
            fontWeight: FontWeight.w400,
            letterSpacing: 2,
            fontSize: 25),
      ),
      iconTheme: IconThemeData(
          //color: Colors.black,
          ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xff353841),
    ),
    cardTheme: CardTheme(color: Color(0xff353841)),
  );
}

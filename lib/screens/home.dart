import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notekeeper/components/fab.dart';
import 'package:notekeeper/components/note_card.dart';
import 'package:notekeeper/databasehelper.dart';
import 'package:notekeeper/mulitselecthelper.dart';
import 'package:notekeeper/screens/about.dart';
import 'package:notekeeper/screens/editnote.dart';
import 'package:notekeeper/theme/AppStateNotifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _hideButtonController;

  @override
  initState() {
    super.initState();
    _hideButtonController = new ScrollController();
    getTheme();
    //_showDialog(context);
  }

  bool isDark = false;
  int hidden = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (hidden == 1) {
          hidden = 0;
          setState(() {});
        }
        if (Provider.of<MultiSelectHelper>(context, listen: false)
            .arr
            .isNotEmpty) {
          Provider.of<MultiSelectHelper>(context, listen: false).cleararray();
          setState(() {});
        }
      },
      child: Scaffold(
        //appbar
        appBar: AppBar(
          elevation: 0,
          title: hidden == 0 ? Text("Notes") : Text("Hidden Space"),
          actions: [
            Consumer<MultiSelectHelper>(
                builder: (context, multiselect, child) => multiselect
                        .arr.isEmpty
                    ? GestureDetector(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.settings,
                              color: Provider.of<AppStateNotifier>(context)
                                      .isDarkmodeOn
                                  ? Colors.white70
                                  : Colors.black,
                            ),
                          ),
                        ),
                        onTap: () {
                          print("about page");
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => About(),
                            ),
                          );
                        },
                      )
                    : GestureDetector(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              hidden == 0 ? Icons.lock : Icons.lock_open,
                              color: Provider.of<AppStateNotifier>(context)
                                      .isDarkmodeOn
                                  ? Colors.white70
                                  : Colors.black,
                            ),
                          ),
                        ),
                        onTap: () async {
                          print("Hide notes");
                          print(hidden);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (prefs.containsKey('openedBefore') == false) {
                            print("show dialog");
                            prefs.setBool('openedBefore', true);
                            _showDialog(context);
                          }
                          await DatabaseHelper.instance.bulkhide(
                              Provider.of<MultiSelectHelper>(context,
                                      listen: false)
                                  .arr,
                              hidden == 1 ? 0 : 1);
                          Provider.of<MultiSelectHelper>(context, listen: false)
                              .cleararray();
                          setState(() {});
                        },
                      ))
          ],
          //backgroundColor: Colors.transparent,
          centerTitle: true,
        ),

        //Futurebuilder->listview here
        body: FutureBuilder(
          future: DatabaseHelper.instance.queryall(hidden),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return Container();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              print("no data found");
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        hidden == 0 ? 'res/empty.png' : 'res/hidden.png',
                        height: 280,
                      ),
                      Text(
                        hidden == 0 ? 'Such empty...' : 'No hidden Notes.',
                        style: TextStyle(fontSize: 20, letterSpacing: 2),
                      )
                    ],
                  ),
                ),
              );
            } else {
              //print(snapshot.data);
              return StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                physics: BouncingScrollPhysics(),
                controller: _hideButtonController,
                shrinkWrap: true,
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return NoteCard(
                    snapshot.data[index][DatabaseHelper.col_id],
                    snapshot.data[index][DatabaseHelper.col_note],
                    snapshot.data[index][DatabaseHelper.col_priority],
                    snapshot.data[index][DatabaseHelper.col_date],
                    () {
                      setState(() {});
                    },
                  );
                },
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              );
            }
          },
        ),

        //new note
        floatingActionButton: GestureDetector(
          onLongPress: () {
            if (Provider.of<MultiSelectHelper>(context, listen: false)
                .arr
                .isEmpty) {
              print("show hidden");
              setState(() {
                HapticFeedback.lightImpact();
                hidden = 1;
              });
            }
            //_showDialog(context);
          },
          child: Fab(
            hideButtonController: _hideButtonController,
            onPress: () async {
              if (Provider.of<MultiSelectHelper>(context, listen: false)
                  .arr
                  .isEmpty) {
                print("add note presed");
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditNote(
                      newnote: true,
                      priority: hidden == 0 ? 0 : 1,
                    ),
                  ),
                );
                setState(() {});
              } else {
                await DatabaseHelper.instance.bulkdelete(
                    Provider.of<MultiSelectHelper>(context, listen: false).arr);
                Provider.of<MultiSelectHelper>(context, listen: false)
                    .cleararray();
                setState(() {});
              }
            },
            hidden: hidden == 0 ? false : true,
          ),
        ),
      ),
    );
  }

  getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.containsKey('isDark') ? prefs.getBool('isDark') : false;
    Provider.of<AppStateNotifier>(context, listen: false).UpdateTheme(isDark);
  }
}

void _showDialog(context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.remove_red_eye),
            SizedBox(
              width: 15,
            ),
            Text("Accessing Hidden Notes"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Press and hold on the New Note floating action Button to access your Hidden Space."),
            Image.asset(
              'res/fab.png',
              height: 150,
            )
          ],
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

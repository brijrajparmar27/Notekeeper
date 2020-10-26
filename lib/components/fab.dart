import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notekeeper/mulitselecthelper.dart';
import 'package:notekeeper/theme/AppStateNotifier.dart';
import 'package:provider/provider.dart';
//import 'package:notekeeper/screens/editnote.dart';

class Fab extends StatefulWidget {
  bool _isVisible = true;
  bool hidden;

  //bool isDark;
  ScrollController hideButtonController;
  VoidCallback onPress;

  Fab({this.hideButtonController, this.onPress, this.hidden});

  @override
  _FabState createState() => _FabState();
}

class _FabState extends State<Fab> {
  @override
  void initState() {
    super.initState();

    widget.hideButtonController.addListener(() {
      if (widget.hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (widget._isVisible == true) {
          setState(() {
            widget._isVisible = false;
          });
        }
      } else {
        if (widget.hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (widget._isVisible == false) {
            setState(() {
              widget._isVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget._isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: FloatingActionButton.extended(
        backgroundColor: Provider.of<MultiSelectHelper>(context).arr.isEmpty
            ? Provider.of<AppStateNotifier>(context, listen: false).isDarkmodeOn
                ? Color(0xff353841)
                : Colors.blueAccent
            : Provider.of<AppStateNotifier>(context, listen: false).isDarkmodeOn
                ? Color(0xff353841)
                : Colors.redAccent,
        onPressed: widget._isVisible ? widget.onPress : null,
        label: Text(
          Provider.of<MultiSelectHelper>(context).arr.isEmpty
              ? widget.hidden ? "Hidden Note" : "New Note"
              : "Delete Note",
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Provider.of<MultiSelectHelper>(context).arr.isEmpty
                  ? Colors.white
                  : Provider.of<AppStateNotifier>(context, listen: false)
                          .isDarkmodeOn
                      ? Colors.redAccent
                      : Colors.white),
        ),
        icon: Icon(
            Provider.of<MultiSelectHelper>(context).arr.isEmpty
                ? Icons.add
                : Icons.delete,
            color: Provider.of<MultiSelectHelper>(context).arr.isEmpty
                ? Colors.white
                : Provider.of<AppStateNotifier>(context, listen: false)
                        .isDarkmodeOn
                    ? Colors.redAccent
                    : Colors.white),
      ),
    );
  }
}

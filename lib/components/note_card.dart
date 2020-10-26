import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notekeeper/mulitselecthelper.dart';
import 'package:notekeeper/screens/editnote.dart';
import 'package:notekeeper/theme/AppStateNotifier.dart';
import 'package:notekeeper/transitions/scale.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatefulWidget {
  @override
  int id, priority;
  String note, date;
  VoidCallback onPress;

  NoteCard(this.id, this.note, this.priority, this.date, this.onPress);

  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  Color bgcolor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: bgcolor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(
              widget.note,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            //isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 4),
                  child: Text(
                    widget.date,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      //letterSpacing:
                    ),
                  ),
                ),
                Text(
                  widget.note,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onLongPress: () {
        if (Provider.of<MultiSelectHelper>(context, listen: false)
            .arr
            .contains(widget.id)) {
          print("already exists");
        } else {
          Provider.of<MultiSelectHelper>(context, listen: false)
              .addtoarray(widget.id);
          setState(() {
            bgcolor = Provider.of<AppStateNotifier>(context, listen: false)
                    .isDarkmodeOn
                ? Colors.amber
                : Colors.blue[100];
            HapticFeedback.lightImpact();
            print(bgcolor);
            //print("dark mode is ${Provider.of<AppStateNotifier>(context).isDarkmodeOn}");
          });
        }
      },
      onTap: () async {
        if (Provider.of<MultiSelectHelper>(context, listen: false)
            .arr
            .isEmpty) {
          print("edit note presed");
          print("note id:-  ${widget.id} selected for edit");
          await Navigator.push(
            context,
            ScaleRoute(
              page: EditNote(
                newnote: false,
                id: widget.id,
                note: widget.note,
                now: widget.date,
                priority: widget.priority,
              ),
            ),
          );
          widget.onPress();
        } else {
          if (Provider.of<MultiSelectHelper>(context, listen: false)
              .arr
              .contains(widget.id)) {
            Provider.of<MultiSelectHelper>(context, listen: false)
                .removefromarray(widget.id);
            setState(() {
              bgcolor = Provider.of<AppStateNotifier>(context, listen: false)
                      .isDarkmodeOn
                  ? Color(0xff353841)
                  : Colors.white;
            });
          } else {
            Provider.of<MultiSelectHelper>(context, listen: false)
                .addtoarray(widget.id);
            setState(() {
              bgcolor = Provider.of<AppStateNotifier>(context, listen: false)
                      .isDarkmodeOn
                  ? Colors.amber
                  : Colors.blue[100];
              //HapticFeedback.lightImpact();
            });
          }
        }
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/databasehelper.dart';
import 'package:notekeeper/theme/AppStateNotifier.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class EditNote extends StatefulWidget {
  bool newnote;
  int priority;
  String note;
  String now;
  int id;

  EditNote({this.newnote, this.priority, this.id, this.note, this.now});

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  bool newnote;
  int priority = 0;
  int id;
  String now;

  //Textcontrollers
  TextEditingController notecontroller = new TextEditingController();

  @override
  void initState() {
    newnote = widget.newnote;
    print("controller => $notecontroller");
    print("note => ${widget.note}");
    if (!newnote) {
      print('note selected for editing is ${widget.id}');
      //initiate fetch for update
      id = widget.id;
      print(widget.note);
      notecontroller.text = widget.note;
      priority = widget.priority;
      now = widget.now;
    } else {
      priority = widget.priority;
      getnow();
    }
  }

  //bool noteempty = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          //color: Colors.blueAccent,
          size: 35,
        ),
        leading: GestureDetector(
          child: Center(
            child: Icon(
              Icons.arrow_back_ios,
              size: 27,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        actions: [
          notecontroller.text.isNotEmpty
              ? GestureDetector(
                  child: Center(
                    child: Icon(
                      Icons.share,
                      size: 27,
                    ),
                  ),
                  onTap: () {
                    print("share ${widget.note}");
                    handleShare();
                  },
                )
              : Container(),
          SizedBox(
            width: 15,
          ),
          GestureDetector(
            child: Center(
              child: Icon(
                Icons.check,
              ),
            ),
            onTap: () {
              getnow();
              print(notecontroller.text);
              notecontroller.text.isEmpty ? Navigator.pop(context) : savenote();
            },
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      //extendBodyBehindAppBar: true,
      //body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                child: Text(
                  now,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    //color: Colors.black54
                    //letterSpacing:
                  ),
                ),
              ),

              // note
              TextField(
                autofocus: newnote ? true : false,
                cursorColor: Provider.of<AppStateNotifier>(context).isDarkmodeOn
                    ? Colors.amberAccent
                    : Colors.blueAccent,
                controller: notecontroller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none),
                style: TextStyle(fontSize: 20, letterSpacing: 0.5),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),

              //save
/*            RaisedButton(
                child: Text("save"),
                onPressed: () async {
                  savenote();
                },
              )*/
            ],
          ),
        ),
      ),

      //delete note
      floatingActionButton: newnote == true
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                print("delete note presed");
                DatabaseHelper.instance.delete(id);
                Navigator.pop(context);
              },
              label: Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
    );
  }

  savenote() async {
    if (newnote) {
      print("save pressed");
      int result = await DatabaseHelper.instance
          .insert(notecontroller.text, now, priority);
      print(result == 0 ? 'failed' : 'sucess');
    } else {
      print("update pressed");
      int result = await DatabaseHelper.instance
          .update(id, notecontroller.text, priority);
      print(result == 0 ? 'failed' : 'sucess');
    }

    Navigator.pop(context);
  }

  getnow() {
    DateTime dt = DateTime.now();
    //Month dd, hh:mm
    String formatted = DateFormat('LLLL dd, hh:mm').format(dt);
    //print(formatted);
    now = formatted;
    print(now);
  }

  void handleShare() {
    Share.share('${widget.note}');
  }
}

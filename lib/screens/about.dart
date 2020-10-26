import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notekeeper/theme/AppStateNotifier.dart';
import 'package:provider/provider.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool scr = true;
  bool ecd = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Image.asset(
              "res/note.png",
              height: 250,
            )),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 20),
              child: Text(
                "About",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              title: Text(
                "Developer",
                style: TextStyle(fontSize: 18, letterSpacing: 0.5),
              ),
              subtitle: Text("Brijrajsinh Parmar"),
              trailing: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('res/avatar.jpg'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 20),
              child: Text(
                "App Settings",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              leading: Text(
                "Dark mode",
                style: TextStyle(fontSize: 18, letterSpacing: 0.5),
              ),
              trailing: CupertinoSwitch(
                activeColor: Provider.of<AppStateNotifier>(context).isDarkmodeOn
                    ? Colors.amberAccent
                    : Colors.blueAccent,
                value: Provider.of<AppStateNotifier>(context).isDarkmodeOn,
                onChanged: (bool value) {
                  print("state changed");
                  Provider.of<AppStateNotifier>(context, listen: false)
                      .UpdateTheme(value);
                },
              ),
            ),
            ListTile(
              leading: Text(
                "Send crash reports",
                style: TextStyle(fontSize: 18, letterSpacing: 0.5),
              ),
              trailing: CupertinoSwitch(
                value: scr,
                activeColor: Provider.of<AppStateNotifier>(context).isDarkmodeOn
                    ? Colors.amberAccent
                    : Colors.blueAccent,
                onChanged: (bool value) {
                  setState(() {
                    scr = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: Text(
                "Encrypt Database",
                style: TextStyle(fontSize: 18, letterSpacing: 0.5),
              ),
              trailing: CupertinoSwitch(
                value: ecd,
                activeColor: Provider.of<AppStateNotifier>(context).isDarkmodeOn
                    ? Colors.amberAccent
                    : Colors.blueAccent,
                onChanged: (bool value) {
                  setState(() {
                    ecd = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 5),
              child: GestureDetector(
                  child: Text(
                    "Support me",
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        color:
                            Provider.of<AppStateNotifier>(context).isDarkmodeOn
                                ? Colors.amberAccent
                                : Colors.blueAccent),
                  ),
                  onTap: () {}),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 5),
              child: GestureDetector(
                child: Text(
                  "Checkout my other work.",
                  style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                      color: Provider.of<AppStateNotifier>(context).isDarkmodeOn
                          ? Colors.amberAccent
                          : Colors.blueAccent),
                ),
                onTap: () {},
              ),
            ),
            /*SizedBox(height: 60,),
            Center(child: Text("Made with ❤ in India",style: TextStyle(color: Colors.grey),))*/
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateNotifier extends ChangeNotifier {
  bool isDarkmodeOn = false;

  void UpdateTheme(bool isDarkModeOn) {
    this.isDarkmodeOn = isDarkModeOn;
    print(isDarkModeOn);
    addIntToSF(isDarkModeOn);
    notifyListeners();
  }

  addIntToSF(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', value);
  }

/*  Future<bool> getThemestatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDark');
  }*/
}

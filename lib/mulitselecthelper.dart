import 'package:flutter/material.dart';

class MultiSelectHelper extends ChangeNotifier {
  MultiSelectHelper._privateConstructor();

  static final MultiSelectHelper multiselectinstance =
      MultiSelectHelper._privateConstructor();

  var arr = [];

  addtoarray(int id) {
    arr.add(id);
    print(arr);
    notifyListeners();
  }

  removefromarray(int id) {
    arr.remove(id);
    print(arr);
    notifyListeners();
  }

  cleararray() {
    arr.clear();
    notifyListeners();
  }
}

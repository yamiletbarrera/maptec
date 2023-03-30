import 'package:flutter/material.dart';
import 'package:maptec/repositories/data_db.dart';

class SharedPreferencesBloc extends ChangeNotifier {
  dynamic sharedPreferencesDB = [];

  SharedPreferencesBloc() {
    SharedPreferencesDB.instance
        .readSharedPreferences()
        .then((value) => sharedPreferencesDB = value);
  }

  addSharedPreferences(int id, bool isDark, String data) async {
    final sp = SharedPreferences(id: id, isDark: isDark, data: data);
    await SharedPreferencesDB.instance.insertSharedPreferences(sp);

    SharedPreferencesDB.instance
        .readSharedPreferences()
        .then((value) => sharedPreferencesDB = value);
    notifyListeners();
  }

  updateSharedPreferencesDB(int id, bool isDark, String data) async {
    final sp = SharedPreferences(id: id, isDark: isDark, data: data);
    await SharedPreferencesDB.instance.updateSharedPreferences(sp);

    SharedPreferencesDB.instance
        .readSharedPreferences()
        .then((value) => sharedPreferencesDB = value);
    notifyListeners();
  }

  deleteSharedPreferencesDB(int id) async {
    await SharedPreferencesDB.instance.deleteSharedPreferences(id);

    SharedPreferencesDB.instance
        .readSharedPreferences()
        .then((value) => sharedPreferencesDB = value);
    notifyListeners();
  }
}

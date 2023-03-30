import 'package:flutter/material.dart';
import 'package:maptec/utils/theme.dart';

class ThemeBloc with ChangeNotifier {
  ThemeData _themeData = darkTheme;
  bool _isDark = true;

  //constructor optional property
  ThemeBloc({bool isDark = true}) {
    _isDark = isDark;
    _themeData = isDark ? darkTheme : lightTheme;
  }

  bool getIsDark() => _isDark;

  void setIsDark(bool isDark) {
    _isDark = isDark;
    notifyListeners();
  }

  ThemeData getTheme() => _themeData;

  setTheme(bool isDark) {
    _themeData = isDark ? darkTheme : lightTheme;
    setIsDark(isDark ? true : false);
    notifyListeners();
  }
}

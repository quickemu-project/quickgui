import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;
  set useDarkMode(bool useDarkMode) {
    _themeMode = useDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

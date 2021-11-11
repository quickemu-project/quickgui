import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;

  set useDarkModeSilently(bool useDarkMode) {
    _themeMode = useDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  set useDarkMode(bool useDarkMode) {
    useDarkModeSilently = useDarkMode;
    notifyListeners();
  }
}

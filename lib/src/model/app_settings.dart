import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickgui/src/supported_locales.dart';

class AppSettings extends ChangeNotifier {
  ThemeMode? _themeMode;
  String? _activeLocale;

  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;

  String get activeLocale => _activeLocale ?? Platform.localeName;

  String? get languageCode => _activeLocale?.split("_")[0];
  String? get countryCode =>
      ((_activeLocale != null) && (_activeLocale!.contains("_")))
          ? _activeLocale!.split("_")[1]
          : null;

  set activeLocale(String locale) {
    _activeLocale = locale;
    notifyListeners();
  }

  setActiveLocaleSilently(String locale) {
    _activeLocale = locale;
    if (_activeLocale!.contains(".")) {
      _activeLocale = _activeLocale!.split(".")[0];
    }
    if (!supportedLocales.contains(_activeLocale)) {
      if (activeLocale.contains("_")) {
        _activeLocale = _activeLocale!.split("_")[0];
      }
      if (!supportedLocales.contains(_activeLocale)) {
        _activeLocale = "en";
      }
    }
  }

  set themeModeSilently(ThemeMode themeMode) {
    _themeMode = themeMode;
  }

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}

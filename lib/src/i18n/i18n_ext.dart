import 'package:flutter/material.dart';
import 'package:quickgui/src/i18n/quickgui_localizations.dart';

extension I18nExt on BuildContext {
  t(String key) => QuickguiLocalizations.of(this).t(key);
}

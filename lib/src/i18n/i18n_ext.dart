import 'package:flutter/material.dart';

import 'quickgui_localizations.dart';

extension I18nExt on BuildContext {
  t(String key, {List<Object>? args}) => QuickguiLocalizations.of(this).t(key, args);
}

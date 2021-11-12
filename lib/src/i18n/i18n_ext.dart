import 'package:flutter/material.dart';

import 'quickgui_localizations.dart';

extension I18nExt on BuildContext {
  t(String key) => QuickguiLocalizations.of(this).t(key);
}

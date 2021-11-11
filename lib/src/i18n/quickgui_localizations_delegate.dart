import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickgui/src/i18n/quickgui_localizations.dart';

class QuickguiLocalizationsDelegate extends LocalizationsDelegate<QuickguiLocalizations> {
  @override
  bool isSupported(Locale locale) => ['fr', 'en'].contains(locale.languageCode);

  @override
  Future<QuickguiLocalizations> load(Locale locale) async {
    var poContent = '';
    try {
      poContent = await rootBundle.loadString('assets/i18n/${locale.languageCode}_${locale.countryCode}.po');
    } catch (e) {
      poContent = await rootBundle.loadString('assets/i18n/${locale.languageCode}.po');
    }

    return QuickguiLocalizations.fromPO(poContent);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<QuickguiLocalizations> old) => true;
}

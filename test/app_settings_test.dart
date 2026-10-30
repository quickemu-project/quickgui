import 'package:flutter_test/flutter_test.dart';
import 'package:quickgui/src/model/app_settings.dart';

void main() {
  test(
    'normalizes an encoded locale and falls back for unsupported values',
    () {
      final settings = AppSettings();
      settings.setActiveLocaleSilently('en_US.UTF-8');
      expect(settings.languageCode, 'en');
      settings.setActiveLocaleSilently('unsupported_LOCALE');
      expect(settings.activeLocale, 'en');
    },
  );
}

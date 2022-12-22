import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:provider/provider.dart';
import 'package:quickgui/src/mixins/app_version.dart';
import 'package:quickgui/src/pages/deget_not_found_page.dart';
import 'package:quickgui/src/supported_locales.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';
import 'mixins/preferences_mixin.dart';
import 'model/app_settings.dart';
import 'pages/main_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with PreferencesMixin {
  @override
  Widget build(BuildContext context) {
    platform = TargetPlatform.macOS;
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          var appSettings = context.read<AppSettings>();
          appSettings.setActiveLocaleSilently(
              snapshot.data?.getString(prefCurrentLocale) ??
                  Platform.localeName);
          var pref = snapshot.data!.getString(prefThemeMode);
          if (pref != null) {
            appSettings.themeModeSilently =
                ThemeMode.values.firstWhere((element) => element.name == pref);
          }
          return Consumer<AppSettings>(
            builder: (context, appSettings, _) {
              return PlatformApp(
                themeMode: appSettings.themeMode,
                home: AppVersion.packageInfo == null
                    ? const DebgetNotFoundPage()
                    : const MainPage(),
                supportedLocales: supportedLocales.map((s) => s.contains("_")
                    ? Locale(s.split("_")[0], s.split("_")[1])
                    : Locale(s)),
                localizationsDelegates: [
                  GettextLocalizationsDelegate(),
                  ...GlobalMaterialLocalizations.delegates,
                  GlobalWidgetsLocalizations.delegate,
                ],
                windowButtonConfig: PlatformWindowButtonConfig(
                  isMaximized: () => false,
                  onClose: () {},
                  onMinimize: () {},
                  onMaximize: () {},
                  onRestore: () {},
                ),
                windowsTheme: fluent.ThemeData(
                  scaffoldBackgroundColor: fluent.Colors.grey[50],
                ),
                windowsDarkTheme: fluent.ThemeData.dark(),
                locale:
                    Locale(appSettings.languageCode!, appSettings.countryCode),
                localeListResolutionCallback: (locales, supportedLocales) {
                  if (locales != null) {
                    for (var locale in locales) {
                      var supportedLocale = supportedLocales.where((element) =>
                          element.languageCode == locale.languageCode &&
                          element.countryCode == locale.countryCode);
                      if (supportedLocale.isNotEmpty) {
                        return supportedLocale.first;
                      }
                      supportedLocale = supportedLocales.where((element) =>
                          element.languageCode == locale.languageCode);
                      if (supportedLocale.isNotEmpty) {
                        return supportedLocale.first;
                      }
                    }
                  }
                  return null;
                },
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

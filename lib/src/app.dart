import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:provider/provider.dart';
import 'package:quickgui/src/mixins/app_version.dart';
import 'package:quickgui/src/pages/debget_not_found_page.dart';
import 'package:quickgui/src/supported_locales.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';
import 'mixins/preferences_mixin.dart';
import 'model/app_settings.dart';
import 'pages/main_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with PreferencesMixin {
  // Define the primary dark grey color.
  static const int _darkGreyPrimaryValue = 0xFF424242;

  // Create a map of shades for the dark grey color.
  static const MaterialColor darkGrey = MaterialColor(
    _darkGreyPrimaryValue,
    <int, Color>{
      50: Color(0xFFE0E0E0),
      100: Color(0xFFBDBDBD),
      200: Color(0xFF9E9E9E),
      300: Color(0xFF757575),
      400: Color(0xFF616161),
      500: Color(_darkGreyPrimaryValue),
      600: Color(0xFF3D3D3D),
      700: Color(0xFF333333),
      800: Color(0xFF2B2B2B),
      900: Color(0xFF1C1C1C),
    },
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          var appSettings = context.read<AppSettings>();
          appSettings.setActiveLocaleSilently(
              snapshot.data?.getString(prefCurrentLocale) ??
                  Platform.localeName);
          var pref = snapshot.data!.getBool(prefThemeMode);
          if (pref != null) {
            appSettings.useDarkModeSilently = pref;
          }
          return Consumer<AppSettings>(
            builder: (context, appSettings, _) => MaterialApp(
              theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.pink,
                    backgroundColor: Colors.white,
                  )),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: darkGrey,
                  backgroundColor: darkGrey.shade700,
                  brightness: Brightness.dark,
                ),
              ),
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
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
    /*
    return FutureBuilder<bool?>(
      future: getPreference<bool>(prefThemeMode),
      builder: (context, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            context.read<AppSettings>().useDarkModeSilently = snapshot.data!;
          }
          return Consumer<AppSettings>(
            builder: (context, appTheme, _) => MaterialApp(
              theme: ThemeData(primarySwatch: Colors.pink),
              darkTheme: ThemeData.dark(),
              themeMode: appTheme.themeMode,
              home: const MainPage(),
              supportedLocales: supportedLocales.map((s) => s.contains("_")
                  ? Locale(s.split("_")[0], s.split("_")[1])
                  : Locale(s)),
              localizationsDelegates: [
                GettextLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              locale: const Locale('ru'),
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
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
    */
  }
}

import 'dart:io';

import 'package:adwaita/adwaita.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:provider/provider.dart';
import 'package:quickgui/main.dart';
import 'package:quickgui/src/mixins/app_version.dart';
import 'package:quickgui/src/model/operating_system.dart';
import 'package:quickgui/src/pages/deget_not_found_page.dart';
import 'package:quickgui/src/supported_locales.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

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
  bool isCheckingQuickemu = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final foundQuickGet = await Process.run('which', ['quickget']);
      if (foundQuickGet.exitCode == 0) {
        gOperatingSystems = await loadOperatingSystems(false);
        AppVersion.packageInfo = await PackageInfo.fromPlatform();
        setState(() {
          isCheckingQuickemu = false;
        });
      } else {
        setState(() {
          isCheckingQuickemu = false;
        });
      }

      final pref = await SharedPreferences.getInstance();
      final appSettings = context.read<AppSettings>();
      appSettings.setActiveLocaleSilently(
        pref.getString(prefCurrentLocale) ?? Platform.localeName,
      );
      final cacheThemeMode = pref.getString(prefThemeMode);
      appSettings.themeModeSilently = ThemeMode.values.firstWhere((element) {
        return element.name == cacheThemeMode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettings>();
    return PlatformApp(
      themeMode: appSettings.themeMode,
      home: isCheckingQuickemu
          ? Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  actions: [
                    Theme(
                      data: AdwaitaThemeData.dark(),
                      child: PlatformWindowButtons(
                        isMaximized: () => windowManager.isMaximized(),
                        onClose: windowManager.close,
                        onMinimize: windowManager.minimize,
                        onMaximize: windowManager.maximize,
                        onRestore: windowManager.restore,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PlatformText.subheading(
                      "Checking Quickemu...",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[800]!,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            )
          : AppVersion.packageInfo == null
              ? const DebgetNotFoundPage()
              : const MainPage(),
      supportedLocales: supportedLocales.map(
        (s) => s.contains("_")
            ? Locale(s.split("_")[0], s.split("_")[1])
            : Locale(s),
      ),
      localizationsDelegates: [
        GettextLocalizationsDelegate(),
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      windowButtonConfig: PlatformWindowButtonConfig(
        isMaximized: () => windowManager.isMaximized(),
        onClose: windowManager.close,
        onMinimize: windowManager.minimize,
        onMaximize: windowManager.maximize,
        onRestore: windowManager.restore,
        showMaximizeButton: false,
      ),
      windowsTheme: fluent.ThemeData(
        scaffoldBackgroundColor: fluent.Colors.grey[30],
      ),
      windowsDarkTheme: fluent.ThemeData.dark().copyWith(
        scaffoldBackgroundColor: fluent.Colors.grey[200],
      ),
      locale: appSettings.languageCode != null
          ? Locale(appSettings.languageCode!, appSettings.countryCode)
          : null,
      localeListResolutionCallback: (locales, supportedLocales) {
        if (locales != null) {
          for (var locale in locales) {
            var supportedLocale = supportedLocales.where((element) =>
                element.languageCode == locale.languageCode &&
                element.countryCode == locale.countryCode);
            if (supportedLocale.isNotEmpty) {
              return supportedLocale.first;
            }
            supportedLocale = supportedLocales.where(
                (element) => element.languageCode == locale.languageCode);
            if (supportedLocale.isNotEmpty) {
              return supportedLocale.first;
            }
          }
        }
        return null;
      },
    );
  }
}

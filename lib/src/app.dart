import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:window_size/window_size.dart';

import 'globals.dart';
import 'mixins/preferences_mixin.dart';
import 'model/app_theme.dart';
import 'pages/main_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with PreferencesMixin {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: getPreference<bool>(prefThemeMode),
      builder: (context, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            context.read<AppTheme>().useDarkModeSilently = snapshot.data!;
          }
          return Consumer<AppTheme>(
            builder: (context, appTheme, _) => MaterialApp(
              theme: ThemeData(primarySwatch: Colors.pink),
              darkTheme: ThemeData.dark(),
              themeMode: appTheme.themeMode,
              home: const MainPage(),
              supportedLocales: const [
                /*
                 * List of locales (language + country) we have translations for.
                 *
                 * If there is a file for the tuple (langue, country) in assets/lib/i18n, then this
                 * will be used for translation.
                 *
                 * If there is not, then we'll look for a file for the language only.
                 *
                 * If there is no file for the language code, we'll fallback to the english file.
                 *
                 * Example : let's say the locale is fr_CH. We will look for "assets/lib/i18n/fr_CH.po",
                 * "assets/lib/i18n/fr.po", and "assets/lib/i18n/en.po", stopping at the first file we
                 * find.
                 *
                 * Translation files are not merged, meaning if some translations are missing in fr_CH.po
                 * but are present in fr.po, the missing translations will not be picked up from fr.po,
                 * and thus will show up in english.
                 */
                Locale('cy'),
                Locale('de'),
                Locale('en'),
                Locale('fr'),
                Locale('fr', 'CH'),
                Locale('gd'),
                Locale('it'),
                Locale('oc'),
                Locale('nl'),
                Locale('no'),
                Locale('ru'),
              ],
              localizationsDelegates: [
                GettextLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              localeListResolutionCallback: (locales, supportedLocales) {
                if (locales != null) {
                  for (var locale in locales) {
                    var supportedLocale =
                        supportedLocales.where((element) => element.languageCode == locale.languageCode && element.countryCode == locale.countryCode);
                    if (supportedLocale.isNotEmpty) {
                      return supportedLocale.first;
                    }
                    supportedLocale = supportedLocales.where((element) => element.languageCode == locale.languageCode);
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
  }
}

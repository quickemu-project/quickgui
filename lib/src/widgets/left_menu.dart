import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:provider/provider.dart';
import 'package:quickgui/src/supported_locales.dart';

import '../globals.dart';
import '../mixins/app_version.dart';
import '../mixins/preferences_mixin.dart';
import '../model/app_settings.dart';

class LeftMenu extends StatefulWidget {
  const LeftMenu({super.key});

  @override
  State<LeftMenu> createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> with PreferencesMixin {
  late String currentLocale;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var appSettings = context.read<AppSettings>();
    currentLocale = appSettings.activeLocale;
    if (!supportedLocales.contains(currentLocale)) {
      currentLocale = currentLocale.split("_")[0];
      if (!supportedLocales.contains(currentLocale)) {
        currentLocale = "en";
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _version = AppVersion.packageInfo!.version;
    return Consumer<AppSettings>(
      builder: (context, appSettings, _) {
        return Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text("Quickgui $_version",
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              /*
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(context.t('Use dark mode')),
                    Expanded(
                      child: Container(),
                    ),
                    Switch(
                      value: Theme.of(context).colorScheme.brightness == Brightness.dark,
                      onChanged: (value) {
                        appSettings.useDarkMode = value;
                        savePreference(prefThemeMode, value);
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.black26,
                      inactiveThumbColor: Theme.of(context).colorScheme.onPrimary,
                      inactiveTrackColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
              */
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(context.t('Language')),
                    Expanded(
                      child: Container(),
                    ),
                    DropdownButton<String>(
                      value: currentLocale,
                      items: supportedLocales
                          .map(
                              (e) => DropdownMenuItem(child: Text(e), value: e))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          currentLocale = value!;
                          appSettings.activeLocale = currentLocale;
                          savePreference(prefCurrentLocale, currentLocale);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

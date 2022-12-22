import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:provider/provider.dart';
import 'package:quickgui/src/supported_locales.dart';

import '../globals.dart';
import '../mixins/app_version.dart';
import '../mixins/preferences_mixin.dart';
import '../model/app_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with PreferencesMixin {
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
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText(context.t('Settings')),
        actions: const [
          PlatformWindowButtons(),
        ],
      ),
      body: Consumer<AppSettings>(
        builder: (context, appSettings, _) {
          return ListView(
            children: [
              const SizedBox(height: 16),
              Center(
                child: PlatformText.subheading(
                  "Quickgui $_version",
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: PlatformTheme.of(context).secondaryBackgroundColor,
                elevation: platform == TargetPlatform.macOS ? 0 : null,
                child: PlatformListTile(
                  title: PlatformText(context.t('Use dark mode')),
                  trailing: PlatformDropDownMenu<ThemeMode>(
                    value: appSettings.themeMode,
                    items: [
                      PlatformDropDownMenuItem(
                        child: PlatformText(context.t('System')),
                        value: ThemeMode.system,
                      ),
                      PlatformDropDownMenuItem(
                        child: PlatformText(context.t('Light')),
                        value: ThemeMode.light,
                      ),
                      PlatformDropDownMenuItem(
                        child: PlatformText(context.t('Dark')),
                        value: ThemeMode.dark,
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        appSettings.themeMode = value!;
                        savePreference(
                          prefThemeMode,
                          value.name,
                        );
                      });
                    },
                  ),
                ),
              ),
              Card(
                color: PlatformTheme.of(context).secondaryBackgroundColor,
                elevation: platform == TargetPlatform.macOS ? 0 : null,
                child: PlatformListTile(
                  title: PlatformText(context.t('Language')),
                  trailing: PlatformDropDownMenu<String>(
                    value: currentLocale,
                    items: supportedLocales.map(
                      (e) {
                        return PlatformDropDownMenuItem(
                          child: PlatformText(e),
                          value: e,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        currentLocale = value!;
                        appSettings.activeLocale = currentLocale;
                        savePreference(prefCurrentLocale, currentLocale);
                      });
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

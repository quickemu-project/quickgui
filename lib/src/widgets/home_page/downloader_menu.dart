import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:platform_ui/platform_ui.dart';

import '../../globals.dart';
import '../../mixins/preferences_mixin.dart';
import '../home_page/home_page_button_group.dart';

class DownloaderMenu extends StatefulWidget {
  const DownloaderMenu({Key? key}) : super(key: key);

  @override
  State<DownloaderMenu> createState() => _DownloaderMenuState();
}

class _DownloaderMenuState extends State<DownloaderMenu> with PreferencesMixin {
  @override
  void initState() {
    super.initState();
    getPreference<String>(prefWorkingDirectory).then((pref) {
      setState(() {
        Directory.current = pref;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlatformText(
                  "${context.t('Directory where the machines are stored')}:",
                ),
                const SizedBox(
                  width: 8,
                ),
                PlatformFilledButton(
                  child: Row(
                    children: [
                      PlatformText(Directory.current.path),
                      const SizedBox(width: 8),
                      const Icon(Icons.folder_outlined),
                    ],
                  ),
                  isSecondary: true,
                  onPressed: () async {
                    var folder = await FilePicker.platform
                        .getDirectoryPath(dialogTitle: "Pick a folder");
                    if (folder != null) {
                      setState(() {
                        Directory.current = folder;
                      });
                      savePreference(
                          prefWorkingDirectory, Directory.current.path);
                    }
                  },
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: HomePageButtonGroup(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

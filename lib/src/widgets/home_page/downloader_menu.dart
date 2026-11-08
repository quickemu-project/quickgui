import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';

import '../../globals.dart';
import '../../mixins/preferences_mixin.dart';
import '../home_page/home_page_button_group.dart';

class DownloaderMenu extends StatefulWidget {
  const DownloaderMenu({super.key});

  @override
  State<DownloaderMenu> createState() => _DownloaderMenuState();
}

class _DownloaderMenuState extends State<DownloaderMenu> with PreferencesMixin {
  String _currentPath = Directory.current.path;

  @override
  void initState() {
    super.initState();
    getPreference<String>(prefWorkingDirectory).then((pref) {
      if (pref != null && pref.isNotEmpty && Directory(pref).existsSync()) {
        setState(() {
          Directory.current = pref;
          _currentPath = pref;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${context.t('Directory where the machines are stored')}:",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    onPressed: () async {
                      var folder = await FilePicker.platform
                          .getDirectoryPath(dialogTitle: "Pick a folder");
                      if (folder != null && folder.isNotEmpty) {
                        setState(() {
                          Directory.current = folder;
                          _currentPath = folder;
                        });
                        savePreference(prefWorkingDirectory, folder);
                      }
                    },
                    child: Text(_currentPath),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 2),
            const Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
      ),
    );
  }
}

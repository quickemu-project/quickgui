import 'dart:io';
import 'package:quickgui/src/globals.dart';
import 'package:quickgui/src/mixins/preferences_mixin.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quickgui/src/widgets/home_page/home_page_button_group.dart';

class DownloaderMenu extends StatefulWidget {
  const DownloaderMenu({Key? key}) : super(key: key);

  @override
  State<DownloaderMenu> createState() => _DownloaderMenuState();
}

class _DownloaderMenuState extends State<DownloaderMenu> with PreferencesMixin {
  @override
  void initState() {
    super.initState();
    getPreference(prefWorkingDirectory).then((pref) {
      if (pref is String) {
        setState(() {
          Directory.current = pref;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Working directory : ${Directory.current.path}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).canvasColor,
                    onPrimary: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    var folder = await FilePicker.platform.getDirectoryPath(dialogTitle: "Pick a folder");
                    if (folder != null) {
                      setState(() {
                        Directory.current = folder;
                      });
                      savePreference(prefWorkingDirectory, Directory.current.path);
                    }
                  },
                  child: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

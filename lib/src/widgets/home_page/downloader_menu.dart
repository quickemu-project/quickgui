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
          InkWell(
            onTap: () async {
              var folder = await FilePicker.platform
                  .getDirectoryPath(dialogTitle: "Pick a folder");
              if (folder != null) {
                setState(() {
                  Directory.current = folder;
                });
                savePreference(prefWorkingDirectory, Directory.current.path);
              }
            },
            child: Text(
              "Working directory : ${Directory.current.path}",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

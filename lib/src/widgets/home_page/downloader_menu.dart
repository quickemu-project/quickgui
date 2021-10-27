import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quickgui/src/globals.dart';
import 'package:quickgui/src/widgets/home_page/home_page_button_group.dart';

class DownloaderMenu extends StatefulWidget {
  const DownloaderMenu({Key? key}) : super(key: key);

  @override
  State<DownloaderMenu> createState() => _DownloaderMenuState();
}

class _DownloaderMenuState extends State<DownloaderMenu> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.pink,
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
                var folder = await FilePicker.platform.getDirectoryPath(dialogTitle: "Pick a folder");
                if (folder != null) {
                  setState(() {
                    gCurrentDirectoy = Directory(folder);
                  });
                }
              },
              child: Text(
                "Working directory : ${gCurrentDirectoy.path}",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quickgui/src/globals.dart';
import 'package:quickgui/src/widgets/home_page_buttons.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    //Directory.current = '/home/yannick';
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
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
                              child: HomePageButtons(),
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
          ),
        ],
      ),
    );
  }
}

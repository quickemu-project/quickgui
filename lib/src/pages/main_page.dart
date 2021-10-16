import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickgui/src/model/operating_system.dart';
import 'package:quickgui/src/model/version.dart';
import 'package:quickgui/src/pages/operating_system_page.dart';
import 'package:quickgui/src/pages/operating_system_selection.dart';
import 'package:quickgui/src/pages/version_selection.dart';
import 'package:quickgui/src/widgets/home_page_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  OperatingSystem? _selectedOperatingSystem;
  Version? _selectedVersion;

  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        HomePageButton(
                          label: "Operating system",
                          text: _selectedOperatingSystem?.name ?? 'Select...',
                          onPressed: () {
                            Navigator.of(context)
                                .push<OperatingSystem>(MaterialPageRoute(fullscreenDialog: true, builder: (context) => const OperatingSystemSelection()))
                                .then((selection) {
                              if (selection != null) {
                                setState(() {
                                  _selectedOperatingSystem = selection;
                                  _selectedVersion = null;
                                });
                              }
                            });
                          },
                        ),
                        HomePageButton(
                          label: "Version",
                          text: _selectedVersion?.name ?? 'Select...',
                          onPressed: (_selectedOperatingSystem != null)
                              ? () {
                                  Navigator.of(context)
                                      .push<Version>(MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => VersionSelection(operatingSystem: _selectedOperatingSystem!),
                                  ))
                                      .then((selection) {
                                    if (selection != null) {
                                      setState(() {
                                        _selectedVersion = selection;
                                      });
                                    }
                                  });
                                }
                              : null,
                        ),
                        HomePageButton(
                          text: 'Download',
                          onPressed: (_selectedVersion == null)
                              ? null
                              : () async {
                                  showLoadingIndicator(text: 'Downloading');
                                  await Process.run('quickget', [_selectedOperatingSystem!.code!, _selectedVersion!.code!]);
                                  print('Finished !');
                                  hideOpenDialog();
                                  Navigator.of(context).pop();
                                },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLoadingIndicator({String text = ''}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          backgroundColor: Colors.black87,
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text('Downloading...', style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.white)),
                ),
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'Target : ${Directory.current.absolute.path}',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void hideOpenDialog() {
    Navigator.of(context).pop();
  }
}

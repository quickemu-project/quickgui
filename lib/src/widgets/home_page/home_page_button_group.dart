import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../../model/operating_system.dart';
import '../../model/option.dart';
import '../../model/version.dart';
import '../../pages/downloader.dart';
import '../../pages/operating_system_selection.dart';
import '../../pages/version_selection.dart';
import '../../i18n/i18n_ext.dart';
import '../home_page/home_page_button.dart';

class HomePageButtonGroup extends StatefulWidget {
  const HomePageButtonGroup({Key? key}) : super(key: key);

  @override
  State<HomePageButtonGroup> createState() => _HomePageButtonGroupState();
}

class _HomePageButtonGroupState extends State<HomePageButtonGroup> {
  OperatingSystem? _selectedOperatingSystem;
  Version? _selectedVersion;
  Option? _selectedOption;

  @override
  Widget build(BuildContext context) {
    var _versionButtonLabel = _selectedVersion?.version ?? context.t('Select...');
    if (_selectedOption?.option.isNotEmpty ?? false) {
      _versionButtonLabel = "$_versionButtonLabel (${_selectedOption!.option})";
    }
    return Row(
      children: [
        HomePageButton(
          label: context.t("Operating system"),
          text: _selectedOperatingSystem?.name ?? context.t('Select...'),
          onPressed: () {
            Navigator.of(context)
                .push<OperatingSystem>(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const OperatingSystemSelection()))
                .then((selection) {
              if (selection != null) {
                setState(() {
                  _selectedOperatingSystem = selection;
                  if (selection.versions.length == 1 &&
                      selection.versions.first.options.length == 1) {
                    _selectedVersion = selection.versions.first;
                    _selectedOption = selection.versions.first.options.first;
                  } else {
                    _selectedVersion = null;
                    _selectedOption = null;
                  }
                });
              }
            });
          },
        ),
        HomePageButton(
          label: context.t('Version'),
          text: _versionButtonLabel, //_selectedVersion?.version ?? 'Select...',
          onPressed: (_selectedOperatingSystem != null)
              ? () {
                  Navigator.of(context)
                      .push<Tuple2<Version, Option?>>(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => VersionSelection(operatingSystem: _selectedOperatingSystem!),
                  ))
                      .then((selection) {
                    if (selection != null) {
                      setState(() {
                        _selectedVersion = selection.item1;
                        _selectedOption = selection.item2;
                      });
                    }
                  });
                }
              : null,
        ),
        HomePageButton(
          label: context.t('Download'),
          text: context.t('Download'),
          onPressed: (_selectedVersion == null)
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Downloader(
                        operatingSystem: _selectedOperatingSystem!,
                        version: _selectedVersion!,
                        option: _selectedOption,
                      ),
                    ),
                  );
                },
        ),
      ],
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
                  child: Text(context.t('Downloading...'), style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.white)),
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

  void hideLoadingIndicator() {
    Navigator.of(context).pop();
  }

  void showDoneDialog({required String operatingSystem, required String version}) {
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
                  child: Text(context.t('Done !'), style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.white)),
                ),
                Text(context.t('Now run {0} to start the VM', args: ["quickemu --vm $operatingSystem-$version"]),
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.white)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Dismiss',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

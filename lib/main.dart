import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickgui/src/app.dart';
import 'package:quickgui/src/globals.dart';
import 'package:quickgui/src/model/operating_system.dart';
import 'package:quickgui/src/model/option.dart';
import 'package:quickgui/src/model/version.dart';
import 'package:tuple/tuple.dart';
import 'package:window_size/window_size.dart';

Future<List<OperatingSystem>> loadOperatingSystems(bool showUbuntus) async {
  var process = await Process.run('quickget', ['list_csv']);
  var stdout = process.stdout as String;
  var output = <OperatingSystem>[];

  OperatingSystem? currentOperatingSystem;
  Version? currentVersion;

  stdout.split('\n').skip(1).where((element) => element.isNotEmpty).map((e) => e.trim()).forEach((element) {
    var chunks = element.split(",");
    Tuple5 supportedVersion;
    if (chunks.length == 4) // Legacy version of quickget
    {
      supportedVersion = Tuple5.fromList([...chunks, "wget"]);
    } else {
      supportedVersion = Tuple5.fromList(chunks);
    }

    if (currentOperatingSystem?.code != supportedVersion.item2) {
      currentOperatingSystem = OperatingSystem(supportedVersion.item1, supportedVersion.item2);
      output.add(currentOperatingSystem!);
      currentVersion = null;
    }
    if (currentVersion?.version != supportedVersion.item3) {
      currentVersion = Version(supportedVersion.item3);
      currentOperatingSystem!.versions.add(currentVersion!);
    }
    currentVersion!.options.add(Option(supportedVersion.item4, supportedVersion.item5));
  });

  return output;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory.current = gCurrentDirectoy;
  setWindowTitle('Quickgui : a flutter frontend for Quickget and Quickemu');
  setWindowMinSize(const Size(692, 580));
  setWindowMaxSize(const Size(692, 580));
  gOperatingSystems = await loadOperatingSystems(false);

  runApp(const App());
}

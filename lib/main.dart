import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickgui/src/app.dart';
import 'package:quickgui/src/model/operating_system.dart';
import 'package:quiver/iterables.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle('Quickgui : a flutter frontend for Quickget and Quickemu');
  setWindowMinSize(const Size(692, 580));
  setWindowMaxSize(const Size(692, 580));
  var config = await loadOperatingSystems(false);

  runApp(const App());
}

Future<List<OperatingSystem>> loadOperatingSystems(bool showUbuntus) async {
  var file = File('list.csv');
  var fileExists = file.existsSync();
  if (fileExists) {
    Stream<String> lines = file
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .skip(1);
    await for (var line in lines) {
      print(line);
    }
    return [];
  } else {
    return await Process.run('quickget', [])
        .then<List<OperatingSystem>>((process) {
      var stdout = process.stdout as String;
      var codes = stdout.split('\n')[1].split(' ').where((element) =>
          showUbuntus ? element.contains('buntu') : !element.contains('buntu'));
      var names = codes.map((code) => code
          .toLowerCase()
          .split('-')
          .map((e) => e[0].toUpperCase() + e.substring(1))
          .join(' '));
      List<OperatingSystem> items = [];
      if (!showUbuntus) {
        items.add(OperatingSystem(name: 'Ubuntu', hasMore: true));
      }
      items.addAll(zip([codes, names])
          .map((item) => OperatingSystem(code: item[0], name: item[1]))
          .toList());
      items.sort((a, b) => a.name.compareTo(b.name));

      return items;
    });
  }
}

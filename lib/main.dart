import 'package:flutter/material.dart';
import 'package:quickgui/src/app.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle('Quickgui : a flutter frontend for Quickget and Quickemu');
  setWindowMinSize(const Size(692, 580));
  setWindowMaxSize(const Size(692, 580));
  runApp(const App());
}

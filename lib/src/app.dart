import 'package:flutter/material.dart';
import 'package:quickgui/src/pages/main_page.dart';
import 'package:yaru/yaru.dart' as yaru;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: yaru.lightTheme,
        darkTheme: yaru.darkTheme,
        home: const MainPage(
            title: 'Quickgui - A Flutter frontend for Quickget and Quickemu'));
  }
}

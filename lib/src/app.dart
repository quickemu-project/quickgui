import 'package:flutter/material.dart';
import 'package:quickgui/src/pages/main_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      darkTheme: ThemeData.dark(),
      home: const MainPage(title: 'Quickgui - A Flutter frontend for Quickget and Quickemu'),
    );
  }
}

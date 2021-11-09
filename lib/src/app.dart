import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickgui/src/model/app_theme.dart';
import 'package:quickgui/src/pages/main_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => MaterialApp(
        theme: ThemeData(primarySwatch: Colors.pink),
        darkTheme: ThemeData.dark(),
        themeMode: appTheme.themeMode,
        home: const MainPage(title: 'Quickgui - A Flutter frontend for Quickget and Quickemu'),
      ),
    );
  }
}

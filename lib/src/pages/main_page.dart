import 'package:flutter/material.dart';
import 'package:quickgui/src/widgets/home_page/logo.dart';
import 'package:quickgui/src/widgets/home_page/main_menu.dart';
import 'package:quickgui/src/widgets/left_menu.dart';
import 'package:quickgui/src/i18n/i18n_ext.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Main menu')),
      ),
      drawer: const LeftMenu(),
      body: Column(
        children: const [
          Logo(),
          MainMenu(),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickgui/src/widgets/home_page/logo.dart';
import 'package:quickgui/src/widgets/home_page/main_menu.dart';

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
        title: const Text('Main menu'),
        leading: IconButton(
          onPressed: () {
            exit(0);
          },
          icon: const Icon(Icons.exit_to_app),
        ),
      ),
      body: Column(
        children: const [
          Logo(),
          MainMenu(),
        ],
      ),
    );
  }
}

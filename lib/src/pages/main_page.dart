import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:window_size/window_size.dart';

import '../widgets/home_page/logo.dart';
import '../widgets/home_page/main_menu.dart';
import '../widgets/left_menu.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setWindowTitle(
        context.t('Quickgui : a Flutter frontend for Quickget and Quickemu'));
  }

  @override
  Widget build(BuildContext context) {
    GettextLocalizations.of(context).enableExceptions(true);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Main menu')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      drawer: const LeftMenu(),
      body: const Column(
        children: [
          Logo(),
          MainMenu(),
        ],
      ),
    );
  }
}

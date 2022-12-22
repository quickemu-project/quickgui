import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:window_size/window_size.dart';

import '../widgets/home_page/logo.dart';
import '../widgets/home_page/main_menu.dart';
import '../widgets/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

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
    return PlatformScaffold(
      appBar: PlatformAppBar(
        automaticallyImplyLeading: false,
        title: PlatformText.subheading(context.t('Quickgui')),
        centerTitle: true,
        actions: [
          PlatformIconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          const PlatformWindowButtons(),
        ],
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

import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:platform_ui/platform_ui.dart';

import '../widgets/home_page/downloader_menu.dart';
import '../widgets/home_page/logo.dart';

class DownloaderPage extends StatelessWidget {
  const DownloaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText(context.t('Downloader')),
        actions: const [
          PlatformWindowButtons(),
        ],
      ),
      body: Column(
        children: const [
          Logo(),
          DownloaderMenu(),
        ],
      ),
    );
  }
}

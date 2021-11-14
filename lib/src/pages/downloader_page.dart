import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';

import '../widgets/home_page/downloader_menu.dart';
import '../widgets/home_page/logo.dart';

class DownloaderPage extends StatelessWidget {
  const DownloaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Downloader')),
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

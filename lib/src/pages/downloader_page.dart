import 'package:flutter/material.dart';
import 'package:quickgui/src/widgets/home_page/downloader_menu.dart';
import 'package:quickgui/src/widgets/home_page/logo.dart';
import 'package:quickgui/src/i18n/i18n_ext.dart';

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

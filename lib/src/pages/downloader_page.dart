import 'package:flutter/material.dart';
import 'package:quickgui/src/widgets/home_page/downloader_menu.dart';
import 'package:quickgui/src/widgets/home_page/logo.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';

class DownloaderPage extends StatelessWidget {
  const DownloaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(YaruIcons.window_close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Downloader'),
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

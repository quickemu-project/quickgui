import 'package:flutter/cupertino.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:platform_ui/platform_ui.dart';

import '../../pages/downloader_page.dart';
import '../../pages/manager.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlatformFilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const Manager(),
                  ),
                );
              },
              child: PlatformText(context.t('Manage existing machines')),
            ),
            const SizedBox(width: 8),
            PlatformFilledButton(
              onPressed: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DownloaderPage()));
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const DownloaderPage(),
                  ),
                );
              },
              child: PlatformText(context.t('Create new machines')),
            ),
          ],
        ),
      ),
    );
  }
}

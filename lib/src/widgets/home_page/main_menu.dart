import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';

import '../../pages/downloader_page.dart';
import '../../pages/manager.dart';
import '../home_page/home_page_button.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomePageButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      fullscreenDialog: true,
                      pageBuilder: (context, animation1, animation2) =>
                          const Manager(),
                      transitionDuration: Duration.zero,
                    ),
                  );
                },
                text: context.t('Manage existing machines'),
              ),
              HomePageButton(
                onPressed: () {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DownloaderPage()));
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      fullscreenDialog: true,
                      pageBuilder: (context, animation1, animation2) =>
                          const DownloaderPage(),
                      transitionDuration: Duration.zero,
                    ),
                  );
                },
                text: context.t('Create new machines'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quickgui/src/pages/downloader_page.dart';
import 'package:quickgui/src/pages/manager.dart';
import 'package:quickgui/src/widgets/home_page/home_page_button.dart';
import 'package:quickgui/src/i18n/i18n_ext.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
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
                      pageBuilder: (context, animation1, animation2) => const Manager(),
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
                      pageBuilder: (context, animation1, animation2) => const DownloaderPage(),
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

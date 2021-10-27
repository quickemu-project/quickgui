import 'package:flutter/material.dart';
import 'package:quickgui/src/pages/downloader_page.dart';
import 'package:quickgui/src/widgets/home_page/home_page_button.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.pink,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomePageButton(
                onPressed: () {},
                text: 'Manage existing machines',
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
                text: 'Create new machines',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

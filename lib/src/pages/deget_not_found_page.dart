import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:quickgui/src/widgets/title_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class DebgetNotFoundPage extends StatelessWidget {
  const DebgetNotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: TitleBar(
        title: PlatformText.subheading('Quickgui'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PlatformText(
              'quickemu was not found in your PATH',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const PlatformText(
              'Please install it and try again.',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                ),
                text: 'See ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(
                          Uri.parse(
                              'https://github.com/quickemu-project/quickemu'),
                        );
                      },
                    text: 'github.com/quickemu-project/quickemu',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  const TextSpan(text: ' for more information'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

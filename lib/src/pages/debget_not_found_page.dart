import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class DebgetNotFoundPage extends StatelessWidget {
  const DebgetNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.t('quickemu was not found in your PATH'),
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              context.t('Please install it and try again.'),
              style: const TextStyle(
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
                text: context.t('See'),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(
                          Uri.parse(
                              'https://github.com/quickemu-project/quickemu'),
                        );
                      },
                    text: ' github.com/quickemu-project/quickemu ',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: context.t('for more information')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

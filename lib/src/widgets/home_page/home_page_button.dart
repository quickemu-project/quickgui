import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';

class HomePageButton extends StatelessWidget {
  const HomePageButton({
    Key? key,
    this.label,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  final String? label;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Center(
              child: PlatformText.label(
                label?.toUpperCase() ?? '',
              ),
            ),
          ),
          PlatformFilledButton(
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: PlatformText(text),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 24, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Center(
                child: Text(
                  label?.toUpperCase() ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).canvasColor,
                onPrimary: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Theme.of(context).colorScheme.primary,
              ),
              onPressed: onPressed,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text(text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

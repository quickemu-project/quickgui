import 'package:flutter/material.dart';

class HomePageButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const HomePageButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.pink,
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Text(
              text.toUpperCase(),
            ),
          ),
        ),
      ),
    );
  }
}

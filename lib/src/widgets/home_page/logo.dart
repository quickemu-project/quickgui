import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/logo_pink.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

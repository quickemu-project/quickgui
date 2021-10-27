import 'package:flutter/material.dart';

class CancelDismissButton extends StatelessWidget {
  const CancelDismissButton({
    Key? key,
    required this.downloadFinished,
  }) : super(key: key);

  final bool downloadFinished;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: !downloadFinished
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
            child: downloadFinished ? const Text('Dimiss') : const Text('Cancel'),
          )
        ],
      ),
    );
  }
}

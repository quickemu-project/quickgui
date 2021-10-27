import 'package:flutter/material.dart';

class CancelDismissButton extends StatelessWidget {
  const CancelDismissButton({
    Key? key,
    required this.downloadFinished,
    required this.onCancel,
  }) : super(key: key);

  final bool downloadFinished;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: !downloadFinished
                ? onCancel
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

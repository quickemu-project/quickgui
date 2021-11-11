import 'package:flutter/material.dart';
import 'package:quickgui/src/i18n/i18n_ext.dart';

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
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.surface,
            ),
            onPressed: !downloadFinished
                ? onCancel
                : () {
                    Navigator.of(context).pop();
                  },
            child: downloadFinished ? Text(context.t('Dismiss')) : Text(context.t('Cancel')),
          )
        ],
      ),
    );
  }
}

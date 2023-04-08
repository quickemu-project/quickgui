import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';

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
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Theme.of(context).colorScheme.primary,
            ),
            onPressed: !downloadFinished
                ? onCancel
                : () {
                    Navigator.of(context).pop();
                  },
            child: downloadFinished
                ? Text(context.t('Dismiss'))
                : Text(context.t('Cancel')),
          )
        ],
      ),
    );
  }
}

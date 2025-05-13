import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:quickgui/src/pages/manager.dart';

class ManageMachinesAfterDownloadButton extends StatelessWidget {
  const ManageMachinesAfterDownloadButton({
    required this.downloadFinished,
    required this.vmName,
    super.key,
  });

  final bool downloadFinished;
  final String vmName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          downloadFinished
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Manager(
                          newVmName: vmName,
                        ),
                      ),
                    );
                  },
                  child: Text(context.t('Manage existing machines')),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

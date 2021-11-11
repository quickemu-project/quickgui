import 'package:flutter/material.dart';
import 'package:quickgui/src/i18n/i18n_ext.dart';

class DownloadLabel extends StatelessWidget {
  const DownloadLabel({Key? key, required this.downloadFinished, required this.data, required this.downloader}) : super(key: key);

  final bool downloadFinished;
  final double? data;
  final String downloader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: downloadFinished
          ? Text(context.t('Download finished.'))
          : data != null
              ? downloader != 'zsync'
                  ? downloader == 'wget'
                      ? Text('${context.t('Downloading...')}${(data! * 100).toInt()}%')
                      : Text('$data ${context.t('Mbs downloaded')}')
                  : Text(context.t("Downloading (no progress available)..."))
              : Text(context.t('Waiting for download to start')),
    );
  }
}

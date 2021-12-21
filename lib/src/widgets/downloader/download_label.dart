import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';

class DownloadLabel extends StatelessWidget {
  const DownloadLabel(
      {Key? key,
      required this.downloadFinished,
      required this.data,
      required this.downloader})
      : super(key: key);

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
                      ? Text(context.t('Downloading...{0}%',
                          args: [(data! * 100).toInt()]))
                      : Text(context.t('{0} Mbs downloaded', args: [data!]))
                  : Text(context.t("Downloading (no progress available)..."))
              : Text(context.t('Waiting for download to start')),
    );
  }
}

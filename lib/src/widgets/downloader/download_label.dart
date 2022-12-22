import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:platform_ui/platform_ui.dart';

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
          ? PlatformText(context.t('Download finished.'))
          : data != null
              ? downloader != 'zsync'
                  ? downloader == 'wget' || downloader == 'aria2c'
                      ? PlatformText(context.t('Downloading... {0}%',
                          args: [(data! * 100).toInt()]))
                      : PlatformText(
                          context.t('{0} Mbs downloaded', args: [data!]))
                  : PlatformText(
                      context.t("Downloading (no progress available)..."))
              : PlatformText(context.t('Waiting for download to start')),
    );
  }
}

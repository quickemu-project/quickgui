import 'package:flutter/material.dart';

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
          ? const Text('Download finished.')
          : data != null
              ? downloader != 'zsync'
                  ? downloader == 'wget'
                      ? Text('Downloading...${(data! * 100).toInt()}%')
                      : Text('$data Mbs downloaded')
                  : const Text("Downloading (no progress available)...")
              : const Text('Waiting for download to start'),
    );
  }
}

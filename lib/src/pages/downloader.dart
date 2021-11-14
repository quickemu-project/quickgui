import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:desktop_notifications/desktop_notifications.dart';
import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';

import '../model/operating_system.dart';
import '../model/option.dart';
import '../model/version.dart';
import '../widgets/downloader/cancel_dismiss_button.dart';
import '../widgets/downloader/download_label.dart';
import '../widgets/downloader/download_progress_bar.dart';

class Downloader extends StatefulWidget {
  const Downloader({
    Key? key,
    required this.operatingSystem,
    required this.version,
    this.option,
  }) : super(key: key);

  final OperatingSystem operatingSystem;
  final Version version;
  final Option? option;

  @override
  _DownloaderState createState() => _DownloaderState();
}

class _DownloaderState extends State<Downloader> {
  final notificationsClient = NotificationsClient();
  final wgetPattern = RegExp("( [0-9.]+%)");
  final macRecoveryPattern = RegExp("([0-9]+\\.[0-9])");
  late final Stream<double> _progressStream;
  bool _downloadFinished = false;
  var controller = StreamController<double>();
  Process? _process;

  @override
  void initState() {
    _progressStream = progressStream();
    super.initState();
  }

  void parseWgetProgress(String line) {
    var matches = wgetPattern.allMatches(line).toList();
    if (matches.isNotEmpty) {
      var percent = matches[0].group(1);
      if (percent != null) {
        var value = double.parse(percent.replaceAll('%', '')) / 100.0;
        controller.add(value);
      }
    }
  }

  void parseMacRecoveryProgress(String line) {
    var matches = macRecoveryPattern.allMatches(line).toList();
    if (matches.isNotEmpty) {
      var size = matches[0].group(1);
      if (size != null) {
        var value = double.parse(size);
        controller.add(value);
      }
    }
  }

  Stream<double> progressStream() {
    var options = [widget.operatingSystem.code, widget.version.version];
    if (widget.option != null) {
      options.add(widget.option!.option);
    }
    Process.start('quickget', options).then((process) {
      if (widget.option!.downloader == 'wget') {
        process.stderr.transform(utf8.decoder).forEach(parseWgetProgress);
      } else if (widget.option!.downloader == 'zsync') {
        controller.add(-1);
      } else if (widget.option!.downloader == 'macrecovery') {
        process.stdout.transform(utf8.decoder).forEach(parseMacRecoveryProgress);
      }

      process.exitCode.then((value) {
        controller.close();
        setState(() {
          _downloadFinished = true;
          notificationsClient.notify(
            context.t('Download complete'),
            body: 'Download of ${widget.operatingSystem.name} has completed.',
            appName: context.t('QuickGUI'),
            expireTimeoutMs: 10000, /* 10 seconds */
          );
        });
      });

      setState(() {
        _process = process;
      });
    });
    return controller.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Downloading ${widget.operatingSystem.name} ${widget.version.version}' + (widget.option!.option.isNotEmpty ? ' (${widget.option!.option})' : ''),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _progressStream,
              builder: (context, AsyncSnapshot<double> snapshot) {
                var data = !snapshot.hasData || widget.option!.downloader != 'wget' ? null : snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DownloadLabel(
                      downloadFinished: _downloadFinished,
                      data: snapshot.hasData ? snapshot.data : null,
                      downloader: widget.option!.downloader,
                    ),
                    DownloadProgressBar(
                      downloadFinished: _downloadFinished,
                      data: snapshot.hasData ? data : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(context.t('Target folder : {0}', args: [Directory.current])),
                    ),
                  ],
                );
              },
            ),
          ),
          CancelDismissButton(
            onCancel: () {
              _process?.kill();
            },
            downloadFinished: _downloadFinished,
          ),
        ],
      ),
    );
  }
}

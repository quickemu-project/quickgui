import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickgui/src/model/operating_system.dart';
import 'package:quickgui/src/model/option.dart';
import 'package:quickgui/src/model/version.dart';

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
  final wgetPattern = RegExp("( [0-9.]+%)");
  final macRecoveryPattern = RegExp("([0-9]+\\.[0-9])");
  late final Stream<double> _progressStream;
  bool _downloadFinished = false;
  var controller = StreamController<double>();

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
      print(size);
      if (size != null) {
        var value = double.parse(size);
        print(value);
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
        print("Process exited with exit code $value");
        controller.close();
        setState(() {
          _downloadFinished = true;
        });
      });
    });
    return controller.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Downloading ${widget.operatingSystem.name} ${widget.version.version}' + (widget.option!.option.isNotEmpty ? ' (${widget.option!.option})' : '')),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _downloadFinished
                          ? const Text('Download finished.')
                          : snapshot.hasData
                              ? widget.option!.downloader != 'zsync'
                                  ? widget.option!.downloader == 'wget'
                                      ? Text('Downloading...${(snapshot.data! * 100).toInt()}%')
                                      : Text('${snapshot.data} Mbs downloaded')
                                  : const Text("Downloading (no progress available)...")
                              : const Text('Waiting for download to start'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 200,
                        child: LinearProgressIndicator(
                          value: _downloadFinished
                              ? 1
                              : snapshot.hasData
                                  ? data
                                  : null,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text("Target folder : ${Directory.current}"),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: _downloadFinished
                        ? () {
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: _downloadFinished ? const Text('Dimiss') : const Text('Cancel'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

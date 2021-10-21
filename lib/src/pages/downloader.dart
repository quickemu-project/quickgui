import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickgui/src/model/operating_system.dart';
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
  final String? option;

  @override
  _DownloaderState createState() => _DownloaderState();
}

class _DownloaderState extends State<Downloader> {
  final pattern = RegExp("( [0-9.]+%)");
  late final Stream<double> _progressStream;
  bool _downloadFinished = false;
  var controller = StreamController<double>();

  @override
  void initState() {
    _progressStream = progressStream();
    super.initState();
  }

  void parseProgress(String line) {
    print(line);
    var matches = pattern.allMatches(line).toList();
    if (matches.isNotEmpty) {
      var percent = matches[0].group(1);
      if (percent != null) {
        var value = double.parse(percent.replaceAll('%', '')) / 100.0;
        controller.add(value);
      }
    }
  }

  Stream<double> progressStream() {
    var options = [widget.operatingSystem.code, widget.version.version];
    if (widget.option != null) {
      options.add(widget.option!);
    }
    Process.start('quickget', options).then((process) {
      process.stdout.transform(utf8.decoder).forEach(parseProgress);
      process.stderr.transform(utf8.decoder).forEach(parseProgress);
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
        title: Text('Downloading ${widget.operatingSystem.name} ${widget.version.version}' + (widget.option != null ? ' (${widget.option})' : '')),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _progressStream,
              builder: (context, AsyncSnapshot<double> snapshot) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _downloadFinished
                          ? const Text('Download finished.')
                          : snapshot.hasData
                              ? Text('Downloading...${(snapshot.data! * 100).toInt()}%')
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
                                  ? snapshot.data!
                                  : null,
                        ),
                      ),
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

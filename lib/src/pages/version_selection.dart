import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickgui/src/model/operating_system.dart';
import 'package:quickgui/src/model/version.dart';
import 'package:quiver/iterables.dart';

class VersionSelection extends StatefulWidget {
  const VersionSelection({Key? key, required this.operatingSystem}) : super(key: key);

  final OperatingSystem operatingSystem;

  @override
  _VersionSelectionState createState() => _VersionSelectionState();
}

class _VersionSelectionState extends State<VersionSelection> {
  late Future<List<Version>> _future;

  @override
  void initState() {
    _future = loadOperatingSystemVersions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select version for ${widget.operatingSystem.name}'),
      ),
      body: FutureBuilder<List<Version>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          title: Text(item.name),
                          onTap: () {
                            Navigator.of(context).pop(item);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<Version>> loadOperatingSystemVersions() async {
    return Process.run('quickget', [widget.operatingSystem.code!, 'dummy']).then<List<Version>>((process) {
      var stdout = process.stdout as String;
      var versions = stdout.split('\n')[1].split(' ');
      var names =
          versions.map((version) => version.toLowerCase().split('-').map((e) => e[0].toUpperCase() + e.substring(1)).join(' ').split('_').join('.')).toList();
      List<Version> items = [];
      items.addAll(zip([versions, names]).map((e) => Version(code: e[0], name: e[1])));

      return items;
    });
  }
}

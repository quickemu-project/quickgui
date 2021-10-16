import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickgui/src/model/operating_system.dart';
import 'package:quiver/iterables.dart';

class OperatingSystemSelection extends StatefulWidget {
  const OperatingSystemSelection({Key? key, this.showUbuntus = false}) : super(key: key);

  final bool showUbuntus;

  @override
  State<OperatingSystemSelection> createState() => _OperatingSystemSelectionState();
}

class _OperatingSystemSelectionState extends State<OperatingSystemSelection> {
  late Future<List<OperatingSystem>> _future;

  @override
  void initState() {
    _future = loadOperatingSystems(widget.showUbuntus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select operating system'),
      ),
      body: FutureBuilder<List<OperatingSystem>>(
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
                          trailing: item.hasMore ? const Icon(Icons.chevron_right) : null,
                          onTap: () {
                            if (!item.hasMore) {
                              Navigator.of(context).pop(item);
                            } else {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => const OperatingSystemSelection(
                                            showUbuntus: true,
                                          )))
                                  .then((selection) {
                                if (selection != null) {
                                  Navigator.of(context).pop(selection);
                                }
                              });
                            }
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

  Future<List<OperatingSystem>> loadOperatingSystems(bool showUbuntus) async {
    return Process.run('quickget', []).then<List<OperatingSystem>>((process) {
      var stdout = process.stdout as String;
      var codes = stdout.split('\n')[1].split(' ').where((element) => showUbuntus ? element.contains('buntu') : !element.contains('buntu'));
      var names = codes.map((code) => code.toLowerCase().split('-').map((e) => e[0].toUpperCase() + e.substring(1)).join(' '));
      List<OperatingSystem> items = [];
      if (!showUbuntus) items.add(OperatingSystem(name: 'Ubuntu', hasMore: true));
      items.addAll(zip([codes, names]).map((item) => OperatingSystem(code: item[0], name: item[1])).toList());
      items.sort((a, b) => a.name.compareTo(b.name));

      return items;
    });
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickgui/src/model/operating_system.dart';
import 'package:quiver/iterables.dart';

class OperatingSystemSelection extends StatefulWidget {
  const OperatingSystemSelection({Key? key, this.showUbuntus = false})
      : super(key: key);

  final bool showUbuntus;

  @override
  State<OperatingSystemSelection> createState() =>
      _OperatingSystemSelectionState();
}

class _OperatingSystemSelectionState extends State<OperatingSystemSelection> {
  late Future<List<OperatingSystem>> _future;

  @override
  void initState() {
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
                          trailing: item.hasMore
                              ? const Icon(Icons.chevron_right)
                              : null,
                          onTap: () {
                            if (!item.hasMore) {
                              Navigator.of(context).pop(item);
                            } else {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          const OperatingSystemSelection(
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
}

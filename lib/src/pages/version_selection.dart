import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:gettext_i18n/gettext_i18n.dart';

import '../model/operating_system.dart';
import '../model/option.dart';
import '../model/version.dart';
import 'option_selection.dart';

class VersionSelection extends StatefulWidget {
  const VersionSelection({Key? key, required this.operatingSystem}) : super(key: key);

  final OperatingSystem operatingSystem;

  @override
  _VersionSelectionState createState() => _VersionSelectionState();
}

class _VersionSelectionState extends State<VersionSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Select version for {0}', args: [widget.operatingSystem.name])),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.operatingSystem.versions.length,
              itemBuilder: (context, index) {
                var item = widget.operatingSystem.versions[index];
                return Card(
                  child: ListTile(
                    title: Text(item.version),
                    onTap: () {
                      if (widget.operatingSystem.versions[index].options.length > 1) {
                        Navigator.of(context)
                            .push<Option>(
                                MaterialPageRoute(fullscreenDialog: true, builder: (context) => OptionSelection(widget.operatingSystem.versions[index])))
                            .then((selection) {
                          if (selection != null) {
                            Navigator.of(context).pop(Tuple2<Version, Option?>(item, selection));
                          }
                        });
                      } else {
                        Navigator.of(context).pop(Tuple2<Version, Option?>(item, widget.operatingSystem.versions[index].options[0]));
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

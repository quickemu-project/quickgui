import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:tuple/tuple.dart';

import '../model/operating_system.dart';
import '../model/option.dart';
import '../model/version.dart';
import 'option_selection.dart';

class VersionSelection extends StatefulWidget {
  const VersionSelection({required this.operatingSystem, super.key});

  final OperatingSystem operatingSystem;

  @override
  _VersionSelectionState createState() => _VersionSelectionState();
}

class _VersionSelectionState extends State<VersionSelection> {
  var term = "";
  final focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var list = widget.operatingSystem.versions
        .where((version) =>
            version.version.toLowerCase().contains(term.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context
            .t('Select version for {0}', args: [widget.operatingSystem.name])),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.search),
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          decoration: InputDecoration.collapsed(
                            hintText: context.t('Search version'),
                          ),
                          onChanged: (value) {
                            setState(() {
                              term = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 4),
          itemCount: list.length,
          itemBuilder: (context, index) {
            var item = list[index];
            return Card(
              child: ListTile(
                title: Text(item.version),
                onTap: () {
                  if (item.options.length > 1) {
                    Navigator.of(context)
                        .push<Option>(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => OptionSelection(list[index])))
                        .then((selection) {
                      if (selection != null) {
                        Navigator.of(context)
                            .pop(Tuple2<Version, Option?>(item, selection));
                      }
                    });
                  } else {
                    Navigator.of(context).pop(
                        Tuple2<Version, Option?>(item, list[index].options[0]));
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

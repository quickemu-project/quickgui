import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:quickgui/src/widgets/title_bar.dart';
import 'package:tuple/tuple.dart';

import '../model/operating_system.dart';
import '../model/option.dart';
import '../model/version.dart';
import 'option_selection.dart';

class VersionSelection extends StatefulWidget {
  const VersionSelection({Key? key, required this.operatingSystem})
      : super(key: key);

  final OperatingSystem operatingSystem;

  @override
  _VersionSelectionState createState() => _VersionSelectionState();
}

class _VersionSelectionState extends State<VersionSelection> {
  var term = "";
  final focusNode = FocusNode();

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var list = widget.operatingSystem.versions
        .where((version) =>
            version.version.toLowerCase().contains(term.toLowerCase()))
        .toList();

    return PlatformScaffold(
      appBar: TitleBar(
        title: PlatformText.subheading(
          context
              .t('Select version for {0}', args: [widget.operatingSystem.name]),
        ),
        leading: const PlatformBackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: PlatformTextField(
                focusNode: focusNode,
                prefixIcon: Icons.search,
                placeholder: context.t('Search version'),
                onChanged: (value) {
                  setState(() {
                    term = value;
                  });
                },
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.only(top: 4),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];
                return Card(
                  child: PlatformListTile(
                    title: PlatformText(item.version),
                    onTap: () {
                      if (item.options.length > 1) {
                        Navigator.of(context)
                            .push<Option>(MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) =>
                                    OptionSelection(list[index])))
                            .then((selection) {
                          if (selection != null) {
                            Navigator.of(context)
                                .pop(Tuple2<Version, Option?>(item, selection));
                          }
                        });
                      } else {
                        Navigator.of(context).pop(Tuple2<Version, Option?>(
                            item, list[index].options[0]));
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

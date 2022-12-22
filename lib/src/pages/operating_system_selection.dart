import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:platform_ui/platform_ui.dart';

import '../model/operating_system.dart';

class OperatingSystemSelection extends StatefulWidget {
  const OperatingSystemSelection({Key? key}) : super(key: key);

  @override
  State<OperatingSystemSelection> createState() =>
      _OperatingSystemSelectionState();
}

class _OperatingSystemSelectionState extends State<OperatingSystemSelection> {
  var term = "";
  final focusNode = FocusNode();

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var list = gOperatingSystems
        .where((os) => os.name.toLowerCase().contains(term.toLowerCase()))
        .toList();
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText(context.t('Select operating system')),
        actions: const [
          PlatformWindowButtons(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                focusNode: focusNode,
                placeholder: context.t('Search operating system'),
                prefixIcon: Icons.search,
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
                  color: PlatformTheme.of(context).secondaryBackgroundColor,
                  elevation: platform == TargetPlatform.macOS ? 0 : null,
                  child: PlatformListTile(
                    title: PlatformText(item.name),
                    leading: SvgPicture.asset(
                      "assets/quickemu-icons/${item.code}.svg",
                      key: ValueKey(item.code),
                      width: 32,
                      height: 32,
                      placeholderBuilder: (context) {
                        return const Icon(Icons.computer_rounded);
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).pop(item);
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

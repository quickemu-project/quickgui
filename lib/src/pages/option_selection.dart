import 'package:flutter/material.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:quickgui/src/widgets/title_bar.dart';

import '../model/version.dart';

class OptionSelection extends StatefulWidget {
  const OptionSelection(this.version, {Key? key}) : super(key: key);

  final Version version;

  @override
  State<OptionSelection> createState() => _OptionSelectionState();
}

class _OptionSelectionState extends State<OptionSelection> {
  var term = "";
  final focusNode = FocusNode();

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var list = widget.version.options
        .where((e) => e.option.toLowerCase().contains(term.toLowerCase()))
        .toList();

    return PlatformScaffold(
      appBar: TitleBar(
        title: PlatformText(context.t('Select option')),
        leading: const PlatformBackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.version.options.length > 6)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlatformTextField(
                  focusNode: focusNode,
                  prefixIcon: Icons.search,
                  placeholder: context.t('Search option'),
                  onChanged: (value) {
                    setState(() {
                      term = value;
                    });
                  },
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];
                return Card(
                  color: PlatformTheme.of(context).secondaryBackgroundColor,
                  elevation: platform == TargetPlatform.macOS ? 0 : null,
                  child: PlatformListTile(
                    title: PlatformText(item.option),
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

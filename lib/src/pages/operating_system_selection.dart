import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gettext_i18n/gettext_i18n.dart';

import '../model/operating_system.dart';
import '../model/osicons.dart';

class OperatingSystemSelection extends StatefulWidget {
  const OperatingSystemSelection({super.key});

  @override
  State<OperatingSystemSelection> createState() =>
      _OperatingSystemSelectionState();
}

class _OperatingSystemSelectionState extends State<OperatingSystemSelection> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Select operating system')),
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
                              hintText: context.t('Search operating system')),
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
        child: FutureBuilder(
          future: gOperatingSystems,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              List list = snapshot.data!
                  .where((os) =>
                      os.name.toLowerCase().contains(term.toLowerCase()))
                  .toList();
              return ListView.builder(
                controller: _scrollController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var item = list[index];
                  Widget icon;

                  if (osIcons.containsKey(item.code)) {
                    icon = SvgPicture.asset(
                      osIcons[item.code]!,
                      width: 32,
                      height: 32,
                    );
                  } else {
                    icon = const Icon(Icons.computer, size: 32);
                  }
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      leading: icon,
                      onTap: () {
                        Navigator.of(context).pop(item);
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(context.t('Loading available downloads')),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

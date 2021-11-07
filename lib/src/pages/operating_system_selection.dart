import 'package:flutter/material.dart';
import 'package:quickgui/src/model/operating_system.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(YaruIcons.window_close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Select operating system'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).canvasColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(YaruIcons.search),
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Search operating system'),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(top: 4),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Card(
                    child: ListTile(
                      title: Text(item.name),
                      onTap: () {
                        Navigator.of(context).pop(item);
                      },
                    ),
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

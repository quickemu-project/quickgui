import 'package:flutter/material.dart';
import 'package:quickgui/src/mixins/version_mixin.dart';

class LeftMenu extends StatelessWidget with VersionMixin {
  const LeftMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _version = version + ' (' + buildNumber + ')';
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("quickgui $_version", style: Theme.of(context).textTheme.headline6),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

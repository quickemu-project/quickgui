import 'package:flutter/material.dart';

class OperatingSystemMetadata {
  final String name;
  final String description;
  final List<OperatingSystemMetadata>? children;

  OperatingSystemMetadata({
    required this.name,
    required this.description,
    this.children,
  });
}

final Map<String, OperatingSystemMetadata> operatingSystems = {
  "ubuntu": OperatingSystemMetadata(name: "Ubuntu", description: "The mothership"),
  "*buntu*": OperatingSystemMetadata(name: "Ubuntu derivatives", description: "The many great derivatives", children: [
    OperatingSystemMetadata(name: "kUbuntu", description: "KDE-based version of Ubuntu"),
    OperatingSystemMetadata(name: "Lubuntu", description: "LxQt-based version of Ubuntu"),
    OperatingSystemMetadata(name: "Ubuntu Budgie", description: "Budgie-based version of Ubuntu"),
    OperatingSystemMetadata(name: "Ubuntu Kylin", description: "Kylin-based version of Ubuntu"),
    OperatingSystemMetadata(name: "Ubuntu MATE", description: "MATE-based version of Ubuntu"),
    OperatingSystemMetadata(name: "Ubuntu Studio", description: "Ubuntu for artists"),
    OperatingSystemMetadata(name: "Xubuntu", description: "Xfce-based version of Ubuntu"),
  ]),
  "macOS": OperatingSystemMetadata(name: "macOS", description: "The beautiful one"),
  "windows": OperatingSystemMetadata(name: "Windows", description: "Why would you want to install this ?"),
  "freebsd": OperatingSystemMetadata(name: "FreeBSD", description: "FreeBSD"),
};

class OperatingSystemPpage extends StatelessWidget {
  const OperatingSystemPpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<OperatingSystemMetadata> names = operatingSystems.entries.map((e) => e.value).toList();
    return SingleChildScrollView(
        child: ListView.builder(
      //child: ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => OperatingSystemCard(
        title: names[index].name,
        subtitle: names[index].description,
      ),
      itemCount: operatingSystems.length,
    ));
  }
}

class OperatingSystemCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const OperatingSystemCard({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const ContinuousRectangleBorder(),
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

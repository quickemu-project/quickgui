import 'dart:io';

class VmConfig {
  final String name;
  final File file;
  String rawContent = '';

  VmConfig({required this.name, required String confPath})
      : file = File(confPath);

  Future<void> load() async {
    if (file.existsSync()) {
      rawContent = await file.readAsString();
    }
  }

  Future<void> save(String updatedContent) async {
    rawContent = updatedContent;
    await file.writeAsString(rawContent);
  }
}

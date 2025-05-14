import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/vm_config.dart';

class VmConfigEditorDialog extends StatefulWidget {
  final String vmName;
  final String confPath;

  const VmConfigEditorDialog({
    super.key,
    required this.vmName,
    required this.confPath,
  });

  @override
  State<VmConfigEditorDialog> createState() => _VmConfigEditorDialogState();
}

class _VmConfigEditorDialogState extends State<VmConfigEditorDialog> {
  late VmConfig config;
  final TextEditingController _editorController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    config = VmConfig(name: widget.vmName, confPath: widget.confPath);
    config.load().then((_) {
      _editorController.text = config.rawContent;
      setState(() => _loading = false);
    });
  }

  void _save() async {
    await config.save(_editorController.text);
    if(!mounted) return;
    Navigator.of(context).pop();
  }

  void _openDocs() async {
    const url = 'https://github.com/quickemu-project/quickemu/blob/master/docs/quickemu_conf.5.md';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit VM: ${widget.vmName}'),
      content: _loading
          ? const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()))
          : SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(config.file.path,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: const Icon(Icons.help_outline),
                      label: const Text("Open config documentation"),
                      onPressed: _openDocs,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: TextField(
                      controller: _editorController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontFamily: 'monospace'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

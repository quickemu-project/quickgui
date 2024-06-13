import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gettext_i18n/gettext_i18n.dart';
import 'package:path/path.dart' as path;
import 'package:process_run/shell.dart';

import '../globals.dart';
import '../mixins/preferences_mixin.dart';
import '../model/vminfo.dart';

/// VM manager page.
/// Displays a list of available VMs, running state and connection info,
/// with buttons to start and stop VMs.
class Manager extends StatefulWidget {
  const Manager({Key? key}) : super(key: key);

  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> with PreferencesMixin {
  List<String> _currentVms = [];
  Map<String, VmInfo> _activeVms = {};
  bool _spicy = false;
  final List<String> _sshVms = [];
  String? _terminalEmulator;
  final List<String> _supportedTerminalEmulators = [
    'cool-retro-term',
    'gnome-terminal',
    'guake',
    'mate-terminal',
    'konsole',
    'lxterm',
    'lxterminal',
    'pterm',
    'sakura',
    'terminator',
    'tilix',
    'uxterm',
    'uxrvt',
    'xfce4-terminal',
    'xrvt',
    'xterm'
  ];
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    _getTerminalEmulator();
    _detectSpice();
    getPreference<String>(prefWorkingDirectory).then((pref) {
      setState(() {
        if (pref == null) {
          return;
        }
        Directory.current = pref;
      });
      Future.delayed(Duration.zero,
          () => _getVms(context)); // Reload VM list when we enter the page.
    });
    refreshTimer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      _getVms(context);
    }); // Reload VM list every 5 seconds.
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  void _getTerminalEmulator() async {
    // Find out which terminal emulator we have set as the default.
    String result = whichSync('x-terminal-emulator') ?? '';
    if (result.isNotEmpty) {
      String terminalEmulator =
          await File(result).resolveSymbolicLinks();
      terminalEmulator = path.basenameWithoutExtension(terminalEmulator);
      if (_supportedTerminalEmulators.contains(terminalEmulator)) {
        setState(() {
          _terminalEmulator = path.basename(terminalEmulator);
        });
      }
    }
  }

  void _detectSpice() async {
    var result = whichSync('spicy') ?? '';
    setState(() {
      _spicy = result.isNotEmpty ;
    });
  }

  VmInfo _parseVmInfo(name) {
    VmInfo info = VmInfo();
    File portsFile = File(name + '/' + name + '.ports');
    if (portsFile.existsSync()) {
      List<String> lines = portsFile.readAsLinesSync();
      for (var line in lines) {
        List<String> parts = line.split(',');
        switch (parts[0]) {
          case 'ssh':
            info.sshPort = parts[1];
            break;
          case 'spice':
            info.spicePort = parts[1];
            break;
        }
      }
    }
    return info;
  }

  bool _isValidConf(conf) {
    List<String> lines = File(conf).readAsLinesSync();
    for (var line in lines) {
      List<String> parts = line.split('=');
      if (parts[0] == 'guest_os') {
        return true;
      }
    }
    return false;
  }

  void _getVms(context) async {
    List<String> currentVms = [];
    Map<String, VmInfo> activeVms = {};

    await for (var entity
        in Directory.current.list(recursive: false, followLinks: true)) {
      if ((entity.path.endsWith('.conf')) && (_isValidConf(entity.path))) {
        String name = path.basenameWithoutExtension(entity.path);
        currentVms.add(name);
        File pidFile = File('$name/$name.pid');
        if (pidFile.existsSync()) {
          String pid = pidFile.readAsStringSync().trim();
          Directory procDir = Directory('/proc/$pid');
          if (procDir.existsSync()) {
            if (_activeVms.containsKey(name)) {
              activeVms[name] = _activeVms[name]!;
            } else {
              activeVms[name] = _parseVmInfo(name);
            }
          }
        }
      }
    }
    currentVms.sort();
    setState(() {
      _currentVms = currentVms;
      _activeVms = activeVms;
    });
  }

  Future<bool> _detectSsh(int port) async {
    bool isSSH = false;
    try {
      Socket socket = await Socket.connect('localhost', port);
      isSSH = await socket.any((event) => utf8.decode(event).contains('SSH'));
      socket.close();
      return isSSH;
    } catch (exception) {
      return false;
    }
  }

  Widget _buildVmList() {
    List<Widget> widgetList = [];
    final Color buttonColor = Theme.of(context).colorScheme.primary;
    widgetList.addAll(
      [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${context.t('Directory where the machines are stored')}:",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
                onPressed: () async {
                  var folder = await FilePicker.platform
                      .getDirectoryPath(dialogTitle: "Pick a folder");
                  if (folder != null) {
                    setState(() {
                      Directory.current = folder;
                    });
                    savePreference(
                        prefWorkingDirectory, Directory.current.path);
                  }
                },
                child: Text(Directory.current.path),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 2,
        ),
      ],
    );
    List<List<Widget>> rows = _currentVms.map((vm) {
      return _buildRow(vm, buttonColor);
    }).toList();
    for (var row in rows) {
      widgetList.addAll(row);
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: widgetList,
    );
  }

  List<Widget> _buildRow(String currentVm, Color buttonColor) {
    final bool active = _activeVms.containsKey(currentVm);
    final bool sshy = _sshVms.contains(currentVm);
    VmInfo vmInfo = VmInfo();
    String connectInfo = '';
    if (active) {
      vmInfo = _activeVms[currentVm]!;
      if (vmInfo.spicePort != null) {
        connectInfo += '${context.t('SPICE port')}: ${vmInfo.spicePort!} ';
      }
      if (vmInfo.sshPort != null && _terminalEmulator != null) {
        connectInfo += '${context.t('SSH port')}: ${vmInfo.sshPort!} ';
        _detectSsh(int.parse(vmInfo.sshPort!)).then((sshRunning) {
          if (sshRunning && !sshy) {
            setState(() {
              _sshVms.add(currentVm);
            });
          } else if (!sshRunning && sshy) {
            setState(() {
              _sshVms.remove(currentVm);
            });
          }
        });
      }
    }
    return <Widget>[
      ListTile(
          title: Text(currentVm),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    active ? Icons.play_arrow : Icons.play_arrow_outlined,
                    color: active ? Colors.green : buttonColor,
                    semanticLabel: active ? 'Running' : 'Run',
                  ),
                  onPressed: active
                      ? null
                      : () async {
                          Map<String, VmInfo> activeVms = _activeVms;
                          List<String> command = ['quickemu', '--vm', '$currentVm.conf'];
                          if (_spicy) {
                            command.addAll(['--display', 'spice']);
                          }
                          var shell = Shell();
                          await shell.run(command.join(' '));
                          VmInfo info = _parseVmInfo(currentVm);
                          activeVms[currentVm] = info;
                          setState(() {
                            _activeVms = activeVms;
                          });
                        }),
              IconButton(
                icon: Icon(
                  active ? Icons.stop : Icons.stop_outlined,
                  color: active ? Colors.red : null,
                  semanticLabel: active ? 'Stop' : 'Not running',
                ),
                onPressed: !active
                    ? null
                    : () {
                        showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(context.t('Stop The Virtual Machine?')),
                            content: Text(context.t(
                                'You are about to terminate the virtual machine',
                                args: [currentVm])),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(context.t('Cancel')),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(context.t('OK')),
                              ),
                            ],
                          ),
                        ).then((result) {
                          result = result ?? false;
                          if (result) {
                            var shell = Shell();
                            shell.run(['killall', currentVm].join(' '));
                            setState(() {
                              _activeVms.remove(currentVm);
                            });
                          }
                        });
                      },
              ),
              IconButton(
                icon: Icon(Icons.delete,
                    color: active ? null : buttonColor,
                    semanticLabel: 'Delete'),
                onPressed: active
                    ? null
                    : () {
                        showDialog<String?>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Delete $currentVm'),
                            content: Text('You are about to delete $currentVm. This cannot be undone. Would you like to delete the disk image but keep the configuration, or delete the whole VM?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () =>
                                    Navigator.pop(context, 'cancel'),
                              ),
                              TextButton(
                                child: const Text('Delete disk image'),
                                onPressed: () => Navigator.pop(context, 'disk'),
                              ),
                              TextButton(
                                child: const Text('Delete whole VM'),
                                onPressed: () => Navigator.pop(context, 'vm'),
                              ) // set up the AlertDialog
                            ],
                          ),
                        ).then((result) async {
                          result = result ?? 'cancel';
                          if (result != 'cancel') {
                            List<String> command = [
                              'quickemu',
                              '--vm',
                              '$currentVm.conf',
                              '--delete-$result'
                            ];
                            var shell = Shell();
                            await shell.run(command.join(' '));
                          }
                        });
                      },
              ),
            ],
          )),
      if (connectInfo.isNotEmpty)
        ListTile(
            title: Text(connectInfo, style: const TextStyle(fontSize: 12)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.monitor,
                  color: _spicy ? buttonColor : null,
                  semanticLabel: 'Connect display with SPICE',
                ),
                tooltip: _spicy
                    ? 'Connect display with SPICE'
                    : 'SPICE client not found',
                onPressed: !_spicy
                    ? null
                    : () {
                        var shell = Shell();
                        shell.run(['spicy', '-p', vmInfo.spicePort!].join(' '));
                      },
              ),
              IconButton(
                icon: SvgPicture.asset('assets/images/console.svg',
                    semanticsLabel: 'Connect with SSH',
                    colorFilter: ColorFilter.mode(sshy ? buttonColor : Colors.grey, BlendMode.srcIn)
                ),
                tooltip: sshy
                    ? 'Connect with SSH'
                    : 'SSH server not detected on guest',
                onPressed: !sshy
                    ? null
                    : () {
                        TextEditingController usernameController =
                            TextEditingController();
                        showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Launch SSH connection to $currentVm'),
                            content: TextField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                  hintText: "SSH username"),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Connect'),
                              ),
                            ],
                          ),
                        ).then((result) {
                          result = result ?? false;
                          if (result) {
                            List<String> sshArgs = [
                              'ssh',
                              '-p',
                              vmInfo.sshPort!,
                              '${usernameController.text}@localhost'
                            ];
                            // Set the arguments to execute the ssh command in the default terminal.
                            // Strip the extension as x-terminal-emulator may point to a .wrapper
                            switch (path
                                .basenameWithoutExtension(_terminalEmulator!)) {
                              case 'gnome-terminal':
                              case 'mate-terminal':
                                sshArgs.insert(0, '--');
                                break;
                              case 'xterm':
                              case 'lxterm':
                              case 'uxterm':
                              case 'konsole':
                              case 'uxrvt':
                              case 'xrvt':
                              case 'sakura':
                              case 'cool-retro-term':
                              case 'pterm':
                              case 'lxterminal':
                              case 'tilix':
                                sshArgs.insert(0, '-e');
                                break;
                              case 'terminator':
                              case 'xfce4-terminal':
                                sshArgs.insert(0, '-x');
                                break;
                              case 'guake':
                                String command = sshArgs.join(' ');
                                sshArgs = ['-e', command];
                                break;
                            }
                            sshArgs.insert(0, _terminalEmulator!);
                            var shell = Shell();
                            shell.run(sshArgs.join(' '));
                          }
                        });
                      },
              ),
            ])),
      const Divider()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Manager')),
      ),
      body: _buildVmList(),
    );
  }
}

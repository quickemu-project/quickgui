import 'dart:io';

var gIsSnap = Platform.environment['SNAP']?.isNotEmpty ?? false;
const String prefWorkingDirectory = 'workingDirectory';
const String prefThemeMode = 'themeMode';
const String prefCurrentLocale = 'currentLocale';
const String prefNewlyInstalledVms = 'newlyInstalledVms';

Future<String> fetchQuickemuVersion() async {
  // Get the version of quickemu
  var result = await Process.run('quickemu', ['--version']);

  // If successful return the trimmed version
  if (result.exitCode == 0) {
    return result.stdout.trim();
  } else {
    return '';
  }
}

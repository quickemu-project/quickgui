import 'dart:io';

var gIsSnap = Platform.environment['SNAP']?.isNotEmpty ?? false;
const String prefWorkingDirectory = 'workingDirectory';
const String prefThemeMode = 'themeMode';
const String prefCurrentLocale = 'currentLocale';

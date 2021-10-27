import 'dart:io';

import 'package:flutter/material.dart';

var gIsSnap = Platform.environment['SNAP']?.isNotEmpty ?? false;
var gCurrentDirectoy = Directory(Platform.environment['HOME'] ?? Directory.current.absolute.path);

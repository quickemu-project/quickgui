import 'package:package_info_plus/package_info_plus.dart';

mixin VersionMixin {
  static PackageInfo? packageInfo;

  String get appName => packageInfo?.appName ?? '';
  String get packageName => packageInfo?.packageName ?? '';
  String get version => packageInfo?.version ?? '';
  String get buildNumber => packageInfo?.buildNumber ?? '';
}

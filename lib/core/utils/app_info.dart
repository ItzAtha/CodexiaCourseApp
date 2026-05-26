import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static Future<String> getAppName() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    String name = info.appName;

    return name;
  }

  static Future<({String version, String buildNumber})> getAppVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    String version = info.version;
    String buildNumber = info.buildNumber;

    return (version: version, buildNumber: buildNumber);
  }
}
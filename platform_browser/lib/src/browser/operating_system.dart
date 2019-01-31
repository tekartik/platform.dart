import 'package:tekartik_platform/context.dart';

import '../browser_detect_common.dart';

class OperatingSystemBrowser implements OperatingSystem {
  final BrowserDetectCommon _detect;
  OperatingSystemBrowser(this._detect);

  @override
  bool get isWindows => _detect.isWindows;

  @override
  bool get isMac => _detect.isMac;

  @override
  bool get isLinux => _detect.isLinux;

  @override
  bool get isAndroid => _detect.isMobileAndroid;

  @override
  bool get isIOS => _detect.isMobileIOS;

  String get _platformText {
    String platform;
    if (isWindows) {
      platform = 'windows';
    } else if (isMac) {
      platform = 'mac';
    } else if (isAndroid) {
      platform = 'android';
    } else if (isIOS) {
      platform = 'android';
    } else if (isLinux) {
      platform = 'linux';
    }
    return platform;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    String platform = _platformText;
    if (_platformText != null) {
      map['platform'] = platform;
    }
    return map;
  }
}

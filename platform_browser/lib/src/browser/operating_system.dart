import 'package:tekartik_platform/context.dart';

import '../browser_detect_common.dart';

class OperatingSystem implements BrowserOperatingSystem {
  final BrowserDetectCommon _detect;
  OperatingSystem(this._detect) {}

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
}

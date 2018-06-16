import 'dart:io';

import 'package:tekartik_platform/context.dart';

class _Io implements Io {
  ///
  /// true if windows operating system
  ///
  @override
  bool get isWindows => Platform.isWindows;

  ///
  /// true if OS X operating system
  ///
  @override
  bool get isMac => Platform.isMacOS;

  ///
  /// true if Linux operating system
  ///
  @override
  bool get isLinux => Platform.isLinux;

  ///
  /// true if Android operating system
  ///
  @override
  bool get isAndroid => Platform.isAndroid;

  ///
  /// get the version as string
  ///
  String get versionText => Platform.version;

  String get _platformText {
    String platform;
    if (isLinux) {
      platform = 'linux';
    } else if (isMac) {
      platform = 'mac';
    } else if (isWindows) {
      platform = 'windows';
    } else if (isAndroid) {
      platform = 'android';
    }
    return platform;
  }

  @override
  String toString() => toMap().toString();

  Map toMap() {
    Map map = {};
    map['platform'] = _platformText;
    return map;
  }
}

class PlatformContextIo implements PlatformContext {
  @override
  Browser get browser => null;
  @override
  Node get node => null;

  // non null if in io
  _Io io = new _Io();

  @override
  String toString() => '[io] $io';

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'io': io.toMap()};
    return map;
  }
}

PlatformContextIo _platformContextIo;

PlatformContextIo get ioPlatformContext =>
    _platformContextIo ??= new PlatformContextIo();

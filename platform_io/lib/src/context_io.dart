import 'dart:io';

import 'package:path/path.dart';
import 'package:tekartik_platform/context.dart';
import 'package:tekartik_platform_io/context_io.dart';

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
  bool get isMacOS => Platform.isMacOS;
  @override
  bool get isMac => isMacOS;

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

  @override
  bool get isIOS => Platform.isIOS;
}

class PlatformContextIoImpl implements PlatformContextIo {
  @override
  Browser get browser => null;
  @override
  Node get node => null;

  // non null if in io
  @override
  final _Io io = _Io();

  @override
  String toString() => '[io] $io';

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'io': io.toMap()};
    return map;
  }

  String _userAppDataPath;
  @override
  String get userAppDataPath =>
      _userAppDataPath ??
      () {
        if (Platform.isWindows) {
          return Platform.environment['APPDATA'];
        }
        return null;
      }() ??
      join(userHomePath, '.config');

  String _userHomePath;
  @override
  String get userHomePath => _userHomePath ??= Platform.environment['HOME'] ??
      Platform.environment['USERPROFILE'] ??
      () {}();
}

PlatformContextIoImpl _platformContextIo;

PlatformContextIo get ioPlatformContext =>
    _platformContextIo ??= PlatformContextIoImpl();

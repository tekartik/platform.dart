import 'dart:io' as io;

import 'package:process_run/shell.dart' as shell;
import 'package:tekartik_platform/context.dart';
// ignore: implementation_imports
import 'package:tekartik_platform/src/platform_mixin.dart';
import 'package:tekartik_platform_io/context_io.dart';

class _Io with PlatformMixin implements Io {
  ///
  /// true if windows operating system
  ///
  @override
  bool get isWindows => io.Platform.isWindows;

  ///
  /// true if OS X operating system
  ///
  @override
  bool get isMacOS => io.Platform.isMacOS;

  @override
  bool get isMac => isMacOS;

  ///
  /// true if Linux operating system
  ///
  @override
  bool get isLinux => io.Platform.isLinux;

  ///
  /// true if Android operating system
  ///
  @override
  bool get isAndroid => io.Platform.isAndroid;

  ///
  /// get the version as string
  ///
  String get versionText => io.Platform.version;

  String get _platformText {
    late String platform;
    if (isLinux) {
      platform = 'linux';
    } else if (isMac) {
      platform = 'mac';
    } else if (isWindows) {
      platform = 'windows';
    } else if (isAndroid) {
      platform = 'android';
    } else if (isIOS) {
      platform = 'ios';
    } else {
      platform = 'unknown';
    }
    return platform;
  }

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['platform'] = _platformText;
    map = getPlatformInfoMap(map);
    return map;
  }

  @override
  bool get isIOS => io.Platform.isIOS;

  @override
  Map<String, String> get environment => io.Platform.environment;
}

/// Platform context for io
class PlatformContextIoImpl implements PlatformContextIo {
  @override
  Browser? get browser => null;

  @override
  Node? get node => null;

  // non null if in io
  @override
  Io get io => _io;

  final _io = _Io();
  @override
  String toString() => '[io] $io';

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'io': _io.toMap()};
    return map;
  }

  @override
  String get userAppDataPath => shell.userAppDataPath;

  @override
  String get userHomePath => shell.userHomePath;

  @override
  Platform get platform => io;
}

PlatformContextIoImpl? _platformContextIo;

/// IO platform content, never null
PlatformContextIo get platformContextIoSingleton =>
    _platformContextIo ??= PlatformContextIoImpl();

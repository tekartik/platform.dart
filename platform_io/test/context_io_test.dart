@TestOn('vm')
library;

import 'dart:io';

import 'package:path/path.dart';
import 'package:tekartik_platform_io/context_io.dart';

import 'package:test/test.dart';

void main() {
  group('io', () {
    test('info', () {
      expect(platformContextIo.io, isNotNull);
      expect(platformContextIo.browser, isNull);
      if (Platform.isWindows) {
        expect(platformContextIo.io!.isWindows, isTrue);
      } else if (Platform.isLinux) {
        expect(platformContextIo.io!.isLinux, isTrue);
      } else if (Platform.isMacOS) {
        expect(platformContextIo.io!.isMac, isTrue);
      } else if (Platform.isIOS) {
        expect(platformContextIo.io!.isIOS, isTrue);
      } else if (Platform.isAndroid) {
        expect(platformContextIo.io!.isAndroid, isTrue);
      }
    });
    test('env', () {
      expect(platformIo.environment, isNotEmpty);
    });
    test('path', () {
      print('userHomePath: ${platformContextIo.userHomePath}');
      print('userAppDataPath: ${platformContextIo.userAppDataPath}');
      if (Platform.isWindows) {
        expect(
            platformContextIo.userAppDataPath, Platform.environment['APPDATA']);
        // HOME is not set on github actions on Windows
        expect(
            platformContextIo.userHomePath,
            Platform.environment['HOME'] ??
                Platform.environment['USERPROFILE']);
      } else {
        expect(platformContextIo.userAppDataPath,
            join(Platform.environment['HOME']!, '.config'));
        expect(platformContextIo.userHomePath, Platform.environment['HOME']);
      }
      //print(Platform.environment);
    });
  });
}

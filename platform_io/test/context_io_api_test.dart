@TestOn('vm || browser || node')
library;

// ignore: depend_on_referenced_packages
import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_platform_io/context_io.dart';
import 'package:test/test.dart';

Future main() async {
  group('http_io_api', () {
    test('httpServerFactoryIo', () async {
      try {
        platformContextIo;
        expect(isRunningAsJavascript, isFalse);
      } on UnimplementedError catch (_) {}
    });
  });
}

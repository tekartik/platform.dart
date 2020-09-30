@TestOn('vm || browser || node')
library tekartik_platform_io.test.platform_io_api_test;

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

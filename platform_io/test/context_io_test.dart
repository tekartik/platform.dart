@TestOn('vm')
library tekartik_platform_io.context_io_test;

import 'package:tekartik_platform_io/context_io.dart';
import 'package:test/test.dart';

main() {
  group('io', () {
    test('info', () {
      expect(platformContextIo.io, isNotNull);
    });
  });
}

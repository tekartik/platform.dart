@TestOn('vm')
library;

import 'package:tekartik_platform_browser/context_browser.dart';
import 'package:test/test.dart';

void main() {
  group('io', () {
    test('platformContextBrowser', () {
      expect(() => platformContextBrowser, throwsA(isA<UnsupportedError>()));
    });
  });
}

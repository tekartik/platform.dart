@TestOn('browser')
library;

import 'package:tekartik_platform_browser/context_browser.dart';
import 'package:test/test.dart';

void main() {
  group('web node', () {
    test('version', () {
      expect(platformContextBrowser.browser!.version, isNotNull);
    });
  });
}

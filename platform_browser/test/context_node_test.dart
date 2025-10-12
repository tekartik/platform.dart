@TestOn('node')
library;

import 'package:tekartik_platform_browser/context_browser.dart';

import 'package:test/test.dart';

void main() {
  group('node', () {
    test('platformContextBrowser', () {
      expect(() => platformContextBrowser, throwsA(isA<Object>()));
      //print(platformContextBrowser.browser);
    });
  });
}

@TestOn('browser')
library string_enum_test;

//import 'package:tekartik_utils/dev_utils.dart';
import 'package:tekartik_platform_browser/src/browser_detect.dart';
import 'package:test/test.dart';

void main() {
  group('browser_detect', () {
    void checkSingleBrowser() {
      if (isChrome) {
        expect(isIe || isFirefox || isSafari, isFalse);
      }
      if (isSafari) {
        expect(isIe || isFirefox || isChrome, isFalse);
      }
      if (isIe) {
        expect(isSafari || isFirefox || isChrome, isFalse);
      }
      if (isFirefox) {
        expect(isIe || isSafari || isChrome, isFalse);
      }
    }

    test('single_browser', () {
      checkSingleBrowser();
    });
    test('one_browser', () {
      // But there should be at least one browser
      // TODO support opera...
      expect(isIe || isSafari || isChrome || isFirefox, isTrue);
    });

    test('chrome', () {
      expect(isChrome, isTrue);
    }, testOn: 'chrome');

    /*
    test('dartium', () {
      expect(isChromeDartium, isTrue);
    }, testOn: 'dartium || content-shell');
    */

    test('firefox', () {
      expect(isFirefox, isTrue);
    }, testOn: 'firefox');

    test('ie', () {
      expect(isIe, isTrue);
    }, testOn: 'ie');

    test('safari', () {
      expect(isSafari, isTrue);
    }, testOn: 'safari');
  });
}

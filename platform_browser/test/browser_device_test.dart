library browser_detect_utils_common_test;

import 'user_agents.dart';

//import 'package:tekartik_utils/dev_utils.dart';
import 'package:dev_test/test.dart';
import 'package:tekartik_platform_browser/src/browser/device.dart';
import 'package:tekartik_platform_browser/src/browser_detect_common.dart';

void main() => defineTests();

void defineTests() {
  group('browser_device', () {
    _checkSingle(Device device) {
      if (device.isIPad) {
        expect(device.isIPod || device.isIPhone, isFalse);
      }
      if (device.isIPod) {
        expect(device.isIPad || device.isIPhone, isFalse);
      }
      if (device.isIPhone) {
        expect(device.isIPad || device.isIPod, isFalse);
      }
    }

    Device _fromUserAgent(String userAgent) {
      Device device =
          new Device(new BrowserDetectCommon()..userAgent = userAgent);
      _checkSingle(device);
      return device;
    }

    tearDown(() {
      // Cleanup any change
    });

    test('safari', () {
      // OS X 10.10.5
      var device = _fromUserAgent(
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.1.56 (KHTML, like Gecko) Version/9.0 Safari/601.1.56');
      expect(device.isMobile, isFalse);
    });

    test('iPad', () {
      // iPad2
      var device = _fromUserAgent(iPad2_Safari_OS9);
      expect(device.isIPad, isTrue);
    });

    test('iPhone', () {
      // iPad2
      var device = _fromUserAgent(
          "Mozilla/5.0 (iPhone; CPU iPhone OS 9_0 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13A344 Safari/601.1");
      expect(device.isIPhone, isTrue);
    });

    /*
    test('ie', () {
      browserDetect.userAgent =
          'Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; Touch; .NET4.0E; .NET4.0C; .NET CLR 3.5.30729; .NET CLR 2.0.50727; .NET CLR 3.0.30729; Tablet PC 2.0; MALNJS; rv:11.0) like Gecko';
      expect(browserDetect.isIe, isTrue);
      expect(browserDetect.browserVersion, new Version(7, 0, 0));
      expect(browserDetect.isMobile, isFalse);
      _checkSingleBrowser();
    });

    test('ie_edge', () {
      browserDetect.userAgent =
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36 Edge/12.0';
      expect(browserDetect.isIe, isTrue);
      expect(browserDetect.browserVersion, new Version(12, 0, 0));
      expect(browserDetect.isMobile, isFalse);
      _checkSingleBrowser();
    });

    test('firefox', () {
      browserDetect.userAgent =
          'Mozilla/5.0 (Windows NT 6.3; WOW64; rv:29.0) Gecko/20100101 Firefox/29.0';
      expect(browserDetect.isFirefox, isTrue);
      expect(browserDetect.browserVersion, new Version(29, 0, 0));
      expect(browserDetect.isMobile, isFalse);
      _checkSingleBrowser();
    });

    BrowserDetectCommon _fromUserAgent(String userAgent) {
      BrowserDetectCommon detect = new BrowserDetectCommon()
        ..userAgent = userAgent;
      return detect;
    }

    test('windows', () {
      // Windows 10 on Chrome (yoga 2 13)
      var detect = _fromUserAgent(
          "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.0 (Dart) Safari/537.36");
      expect(detect.isWindows, isTrue);
      _checkSingle(detect);

      // Windows 10 on firefox
      detect = _fromUserAgent(
          "Mozilla/5.0 (Windows NT 6.3; WOW64; rv:29.0) Gecko/20100101 Firefox/29.0");
      expect(detect.isWindows, isTrue);
      _checkSingle(detect);
    });

    test('mac', () {
      var detect = _fromUserAgent(
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36");
      expect(detect.isMac, isTrue);
      _checkSingle(detect);
    });

    test('linux', () {
      var detect = _fromUserAgent(
          "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36");
      expect(detect.isLinux, isTrue);
      _checkSingle(detect);
      ;
    });

    test('chrome', () {
      // Chrome 46
      browserDetect.userAgent =
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36";
      expect(browserDetect.isChrome, isTrue);
      expect(browserDetect.isChromeChromium, isFalse);
      expect(browserDetect.isChromeDartium, isFalse);
      expect(browserDetect.isMobile, isFalse);
      expect(
          browserDetect.browserVersion, new Version(46, 0, 2490, build: '86'));

      _checkSingleBrowser();

      browserDetect.userAgent =
          'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36';
      expect(browserDetect.isChrome, isTrue);
      expect(browserDetect.isChromeChromium, isFalse);
      expect(browserDetect.isChromeDartium, isFalse);
      expect(browserDetect.isMobile, isFalse);
      expect(
          browserDetect.browserVersion, new Version(36, 0, 1985, build: '125'));

      _checkSingleBrowser();
    });

    test('chromium', () {
      browserDetect.userAgent =
          "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36";
      expect(browserDetect.isChromeChromium, isTrue);
      expect(browserDetect.isChromeDartium, isFalse);
      expect(browserDetect.isChrome, isTrue);
      expect(browserDetect.isMobile, isFalse);
      expect(
          browserDetect.browserVersion, new Version(45, 0, 2454, build: '101'));
      _checkSingleBrowser();
    });
    test('chrome_dartium', () {
      browserDetect.userAgent =
          'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.0 (Dart) Safari/537.36';
      expect(browserDetect.isChromeDartium, isTrue);
      expect(browserDetect.isChromeChromium, isFalse);
      expect(browserDetect.isChrome, isTrue);
      expect(browserDetect.isMobile, isFalse);
      expect(
          browserDetect.browserVersion, new Version(37, 0, 2062, build: '0'));
      _checkSingleBrowser();
    });

    solo_test('iPad', () {
      // iPad2
      browserDetect.userAgent ="Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3";
      expect(browserDetect.isSafari, isTrue);
      expect(browserDetect.isMobile, isTrue);
      expect(browserDetect.browserVersion, new Version(5, 1, 0));
      //expect(browserDetect.isIos, isTrue);
      expect(browserDetect.isMobileIOS, isTrue);
      expect(browserDetect.isMobileIPad, isTrue);
      expect(browserDetect.isMobileIPhone, isFalse);
      expect(browserDetect.isMobileIPod, isFalse);
      expect(browserDetect.isMobileAndroid, isFalse);
    });

    test('mobile', () {
      // iOS9 Safari
      browserDetect.userAgent =
          "Mozilla/5.0 (iPhone; CPU iPhone OS 9_0 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13A344 Safari/601.1";
      expect(browserDetect.isMobile, isTrue);
      expect(browserDetect.isSafari, isTrue);
      expect(browserDetect.browserVersion, new Version(9, 0, 0));
      expect(browserDetect.isMobileAndroid, isFalse);
      expect(browserDetect.isSafari, isTrue);
      _checkSingleBrowser();

      // Chrome iOS
      browserDetect.userAgent =
          "Mozilla/5.0 (iPhone; CPU iPhone OS 8_2 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12D508 Safari/600.1.4";
      expect(browserDetect.isMobileIOS, isTrue);
      expect(browserDetect.isMobileAndroid, isFalse);
      expect(browserDetect.isSafari, isTrue);
      _checkSingleBrowser();

      // Chrome Android 6
      browserDetect.userAgent =
          'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36';
      expect(browserDetect.isMobile, isTrue);
      expect(browserDetect.isChrome, isTrue);
      expect(browserDetect.isMobileIOS, isFalse);
      expect(browserDetect.isMobileAndroid, isTrue);
      expect(
          browserDetect.browserVersion, new Version(46, 0, 2490, build: "76"));
      _checkSingleBrowser();
    });
  */
  });
}

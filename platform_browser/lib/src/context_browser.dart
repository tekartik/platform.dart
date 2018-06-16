import 'package:tekartik_platform/context.dart';
import 'package:tekartik_platform_browser/src/browser/operating_system.dart';
import 'browser_detect.dart';
import 'package:pub_semver/pub_semver.dart';

class _Device implements BrowserDevice {
  BrowserDetect _detect = new BrowserDetect();
  _Device([this._detect]) {
    if (_detect == null) {
      _detect = new BrowserDetect();
    }
  }

  @override
  bool get isMobile => _detect.isMobile;

  // TODO: implement isPad
  @override
  bool get isIPad => _detect.isMobileIPad;

  // TODO: implement isPhone
  @override
  bool get isIPhone => _detect.isMobileIPhone;

  // TODO: implement isPod
  @override
  bool get isIPod => _detect.isMobileIPod;
}

class _Browser implements Browser {
  BrowserDetect _detect = new BrowserDetect();

  OperatingSystemBrowser _os;
  BrowserDevice _device;

  String get navigatorText {
    String navigator;
    if (isIe) {
      navigator = 'ie';
    } else if (isFirefox) {
      navigator = 'firefox';
    } else if (isChrome) {
      if (isChromeDartium) {
        navigator = 'dartium';
      } else if (isChromeChromium) {
        navigator = 'chromium';
      } else {
        navigator = 'chrome';
      }
    } else if (isSafari) {
      navigator = 'safari';
    }
    return navigator;
  }

  @override
  Version get version => _detect.browserVersion;

  @override
  String toString() => toMap().toString();

  Map toMap() {
    Map map = {};
    map['navigator'] = navigatorText;
    map['version'] = version.toString();
    map['os'] = os.toMap();
    if (isDartVm) {
      map['dartVm'] = true;
    }
    return map;
  }

  @override
  bool get isIe => _detect.isIe;

  @override
  bool get isFirefox => _detect.isFirefox;

  @override
  bool get isSafari => _detect.isSafari;

  @override
  bool get isChrome => _detect.isChrome;
  @override
  bool get isChromeChromium => _detect.isChromeChromium;
  @override
  bool get isChromeDartium => _detect.isChromeDartium;

  // Ugly way to test if running as dart or javascript
  @override
  bool get isDartVm => !isRunningAsJavascript;

  @override
  bool get isMobile => _detect.isMobile;

  @override
  OperatingSystemBrowser get os {
    if (_os == null) {
      _os = new OperatingSystemBrowser(_detect);
    }
    return _os;
  }

  @override
  BrowserDevice get device {
    if (_device == null) {
      _device = new _Device(_detect);
    }
    return _device;
  }
}

class _BrowserPlatformContext implements PlatformContext {
  @override
  Io get io => null;
  @override
  Node get node => null;

  // non null if in io
  final _Browser browser = new _Browser();

  _BrowserPlatformContext() {
    browser._detect.init();
  }

  @override
  String toString() => toMap().toString();

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'browser': browser.toMap()};
    return map;
  }
}

PlatformContext _browserPlatformContext;
PlatformContext get browserPlatformContext =>
    _browserPlatformContext ??= new _BrowserPlatformContext();

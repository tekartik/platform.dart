/**
 * exported for testing only
 */
library tekartik_platform_context.src.browser_detect_common;

import 'package:pub_semver/pub_semver.dart';

// Current way to detect javascript
bool get isRunningAsJavascript => identical(1.0, 1);

/// Regex that matches a version number at the beginning of a string.
final _START_VERSION = new RegExp(r'^' // Start at beginning.
    r'(\d+).((\d+))?' // Version number.
    );

/// Like [_START_VERSION] but matches the entire string.
final _COMPLETE_VERSION = new RegExp("${_START_VERSION.pattern}\$");

// Handle String with 4 numbers
/// Regex that matches a version number at the beginning of a string.
final _FOUR_NUMBER_START_VERSION = new RegExp(r'^' // Start at beginning.
        r'(\d+).(\d+).(\d+).([0-9A-Za-z-]*)') // Version number.
    ;

/// Like [_START_VERSION] but matches the entire string.
final _FOUR_NUMBER_COMPLETE_VERSION =
    new RegExp("${_FOUR_NUMBER_START_VERSION.pattern}\$");

/**
 * Add support for version X, X.X not supported in platform version
 */
Version parseVersion(String text) {
  try {
    return new Version.parse(text);
  } on FormatException catch (e, _) {
    Match match = _COMPLETE_VERSION.firstMatch(text);
    if (match != null) {
      try {
        //      print(match[0]);
        //      print(match[1]);
        //      print(match[2]);
        int major = int.parse(match[1]);
        int minor = int.parse(match[2]);

        return new Version(major, minor, 0);
      } on FormatException catch (_) {
        throw e;
      }
    } else {
      match = _FOUR_NUMBER_COMPLETE_VERSION.firstMatch(text);
      if (match != null) {
        try {
          //      print(match[0]);
          //      print(match[1]);
          //      print(match[2]);
          int major = int.parse(match[1]);
          int minor = int.parse(match[2]);
          int patch = int.parse(match[3]);
          String build = match[4];

          return new Version(major, minor, patch, build: build);
        } on FormatException catch (_) {
          throw e;
        }
      } else {
        throw new FormatException('Could not parse "$text".');
      }
    }
  }
}

class BrowserDetectCommon {
  // Handle stuff like 'Trident/7.0, Chrome/29.0...'
  bool _checkAndGetVersion(String name) {
    int index = _userAgent.indexOf(name);
    if (index >= 0) {
      String versionString = _userAgent.substring(index + name.length + 1);
      int endVersion = versionString.indexOf(' ');
      if (endVersion >= 0) {
        versionString = versionString.substring(0, endVersion);
      }
      endVersion = versionString.indexOf(';');
      if (endVersion >= 0) {
        versionString = versionString.substring(0, endVersion);
      }
      _browserVersion = parseVersion(versionString);
      return true;
    }
    return false;
  }

  Version _browserVersion;
  bool _isFirefox;
  bool _isSafari;
  bool _isMobile;
  bool _isChrome;
  bool _isIe;

  // OS
  bool _isWindows;
  bool _isMac;
  bool _isLinux;

  bool _isIos;

  Version get browserVersion => _browserVersion;
  bool get isIe {
    if (_isIe == null) {
      init();
      // Edge 12 and over
      _isIe = _checkAndGetVersion('Edge');
      if (_isIe == false) {
        _isIe = _checkAndGetVersion('Trident');
      }
    }
    return _isIe;
  }

  bool get isIos {
    if (_isIos == null) {
      init();
      // Edge 12 and over
      _isIe = _checkAndGetVersion('Edge');
      if (_isIe == false) {
        _isIe = _checkAndGetVersion('Trident');
      }
    }
    return _isIe;
  }

  bool get isChrome {
    if (_isChrome == null) {
      init();
      // Can check vendor too...
      _isChrome = _checkAndGetVersion('Chrome');
    }
    return _isChrome;
  }

  bool get isChromeChromium {
    return isChrome && _checkAndGetVersion('Chromium');
  }

  bool get isChromeDartium {
    return isChrome && _userAgent.contains('(Dart)');
  }

  bool get isFirefox {
    if (_isFirefox == null) {
      init();
      _isFirefox = _checkAndGetVersion('Firefox');
    }
    return _isFirefox;
  }

  bool get isSafari {
    if (_isSafari == null) {
      init();
      _isSafari = !isChrome && _userAgent.contains('Safari');
      if (_isSafari) {
        _checkAndGetVersion('Version');
      }
    }
    return _isSafari;
  }

  // on chrome
  // on ie:  For Windows environments, value Windows NT 6.3 stands for Win 8.1, Windows NT 6.2 for Win 8, Windows NT 6.1 for Win 7 and so on
  bool get isWindows {
    if (_isWindows == null) {
      _isWindows = _userAgent.contains('Windows');
    }
    return _isWindows;
  }

  bool get isMac {
    if (_isMac == null) {
      _isMac = _userAgent.contains('Macintosh');
    }
    return _isMac;
  }

  bool get isLinux {
    if (_isLinux == null) {
      _isLinux = _userAgent.contains('Linux');
    }
    return _isLinux;
  }

  // every browser can be mobile
  bool get isMobile {
    if (_isMobile == null) {
      _isMobile = _userAgent.contains('Mobile/') ||
          _userAgent.contains('Mobile ') ||
          _userAgent.contains(' Mobile');
    }
    return _isMobile;
  }

  bool get isMobileIOS {
    return isMobile && (_canBeIPad || _canBeIPod || _canBeIPhone);
  }

  bool get _canBeIPhone {
    return _userAgent.contains('iPhone');
  }

  bool get isMobileIPhone {
    return isMobile && _canBeIPhone;
  }

  bool get isMobileIPad {
    return isMobile && _canBeIPad;
  }

  bool get _canBeIPad {
    return _userAgent.contains('iPad');
  }

  bool get isMobileIPod {
    return isMobile && _canBeIPod;
  }

  bool get _canBeIPod {
    return _userAgent.contains('iPod');
  }

  bool get isMobileAndroid {
    return isMobile && _userAgent.contains('Android');
  }

  String _userAgent;

  String get userAgent => _userAgent;

  set userAgent(String userAgent_) {
    this._userAgent = userAgent_;

    // Navigator
    _isFirefox = null;
    _isChrome = null;
    _isSafari = null;
    _isIe = null;

    _isMobile = null;
    _browserVersion = null;
    _isIos = null;

    if (_userAgent != null) {
      // ie is tricky as it sets others
      if (isIe) {
        _isFirefox = false;
        _isChrome = false;
        _isSafari = false;
      }
    }
  }

  init() {}
}

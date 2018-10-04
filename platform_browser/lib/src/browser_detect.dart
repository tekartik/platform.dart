library tekartik_platform_context.src.browser_detect;

import 'dart:html';
import 'browser_detect_common.dart';
export 'browser_detect_common.dart';

class BrowserDetect extends BrowserDetectCommon {
  @override
  init() {
    if (userAgent == null) {
      userAgent = window.navigator.userAgent;
    }
  }
}

BrowserDetect _browserDetect;

BrowserDetect get browserDetect {
  if (_browserDetect == null) {
    _browserDetect = BrowserDetect();
  }
  return _browserDetect;
}

bool get isIe => browserDetect.isIe;
bool get isEdge => browserDetect.isEdge;
bool get isChrome => browserDetect.isChrome;
bool get isFirefox => browserDetect.isFirefox;
bool get isSafari => browserDetect.isSafari;
bool get isChromeDartium => browserDetect.isChromeDartium;

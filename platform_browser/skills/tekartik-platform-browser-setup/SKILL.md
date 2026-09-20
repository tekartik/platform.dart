---
name: tekartik-platform-browser-setup
description: >-
  Use when a Dart web app (dart2js or wasm, package:web) needs to know which
  browser, OS or device it runs in with tekartik_platform_browser:
  platformContextBrowser from context_browser.dart, its browser view
  (isChrome, isChromeEdge, isChromeChromium, isChromeDartium, isFirefox,
  isSafari, isIe, version, isMobile, isDartVm, os.isWindows / isMac / isLinux
  / isAndroid / isIOS, device.isIPad / isIPhone / isIPod / supportsTouch),
  the UnsupportedError thrown off the web, user-agent parsing tests on the VM
  with BrowserDetectCommon, OperatingSystemBrowser and Device, and running the
  shared tekartik_platform_test example in a browser.
---

# tekartik_platform_browser: the browser implementation

`tekartik_platform_browser` implements the `tekartik_platform` context for
code compiled to JavaScript or Wasm: it parses `window.navigator.userAgent`
(through `package:web`) once and exposes the result as a `PlatformContext`
whose `browser` view is filled and whose `io`, `node` and `platform` views are
null. Importing it is safe everywhere; accessing the context is web only.

## Guidelines

* Dependency (git, not on pub.dev):
  ```yaml
  dependencies:
    tekartik_platform_browser:
      git:
        url: https://github.com/tekartik/platform.dart
        path: platform_browser
  ```
  It brings `tekartik_platform` (same repo, `path: platform`) and `web`.
  Declare `tekartik_platform` explicitly in packages that import
  `package:tekartik_platform/context.dart` themselves.
* Import `package:tekartik_platform_browser/context_browser.dart`: it
  re-exports `package:tekartik_platform/context.dart` (`PlatformContext`,
  `Browser`, `OperatingSystem`, `BrowserDevice`, ...) and adds the
  `platformContextBrowser` getter, a lazily built singleton `PlatformContext`.
* `platformContextBrowser.browser!` is the useful part (`io`, `node` and
  `platform` are null). Browser flags come from the user agent: `isChrome`
  (`Chrome/`, so also true for Chromium based Edge and for Chromium),
  `isChromeEdge` (`Edg/`), `isChromeChromium` (`Chromium/`),
  `isChromeDartium` (`(Dart)`), `isFirefox` (`Firefox/`), `isSafari`
  (`Safari` without `Chrome`), `isIe` (`Trident/`). Test the specific flag
  first (`isChromeEdge` before `isChrome`). Legacy EdgeHTML (`Edge/`) matches
  none of them.
* `version` is a `pub_semver` `Version` parsed from the token that follows
  the matched name: `Chrome/120.0.0.0` gives `120.0.0+0` (fourth number as
  build), `Firefox/121.0` gives `121.0.0`, Safari reads `Version/9.0`, IE
  reads the Trident version (`7.0.0` for IE 11). `Version.none` (`0.0.0`)
  when nothing matched.
* `os` (`OperatingSystem`): `isWindows` (`Windows`), `isMac` (`Macintosh`,
  which iPadOS desktop-mode Safari also reports), `isLinux` (`Linux`, true on
  Android too), `isAndroid` (mobile and `Android`), `isIOS` (mobile and
  iPad/iPhone/iPod). `isMobile` means a `Mobile` token in the user agent.
  `device` (`BrowserDevice`): `isIPad`, `isIPhone`, `isIPod`, `isMobile`,
  and `supportsTouch` (`navigator.maxTouchPoints > 0`, the only flag not
  derived from the user agent).
* `isDartVm` is `!kDartIsWeb`: always false for a compiled web app; kept for
  the `Browser` contract.
* `toMap()` returns `{'browser': {'navigator': 'chrome' | 'edge' |
  'chromium' | 'dartium' | 'firefox' | 'safari' | 'ie' | null, 'version':
  '120.0.0+0', 'os': {'platform': 'windows' | 'mac' | 'android' | 'ios' |
  'linux' | 'unknown'}}}`. Log it, do not parse it.
* Off the web: the library is a conditional export on
  `dart.library.js_interop`. On the Dart VM and Flutter native
  `platformContextBrowser` throws `UnsupportedError('platformContextBrowser
  Web only')`; under node (dart2js) the web branch is selected and the access
  fails because there is no `window`. In multiplatform code guard with
  `kDartIsWeb` from `package:tekartik_common_utils/env_utils.dart` (declare
  `tekartik_common_utils`, git `https://github.com/tekartik/common_utils.dart`)
  or catch the error, and keep the io context in `tekartik_platform_io`.
* Tests: browser behaviour needs a browser, `@TestOn('browser')` and
  `dart test -p chrome` (the package's `dart_test.yaml` runs vm, chrome and
  node). User-agent rules are testable on the VM with the internal
  `src/browser_detect_common.dart` (`BrowserDetectCommon` with a settable
  `userAgent`, `browserVersion`, `isMobileAndroid`, `isMobileIOS`, plus
  `parseVersion`), `src/browser/operating_system.dart`
  (`OperatingSystemBrowser(detect)`) and `src/browser/device.dart`
  (`Device(detect)`, whose `supportsTouch` is always false). These are
  `src` imports meant for tests: add `// ignore: implementation_imports`
  outside the package.
* The shared demo `run(context)` in
  `package:tekartik_platform_test/platform_context_example.dart` (same repo,
  `path: platform_test`) prints what a context reports; set its `print` hook
  to a DOM writer first, see `example/platform_context_browser_example.dart`.

## Examples

### Web entry point

```dart
import 'package:tekartik_platform_browser/context_browser.dart';

void main() {
  var browser = platformContextBrowser.browser!;
  String name;
  if (browser.isChromeEdge) {
    name = 'edge';
  } else if (browser.isChromeChromium) {
    name = 'chromium';
  } else if (browser.isChrome) {
    name = 'chrome';
  } else if (browser.isFirefox) {
    name = 'firefox';
  } else if (browser.isSafari) {
    name = 'safari';
  } else if (browser.isIe) {
    name = 'ie';
  } else {
    name = 'unknown';
  }
  print('$name ${browser.version}');

  var os = browser.os;
  if (os.isAndroid) {
    print('android');
  } else if (os.isIOS) {
    print('ios (${browser.device.isIPad ? 'ipad' : 'iphone/ipod'})');
  } else if (os.isWindows) {
    print('windows');
  } else if (os.isMac) {
    print('mac');
  } else if (os.isLinux) {
    print('linux');
  }
  if (browser.isMobile) {
    print('mobile browser');
  }
  if (browser.device.supportsTouch) {
    print('touch screen');
  }
}
```

### Show the context in the page

```dart
import 'dart:convert';

import 'package:tekartik_platform_browser/context_browser.dart';
import 'package:web/web.dart';

void main() {
  var pre = document.createElement('pre');
  pre.textContent = const JsonEncoder.withIndent('  ').convert({
    'context': platformContextBrowser.toMap(),
    'userAgent': window.navigator.userAgent,
  });
  document.body!.appendChild(pre);
}
```

### Multiplatform code: null when not on the web

```dart
import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_platform_browser/context_browser.dart';

/// Null on the Dart VM and Flutter native (and on node, where window is missing).
PlatformContext? get browserContextOrNull {
  if (!kDartIsWeb) {
    return null;
  }
  try {
    return platformContextBrowser;
  } catch (_) {
    return null;
  }
}

bool get isMobileBrowser => browserContextOrNull?.browser?.isMobile ?? false;
```

### Browser test

```dart
@TestOn('browser')
library;

import 'package:tekartik_platform_browser/context_browser.dart';
import 'package:test/test.dart';

void main() {
  test('chrome', () {
    var browser = platformContextBrowser.browser!;
    expect(browser.isChrome, isTrue);
    expect(browser.isDartVm, isFalse);
    expect(browser.version.major, greaterThan(0));
  }, testOn: 'chrome');

  test('views', () {
    expect(platformContextBrowser.io, isNull);
    expect(platformContextBrowser.platform, isNull);
    expect(platformContextBrowser.toMap()['browser'], isA<Map>());
  });
}
```

### User-agent parsing test on the VM

```dart
import 'package:pub_semver/pub_semver.dart';
// ignore: implementation_imports
import 'package:tekartik_platform_browser/src/browser/device.dart';
// ignore: implementation_imports
import 'package:tekartik_platform_browser/src/browser/operating_system.dart';
// ignore: implementation_imports
import 'package:tekartik_platform_browser/src/browser_detect_common.dart';
import 'package:test/test.dart';

const chromeEdgeLinux =
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0';
const iPadSafari =
    'Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3';

void main() {
  test('chromium edge on linux', () {
    var detect = BrowserDetectCommon()..userAgent = chromeEdgeLinux;
    expect(detect.isChrome, isTrue);
    expect(detect.isChromeEdge, isTrue);
    expect(detect.isSafari, isFalse);
    expect(detect.browserVersion, Version(120, 0, 0, build: '0'));
    var os = OperatingSystemBrowser(detect);
    expect(os.isLinux, isTrue);
    expect(os.isAndroid, isFalse);
  });

  test('ipad safari', () {
    var detect = BrowserDetectCommon()..userAgent = iPadSafari;
    expect(detect.isSafari, isTrue);
    expect(detect.browserVersion, Version(5, 1, 0));
    var device = Device(detect);
    expect(device.isMobile, isTrue);
    expect(device.isIPad, isTrue);
    expect(OperatingSystemBrowser(detect).isIOS, isTrue);
  });
}
```

## Common mistakes

* Reading `platformContextBrowser` in code that also runs on the VM without a
  guard: it throws there.
* Treating `isChrome` as "Google Chrome": exclude `isChromeEdge` and
  `isChromeChromium` first.
* Treating `os.isLinux` as desktop Linux: check `os.isAndroid` first.
* Expecting `isDartVm` to be true anywhere in a modern web build.

# tekartik_platform_browser

The browser implementation of [tekartik_platform](../platform/README.md):
`platformContextBrowser` tells web code which browser, OS and device it runs
on, parsed from `navigator.userAgent` (`package:web`, dart2js and dart2wasm).

## Getting started

Not on pub.dev, add it as a git dependency:

```yaml
dependencies:
  tekartik_platform_browser:
    git:
      url: https://github.com/tekartik/platform.dart
      path: platform_browser
```

In the web entry point:

```dart
import 'package:tekartik_platform_browser/context_browser.dart';

void main() {
  var browser = platformContextBrowser.browser!;
  // Test the specific flags first: Edge and Chromium are Chrome too.
  var name = browser.isChromeEdge
      ? 'edge'
      : browser.isChrome
      ? 'chrome'
      : browser.isFirefox
      ? 'firefox'
      : browser.isSafari
      ? 'safari'
      : 'other';
  var os = browser.os;
  var system = os.isAndroid
      ? 'android'
      : os.isIOS
      ? 'ios'
      : os.isWindows
      ? 'windows'
      : os.isMac
      ? 'mac'
      : os.isLinux
      ? 'linux'
      : 'other';
  print('$name ${browser.version} on $system'); // chrome 120.0.0+0 on linux
  print(platformContextBrowser.toMap()); // for logs
}
```

`context_browser.dart` re-exports `PlatformContext` and the other interfaces
of `tekartik_platform`, so shared code can take a `PlatformContext` and the io
entry point passes `platformContextIo` (`tekartik_platform_io`) instead.

## Platforms

* Web (browser, Flutter web; dart2js and dart2wasm): the context, with
  `browser` set and `io`, `platform`, `node` null.
* Dart VM and Flutter native: importing is safe, reading
  `platformContextBrowser` throws an `UnsupportedError`. Guard multiplatform
  code with `kDartIsWeb` (`package:tekartik_common_utils/env_utils.dart`).
* node (dart2js): the web branch is compiled but there is no `window`, the
  access fails.

## What is detected

* Browser: `isChrome` (also Chromium based Edge and Chromium), `isChromeEdge`,
  `isChromeChromium`, `isFirefox`, `isSafari`, `isIe`, `version` (a
  `pub_semver` `Version`, `Version.none` when unknown), `isMobile` (a `Mobile`
  token in the user agent).
* `os`: `isWindows`, `isMac`, `isLinux` (true on Android too), `isAndroid`
  (phones and tablets), `isIOS` (iPhone, iPod, iPad before iPadOS 13).
* `device`: `isIPad`, `isIPhone`, `isIPod`, `isMobile`, `supportsTouch`
  (`navigator.maxTouchPoints`, the only value not read from the user agent).

## Common pitfalls

* `isChrome` is true for Edge and Chromium: test `isChromeEdge` and
  `isChromeChromium` first.
* `os.isLinux` is true on Android: test `os.isAndroid` first.
* iPadOS 13+ Safari sends a desktop Mac user agent: `os.isMac`, not
  `os.isIOS`; `device.supportsTouch` tells it apart.
* The user agent can be changed by the user (desktop mode of a mobile
  browser): use it for statistics and small adaptations, not for security.

Example: [example/platform_context_browser_example.dart](example/platform_context_browser_example.dart)
(`webdev serve example`, or `dart run tool/run_web_release.dart`), sample
outputs in
[doc/browser_info.md](doc/browser_info.md). Agent skill:
[skills/tekartik-platform-browser-setup](skills/tekartik-platform-browser-setup/SKILL.md).

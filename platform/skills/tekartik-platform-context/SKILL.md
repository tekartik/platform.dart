---
name: tekartik-platform-context
description: >-
  Use when writing platform-agnostic Dart code that asks "where am I running"
  through tekartik_platform: the abstract PlatformContext (browser, platform,
  io, node, toMap), Platform (isWindows, isMacOS, isLinux, environment), Io
  (isAndroid, isIOS), Node, Browser (isChrome, isChromeEdge, isChromeChromium,
  isFirefox, isSafari, isIe, version, isMobile, isDartVm, os, device),
  OperatingSystem and BrowserDevice from package:tekartik_platform/context.dart,
  the CI extensions runningOnGithub, runningOnGitlab and runningOnCloudCi from
  util/ci_util.dart, faking a PlatformContext in tests, and passing
  platformContextIo or platformContextBrowser from main into shared code.
---

# Platform context abstractions (tekartik_platform)

`tekartik_platform` only declares the abstract "where am I running" model.
Concrete contexts come from `tekartik_platform_io` (`platformContextIo`,
`dart:io`) and `tekartik_platform_browser` (`platformContextBrowser`,
`package:web`); shared code depends on this package alone and receives a
`PlatformContext` from the entry point.

## Guidelines

* Dependency (git, not on pub.dev):
  ```yaml
  dependencies:
    tekartik_platform:
      git:
        url: https://github.com/tekartik/platform.dart
        path: platform
  ```
  Entry points add `tekartik_platform_io` (`path: platform_io`) or
  `tekartik_platform_browser` (`path: platform_browser`) from the same repo.
* Import `package:tekartik_platform/context.dart`. Everything in it is
  abstract: no constructor, no default instance. `main` (or a test) obtains a
  context from an implementation package and passes it down.
* `PlatformContext` has four nullable views; an implementation fills the ones
  that apply:
  - `browser` (`Browser?`): non null in a browser.
  - `platform` (`Platform?`): non null on io and node, the common process view.
  - `io` (`Io?`): non null on the Dart VM and Flutter native.
  - `node` (`Node?`): non null on node (no implementation in this repo today,
    both shipped contexts return null).
  `toMap()` is a debug dump: `{'io': {'platform': 'linux'}}` or
  `{'browser': {'navigator': 'chrome', 'version': '120.0.0+0', 'os': {...}}}`.
* `Platform` (io and node): `isWindows`, `isMacOS`, `isLinux` and
  `environment` (`Map<String, String>`). `Io extends Platform` adds
  `isAndroid`, `isIOS` and the older `isMac` alias; `Node extends Platform`
  adds `isMac`. Test `context.platform` rather than `context.io` when the
  answer is the same on node.
* `Browser`: `isChrome` (also true for Chromium based Edge and Chromium, so
  check `isChromeEdge` / `isChromeChromium` first), `isChromeDartium`,
  `isFirefox`, `isSafari`, `isIe`; `version` is a `pub_semver` `Version`
  (`Version.none` when unknown, never a string); `isMobile`; `isDartVm`
  (false in any compiled web app); `os` (`OperatingSystem`: `isWindows`,
  `isMac`, `isLinux`, `isAndroid`, `isIOS`, where Android is also Linux) and
  `device` (`BrowserDevice`: `isMobile`, `isIPad`, `isIPhone`, `isIPod`,
  `supportsTouch`).
* CI detection: `package:tekartik_platform/util/ci_util.dart` (re-exports
  `util/github_util.dart` and `util/gitlab_util.dart`) adds extensions on
  `Platform`: `runningOnGithub` (`GITHUB_ACTIONS == 'true'`),
  `runningOnGitlab` (`CI_PROJECT_NAME`, `GITLAB_USER_ID` and
  `CI_RUNNER_VERSION` all set) and `runningOnCloudCi` (either). They only
  read `environment`, so they work on any `Platform`, including a fake.
* Tests of shared logic: implement `PlatformContext` (and `Platform`) in a
  small fake with the five members (`browser`, `platform`, `io`, `node`,
  `toMap`), as the package's own test does. Do not pull an implementation
  package into a unit test that only needs a value.
* Anti-patterns: importing `dart:io` `Platform` in shared code (the thing this
  package avoids; if both are imported, prefix `dart:io` with `as io`);
  assuming `context.io` is non null whenever `context.platform` is; comparing
  `browser.version` with a string.

## Examples

### Shared code that branches on the context

```dart
import 'package:tekartik_platform/context.dart';

/// Works with platformContextIo, platformContextBrowser or a fake.
String describe(PlatformContext context) {
  var platform = context.platform;
  if (platform != null) {
    var io = context.io;
    if (io != null && io.isAndroid) {
      return 'android';
    } else if (io != null && io.isIOS) {
      return 'ios';
    } else if (platform.isWindows) {
      return 'windows';
    } else if (platform.isMacOS) {
      return 'macos';
    } else if (platform.isLinux) {
      return 'linux';
    }
    return 'unknown process platform';
  }
  var browser = context.browser;
  if (browser != null) {
    var name = browser.isChromeEdge
        ? 'edge'
        : browser.isChromeChromium
        ? 'chromium'
        : browser.isChrome
        ? 'chrome'
        : browser.isFirefox
        ? 'firefox'
        : browser.isSafari
        ? 'safari'
        : browser.isIe
        ? 'ie'
        : 'browser';
    var os = browser.os;
    var osName = os.isAndroid
        ? 'android'
        : os.isIOS
        ? 'ios'
        : os.isWindows
        ? 'windows'
        : os.isMac
        ? 'mac'
        : os.isLinux
        ? 'linux'
        : 'unknown';
    var touch = browser.device.supportsTouch ? ', touch' : '';
    return '$name ${browser.version} on $osName$touch';
  }
  return 'unknown';
}
```

### Pick the implementation in main, keep the rest shared

```dart
import 'package:tekartik_platform/context.dart';
import 'package:tekartik_platform_io/context_io.dart';

void main() {
  // The web entry point calls run(platformContextBrowser) instead.
  run(platformContextIo);
}

void run(PlatformContext context) {
  print(context.toMap());
  var platform = context.platform;
  if (platform != null) {
    print('PATH: ${platform.environment['PATH']}');
  }
}
```

### Fake context and CI extensions in a unit test

```dart
import 'package:tekartik_platform/context.dart';
import 'package:tekartik_platform/util/ci_util.dart';
import 'package:test/test.dart';

class FakePlatform implements Platform {
  @override
  final Map<String, String> environment;
  @override
  final bool isLinux;
  FakePlatform({this.environment = const {}, this.isLinux = true});
  @override
  bool get isMacOS => false;
  @override
  bool get isWindows => false;
}

class FakeContext implements PlatformContext {
  @override
  final Platform? platform;
  FakeContext({this.platform});
  @override
  Browser? get browser => null;
  @override
  Io? get io => null;
  @override
  Node? get node => null;
  @override
  Map<String, dynamic> toMap() => {'fake': true};
}

void main() {
  test('github actions', () {
    var platform = FakePlatform(environment: {'GITHUB_ACTIONS': 'true'});
    expect(platform.runningOnGithub, isTrue);
    expect(platform.runningOnGitlab, isFalse);
    expect(platform.runningOnCloudCi, isTrue);
  });

  test('local', () {
    var context = FakeContext(platform: FakePlatform());
    expect(context.platform!.isLinux, isTrue);
    expect(context.platform!.runningOnCloudCi, isFalse);
    expect(context.browser, isNull);
  });
}
```

## Common mistakes

* Testing `browser.isChrome` before `isChromeEdge`: Chromium Edge is Chrome.
* Testing `os.isLinux` before `os.isAndroid` in a browser: Android is Linux.
* Expecting `toMap()` to have a stable schema: it is for logging only.

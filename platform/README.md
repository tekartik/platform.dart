# tekartik_platform

The abstract "where am I running" model: a `PlatformContext` tells shared code
whether it runs on io (Dart VM, Flutter mobile and desktop) or in a browser,
and on which OS or browser. This package only holds the interfaces (it works on
every platform); the contexts come from the implementation packages of the same
repo:

* `tekartik_platform_io` (`path: platform_io`): `platformContextIo` (Dart VM,
  Flutter mobile and desktop, `dart:io`).
* `tekartik_platform_browser` (`path: platform_browser`):
  `platformContextBrowser` (browser, `package:web`).

## Getting started

The packages are not on pub.dev, add them as git dependencies (the
implementation only in the app that picks the platform):

```yaml
dependencies:
  tekartik_platform:
    git:
      url: https://github.com/tekartik/platform.dart
      path: platform
  tekartik_platform_io:
    git:
      url: https://github.com/tekartik/platform.dart
      path: platform_io
```

Shared code takes a `PlatformContext`, `main` passes the one of its platform:

```dart
import 'package:tekartik_platform/context.dart';
import 'package:tekartik_platform/util/ci_util.dart';
import 'package:tekartik_platform_io/context_io.dart';

/// Shared code: only depends on tekartik_platform.
String describe(PlatformContext context) {
  final io = context.io;
  if (io != null) {
    final os = io.isWindows
        ? 'Windows'
        : io.isMacOS
        ? 'macOS'
        : io.isLinux
        ? 'Linux'
        : 'other';
    final ci = io.runningOnCloudCi ? ' (CI)' : '';
    return 'io on $os$ci';
  }
  final browser = context.browser;
  if (browser != null) {
    return 'browser ${browser.isChrome ? 'Chrome' : 'other'} ${browser.version}';
  }
  return 'unknown';
}

void main() {
  print(describe(platformContextIo)); // io on Linux
}
```

In a web app, `main` passes `platformContextBrowser` from
`package:tekartik_platform_browser/context_browser.dart` instead.

## What is in the context

* `context.io` (`Io?`, io only): `isWindows`, `isMacOS`, `isLinux`,
  `isAndroid`, `isIOS`, `environment`.
* `context.platform` (`Platform?`): the same process view, non null on io.
* `context.browser` (`Browser?`, browser only): `isChrome` (also true for
  Edge and Chromium, test `isChromeEdge`/`isChromeChromium` first),
  `isFirefox`, `isSafari`, `version` (a `pub_semver` `Version`), `isMobile`,
  `os`, `device`.
* `context.node`: null in both shipped contexts.
* `toMap()`: a debug dump.
* `util/ci_util.dart`: `runningOnGithub`, `runningOnGitlab`,
  `runningOnCloudCi` on a `Platform` (from its environment variables).

## Common pitfalls

* Test the nullable views (`context.io`, `context.browser`), never assume one.
* `platformContextIo` throws `UnimplementedError` on the web (use
  `platformContextIoOrNull` in code that compiles for both), keep it in the io
  entry point.
* In a test, implement `PlatformContext` with a fake instead of reading the
  real one.

Agent skill: [skills/tekartik-platform-context](skills/tekartik-platform-context/SKILL.md).

---
name: tekartik-platform-test-setup
description: >-
  Use when exercising a tekartik_platform PlatformContext implementation
  (platformContextIo, platformContextBrowser or a fake) with the shared
  tekartik_platform_test runner: the platform_context_example.dart library,
  its run(PlatformContext context) entry point, the late print hook that must
  be set first (common.print = print or a DOM writer), wiring it into an io or
  browser example, and capturing its lines in a test.
---

# tekartik_platform_test: the shared context example runner

`tekartik_platform_test` is the repo's dev helper for `tekartik_platform`
implementations: one library that walks a `PlatformContext` and reports every
flag through a pluggable `print`. The `platform_io` and `platform_browser`
examples feed it their context; a consumer can feed it a custom
implementation, or capture its output in a test.

## Guidelines

* Dependency (git, not on pub.dev; a dev dependency in practice):
  ```yaml
  dev_dependencies:
    tekartik_platform_test:
      git:
        url: https://github.com/tekartik/platform.dart
        path: platform_test
  ```
  Inside the repo workspace it is `path: ../platform_test`. It depends on
  `tekartik_platform` (same repo, `path: platform`) only.
* Import `package:tekartik_platform_test/platform_context_example.dart` with
  a prefix (`as common`): the library hides `dart:core`'s `print` and declares
  its own top level `late void Function(Object? object) print`, so an
  unprefixed import would shadow `print` in your file.
* Set `common.print` before calling `common.run(context)`; it is `late` and
  the first line `run` emits throws `LateInitializationError` otherwise. On
  io assign `dart:core` `print`; in a browser assign a function that appends
  to the DOM; in a test assign a closure that collects the lines.
* `run(PlatformContext context)` reads, in order: `context.io?.isAndroid`,
  `context.platform` (`isWindows` / `isMacOS` / `isLinux`, then
  `environment`), `context.browser` (`isChrome` split into `isChromeEdge`,
  `isChromeChromium` or Chrome, `isSafari`, `isFirefox`, `isIe`, `version`,
  `os.isWindows` / `isMac` / `isLinux` / `isIOS` / `isAndroid`, `isMobile`,
  `device.isIPod` / `isIPad` / `isIPhone` / `supportsTouch`, `isDartVm`).
  Lines are `We are on Linux`, `environment: {...}`, `version 120.0.0+0`,
  `Touch supported`, `We are running on a browser with a Javascript/Wasm VM`
  and so on; nothing is asserted, it only prints.
* The context comes from an implementation package: `platformContextIo`
  (`package:tekartik_platform_io/context_io.dart`), `platformContextBrowser`
  (`package:tekartik_platform_browser/context_browser.dart`), or a class of
  yours implementing `PlatformContext` from
  `package:tekartik_platform/context.dart`.
* There is no `run*Tests` suite with expectations in this package; to test an
  implementation, capture the lines and `expect` on them, and keep the
  browser cases under `@TestOn('browser')`.

## Examples

### io example

```dart
import 'package:tekartik_platform_io/context_io.dart';
import 'package:tekartik_platform_test/platform_context_example.dart' as common;

void main() {
  common.print = print;
  common.run(platformContextIo);
}
```

### Browser example writing into the page

```dart
import 'package:tekartik_platform_browser/context_browser.dart';
import 'package:tekartik_platform_test/platform_context_example.dart' as common;
import 'package:web/web.dart';

void main() {
  var out = document.createElement('pre');
  document.body!.appendChild(out);
  common.print = (object) => out.appendChild(Text('$object\n'));
  common.run(platformContextBrowser);
}
```

### Capture the report of the io context in a test

```dart
@TestOn('vm')
library;

import 'package:tekartik_platform_io/context_io.dart';
import 'package:tekartik_platform_test/platform_context_example.dart' as common;
import 'package:test/test.dart';

void main() {
  test('io context report', () {
    var lines = <String>[];
    common.print = (object) => lines.add('$object');
    common.run(platformContextIo);
    expect(lines, anyElement(startsWith('We are on ')));
    expect(lines, anyElement(startsWith('environment: ')));
  });
}
```

### Run it against a custom implementation

```dart
import 'package:tekartik_platform/context.dart';
import 'package:tekartik_platform_test/platform_context_example.dart' as common;
import 'package:test/test.dart';

class WindowsPlatform implements Platform {
  @override
  bool get isWindows => true;
  @override
  bool get isMacOS => false;
  @override
  bool get isLinux => false;
  @override
  Map<String, String> get environment => {'USERPROFILE': r'C:\Users\me'};
}

class WindowsContext implements PlatformContext {
  @override
  Browser? get browser => null;
  @override
  Io? get io => null;
  @override
  Node? get node => null;
  @override
  Platform? get platform => WindowsPlatform();
  @override
  Map<String, dynamic> toMap() => {'fake': 'windows'};
}

void main() {
  test('fake windows context', () {
    var lines = <String>[];
    common.print = (object) => lines.add('$object');
    common.run(WindowsContext());
    expect(lines.first, 'We are on Windows');
    expect(lines.last, startsWith('environment: '));
  });
}
```

## Common mistakes

* Calling `common.run` before assigning `common.print`.
* Importing the library without a prefix and losing `dart:core` `print`.
* Expecting `run` to fail on a wrong context: it never asserts, add `expect`
  on the captured lines.

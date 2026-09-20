---
name: tekartik-platform-io-setup
description: >-
  Use when Dart VM, CLI or Flutter native code needs the tekartik_platform
  context backed by dart:io with tekartik_platform_io: platformContextIo,
  platformContextIoOrNull, platformIo and platformIoOrNull from
  context_io.dart, PlatformContextIo with userHomePath and userAppDataPath,
  the io view (isWindows, isMacOS, isLinux, isAndroid, isIOS, environment),
  the UnimplementedError thrown when compiled for the web, ioRunningOnCloudCi
  and platformIo.runningOnGithub / runningOnGitlab / runningOnCloudCi from
  util/ci_util.dart, and running the shared tekartik_platform_test example.
---

# tekartik_platform_io: the dart:io implementation

`tekartik_platform_io` implements the `tekartik_platform` context with
`dart:io`'s `Platform` and `process_run`'s user directories: the `io` and
`platform` views are filled, `browser` and `node` are null. Every import is
safe on the web; only accessing the context is io only.

## Guidelines

* Dependency (git, not on pub.dev):
  ```yaml
  dependencies:
    tekartik_platform_io:
      git:
        url: https://github.com/tekartik/platform.dart
        path: platform_io
  ```
  It brings `tekartik_platform` (same repo, `path: platform`), `process_run`
  and `path`. `context_io.dart` does not re-export
  `package:tekartik_platform/context.dart`: import it (and declare
  `tekartik_platform`) wherever you name `PlatformContext`, `Platform` or
  `Io`. If `dart:io` is imported in the same file, prefix one of them
  (`import 'dart:io' as io;`) because both define `Platform`.
* Import `package:tekartik_platform_io/context_io.dart`:
  - `platformContextIo` (`PlatformContextIo`): the singleton context; throws
    `UnimplementedError('platformContextIo io only')` in code compiled for
    the web.
  - `platformContextIoOrNull` (`PlatformContextIo?`): same, null on the web.
  - `platformIo` (`Platform`): `platformContextIo.platform!`, the non null
    process view; `platformIoOrNull` for multiplatform code.
  - `PlatformContextIo extends PlatformContext`: adds `userHomePath`
    (`HOME`, or `USERPROFILE` on Windows) and `userAppDataPath` (`APPDATA`
    on Windows, `$HOME/.config` elsewhere), both read through
    `process_run`'s `shell.dart`.
* The views keep the abstract types: `platformContextIo.io` is `Io?` and
  `.platform` is `Platform?`, so either `!` them or use `platformIo`.
  `Platform` gives `isWindows`, `isMacOS`, `isLinux` and `environment`
  (`dart:io` `Platform.environment`); `Io` adds `isAndroid`, `isIOS` and the
  `isMac` alias. `toMap()` is `{'io': {'platform': 'linux' | 'mac' |
  'windows' | 'android' | 'ios' | 'unknown'}}`, for logging.
* Build per-user paths with `package:path` `join` on `userAppDataPath` /
  `userHomePath`; create the directory yourself, the getters only compute
  the string.
* CI detection: `package:tekartik_platform_io/util/ci_util.dart` re-exports
  `context_io.dart` and `package:tekartik_platform/util/ci_util.dart`, so
  `platformIo.runningOnGithub` (`GITHUB_ACTIONS == 'true'`),
  `platformIo.runningOnGitlab` (`CI_PROJECT_NAME`, `GITLAB_USER_ID`,
  `CI_RUNNER_VERSION` set) and `platformIo.runningOnCloudCi` are available,
  and adds the top level `ioRunningOnCloudCi`, false on the web instead of
  throwing. `util/github_util.dart` is the github only subset.
* Platform split: shared code takes a `PlatformContext`; `main` passes
  `platformContextIo`, the web entry point passes `platformContextBrowser`
  from `tekartik_platform_browser`. In a library that is compiled for both,
  read `platformContextIoOrNull` / `platformIoOrNull`, or guard with
  `kDartIsWeb` from `package:tekartik_common_utils/env_utils.dart`.
* Tests: `dart test` on the VM. Mark tests that touch the context
  `@TestOn('vm')` or `skip: kDartIsWeb`; the package's own api test runs on
  vm, chrome and node and only catches the `UnimplementedError`.
* Shared demo: `run(context)` in
  `package:tekartik_platform_test/platform_context_example.dart` (same repo,
  `path: platform_test`, dev dependency) prints what a context reports once
  its `print` hook is set, see `example/platform_context_io_example.dart`.

## Examples

### Inspect the process platform and user directories

```dart
import 'package:tekartik_platform_io/context_io.dart';

void main() {
  var context = platformContextIo;
  print(context.toMap()); // {io: {platform: linux}}
  print('home: ${context.userHomePath}');
  print('app data: ${context.userAppDataPath}');

  var io = context.io!;
  if (io.isWindows) {
    print('windows');
  } else if (io.isMacOS) {
    print('macos');
  } else if (io.isLinux) {
    print('linux');
  } else if (io.isAndroid) {
    print('android');
  } else if (io.isIOS) {
    print('ios');
  }
  print('shell: ${platformIo.environment['SHELL']}');
}
```

### Per-user settings file

```dart
import 'dart:io';

import 'package:path/path.dart';
import 'package:tekartik_platform_io/context_io.dart';

/// ~/.config/<appName>/settings.json, or %APPDATA%\<appName>\settings.json.
File userSettingsFile(String appName) =>
    File(join(platformContextIo.userAppDataPath, appName, 'settings.json'));

Future<void> main() async {
  var file = userSettingsFile('my_tool');
  await file.parent.create(recursive: true);
  if (!file.existsSync()) {
    await file.writeAsString('{}');
  }
  print(file.path);
}
```

### Shared code, io entry point

```dart
import 'package:tekartik_platform/context.dart';
import 'package:tekartik_platform_io/context_io.dart';

void main() {
  // The web entry point calls run(platformContextBrowser) instead.
  run(platformContextIo);
}

void run(PlatformContext context) {
  var platform = context.platform;
  if (platform != null) {
    print('process on ${platform.isWindows ? 'windows' : 'posix'}');
  } else if (context.browser != null) {
    print('browser ${context.browser!.version}');
  }
}
```

### CI-aware tests

```dart
import 'package:tekartik_platform_io/util/ci_util.dart';
import 'package:test/test.dart';

void main() {
  test('needs local credentials', () {
    // ...
  }, skip: ioRunningOnCloudCi ? 'no credentials on cloud CI' : false);

  test('which ci', () {
    if (!ioRunningOnCloudCi) {
      return;
    }
    print('github: ${platformIo.runningOnGithub}');
    print('gitlab: ${platformIo.runningOnGitlab}');
  });
}
```

### Multiplatform library: null on the web

```dart
import 'package:tekartik_platform_io/context_io.dart';

/// Null when compiled for the web.
String? get userHomePathOrNull => platformContextIoOrNull?.userHomePath;

bool get isWindowsProcess => platformIoOrNull?.isWindows ?? false;

void main() {
  print('home: $userHomePathOrNull, windows: $isWindowsProcess');
}
```

## Common mistakes

* Naming `PlatformContext` or `Platform` with only `context_io.dart`
  imported: add `package:tekartik_platform/context.dart`.
* Accessing `platformContextIo` or `platformIo` in a library compiled for the
  web: use the `OrNull` getters.
* Reading `platformContextIo.io.isWindows` without `!`: `io` is `Io?`.
* Expecting `userAppDataPath` to exist on disk.

# tekartik_platform_io

The io implementation of [tekartik_platform](../platform/README.md):
`platformContextIo` tells Dart VM, CLI and Flutter mobile/desktop code which OS
it runs on, its environment and the user directories (`dart:io` and
`process_run`).

## Getting started

Not on pub.dev, add it as a git dependency (with `tekartik_platform` when you
name `PlatformContext` or `Platform` yourself):

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

```dart
import 'package:path/path.dart';
// Also exports context_io.dart (platformContextIo, platformIo...)
import 'package:tekartik_platform_io/util/ci_util.dart';

void main() {
  var context = platformContextIo;
  var io = context.io!;
  print(io.isWindows ? 'windows' : io.isMacOS ? 'macos' : 'linux or other');
  print(context.toMap()); // {io: {platform: linux}}

  // ~/.config/my_tool, %APPDATA%\my_tool on Windows (not created)
  print(join(context.userAppDataPath, 'my_tool'));
  print(context.userHomePath); // HOME, or USERPROFILE on Windows

  // GitHub Actions or GitLab CI
  print('cloud ci: $ioRunningOnCloudCi');
}
```

## Platforms

* Dart VM, CLI, Flutter mobile and desktop: the context, with `io` and
  `platform` set (`browser` and `node` null).
* Web: importing is safe, `platformContextIo` and `platformIo` throw an
  `UnimplementedError`; `platformContextIoOrNull`, `platformIoOrNull` and
  `ioRunningOnCloudCi` return null or false.

## Main entry points

* `package:tekartik_platform_io/context_io.dart`: `platformContextIo`
  (`PlatformContextIo`: `io`, `platform`, `userHomePath`, `userAppDataPath`,
  `toMap()`), `platformIo` (the `Platform`: `isWindows`, `isMacOS`,
  `isLinux`, `environment`), and their `OrNull` variants for code that also
  compiles for the web.
* `package:tekartik_platform_io/util/ci_util.dart`: `ioRunningOnCloudCi`, and
  the `runningOnGithub`, `runningOnGitlab`, `runningOnCloudCi` extensions of
  `Platform` (`platformIo.runningOnGithub`).

## Common pitfalls

* `context_io.dart` does not export `package:tekartik_platform/context.dart`:
  import it to name `PlatformContext`, `Platform` or `Io`. With `dart:io` in
  the same file, prefix one of them (`import 'dart:io' as io;`): both define
  `Platform`.
* `io` and `platform` are nullable in the interface: use `!`, or `platformIo`.
* `userAppDataPath` and `userHomePath` only compute a path: create the
  directory yourself.

Example: [example/platform_context_io_example.dart](example/platform_context_io_example.dart).
Agent skill: [skills/tekartik-platform-io-setup](skills/tekartik-platform-io-setup/SKILL.md).

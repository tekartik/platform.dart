# tekartik_platform_test

A dev helper of this repo: `run(PlatformContext context)` prints what a
[tekartik_platform](../platform/README.md) context reports (OS, environment,
browser, version, device), through a `print` hook that you set first. The
`platform_io` and `platform_browser` examples use it; it asserts nothing.

```yaml
dev_dependencies:
  tekartik_platform_test:
    git:
      url: https://github.com/tekartik/platform.dart
      path: platform_test
```

```dart
import 'package:tekartik_platform_io/context_io.dart';
import 'package:tekartik_platform_test/platform_context_example.dart'
    as common;

void main() {
  // Required first (late): print, a DOM writer, or a line collector in a test
  common.print = print;
  common.run(platformContextIo); // We are on Linux, environment: {...}
}
```

Import it with a prefix: the library declares its own top level `print`.
Agent skill: [skills/tekartik-platform-test-setup](skills/tekartik-platform-test-setup/SKILL.md).

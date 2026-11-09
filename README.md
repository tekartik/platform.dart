# platform.dart

Platform abstraction: shared code asks a `PlatformContext` where it runs (io or
browser, which OS, which browser).

* [platform](platform) (`tekartik_platform`): the interfaces, for shared code.
* [platform_io](platform_io) (`tekartik_platform_io`): `platformContextIo`
  (Dart VM, Flutter mobile and desktop).
* [platform_browser](platform_browser) (`tekartik_platform_browser`):
  `platformContextBrowser` (browser).
* [platform_test](platform_test) (`tekartik_platform_test`): dev helper that
  prints what a context reports.

The packages are not on pub.dev, add them as git dependencies:

```yaml
dependencies:
  tekartik_platform_io:
    git:
      url: https://github.com/tekartik/platform.dart
      path: platform_io
  tekartik_platform_browser:
    git:
      url: https://github.com/tekartik/platform.dart
      path: platform_browser
```

See [platform/README.md](platform/README.md) for the usage.

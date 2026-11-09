# platform.dart

Platform abstraction: shared code asks a `PlatformContext` where it runs (io or
browser, which OS, which browser).

* [platform](platform) (`tekartik_platform`): the interfaces, for shared code.
* [platform_io](platform_io) (`tekartik_platform_io`): `platformContextIo`
  (Dart VM, Flutter mobile and desktop).
* [platform_browser](platform_browser) (`tekartik_platform_browser`):
  `platformContextBrowser` (browser).

## IO Setup

```yaml
dependencies:
  tekartik_platform_io:
    git:
      url: https://github.com/tekartik/platform.dart
      path: platform_io
    version: '>=0.2.1'
```

## Browser Setup

```yaml
dependencies:
  tekartik_platform_browser:
    git:
      url: https://github.com/tekartik/platform.dart
      path: platform_browser
    version: '>=0.2.1'
```

See [platform/README.md](platform/README.md) for the usage.

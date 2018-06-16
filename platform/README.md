# platform context

Helper to figure out the platform context (browser/io, windows/mac/linux, ie/firefox/chrome, dartvm/js)

The `PlatformContext` object can be used in both browser and io application to test the current environment

[Web demo](http://alextekartik.github.io/platform_context_example.dart/build/example/platform_context_browser_example.html)

## Setup

### IO application

```dart
import 'package:tekartik_platform/context_io.dart';

main() {
  run(ioPlatformContext);
}
```

### Browser application

```
import 'package:tekartik_platform/context_browser.dart';

main() {
  run(browserPlatformContext);
}
```

## Usage

then you can use the `PlatformContext` object later in your application. The following code can run both on browser and 
io application

```dart
import 'package:tekartik_platform/context.dart';

run(PlatformContext context) {
  if (context.io != null) {
    if (context.io.isWindows) {
      print('We are on Windows');
    } else if (context.io.isMac) {
      print('We are on Mac');
    } else if (context.io.isLinux) {
      print('We are on Linux');
    } else if (context.io.isAndroid) {
      print('We are on Android');
    }
  }
  if (context.browser != null) {
    if (context.browser.isChrome) {
      print('We are on Chrome');
    } else if (context.browser.isSafari) {
      print('We are on Safari');
    } else if (context.browser.isFirefox) {
      print('We are on Firefox');
    } else if (context.browser.isIe) {
      print('We are on IE/Edge');
    }

    if (context.browser.isDartVm) {
      print('We are running on Dart VM');
    } else {
      print('We are running on Javascript VM');
    }
  }
}
```


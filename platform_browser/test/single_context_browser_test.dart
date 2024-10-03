@TestOn('browser')
library;

import 'package:tekartik_platform_browser/context_browser.dart';
//import 'package:tekartik_utils/dev_utils.dart';
import 'package:test/test.dart';

void main() {
  group('context', () {
    //PlatformContext context = browserPlatformContext;

    test('browser', () {
      print(platformContextBrowser.browser!.isMobile);
      print(platformContextBrowser.browser!.device.supportsTouch);
    });
  });
}

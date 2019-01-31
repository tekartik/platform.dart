library platform_context.test.quick_snippet.dart;

import 'package:dev_test/test.dart';
import 'package:tekartik_platform_browser/src/browser_detect_common.dart';

//
// Dart vs Javascript detection
//
bool get isDartVm => !isJavascriptVm;
bool get isJavascriptVm => identical(1.0, 1);

//
// Navigator detection
//

// to perform navigator test validation without importing the whole project
bool canBeUserAgentChrome(String userAgent) => userAgent.contains('Chrome');

bool isUserAgentIe(String userAgent) {
  // Yoga IE 11: Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729; Tablet PC 2.0; MALNJS; rv:11.0) like Gecko
  // Yoga Edge 12: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.10240
  return userAgent.contains('Trident') || userAgent.contains('Edge');
}

bool isUserAgentSafari(String userAgent) {
  // Safari 9: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.1.56 (KHTML, like Gecko) Version/9.0 Safari/601.1.56
  return !isUserAgentIe(userAgent) &&
      !canBeUserAgentChrome(userAgent) &&
      userAgent.contains('Safari');
}

bool isUserAgentChrome(String userAgent) {
  // Chrome 46: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36";
  // Edge contains Safari and Chrome markers!
  return !isUserAgentIe(userAgent) && canBeUserAgentChrome(userAgent);
}

void main() {
  group('navigator', () {
    String safari9UserAgent =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.1.56 (KHTML, like Gecko) Version/9.0 Safari/601.1.56";
    String ie11UserAgent =
        "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729; Tablet PC 2.0; MALNJS; rv:11.0) like Gecko";
    String edge12UserAgent =
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.10240";
    String chrome46UserAgent =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36";

    List<String> userAgents = [
      safari9UserAgent,
      ie11UserAgent,
      edge12UserAgent,
      chrome46UserAgent
    ];

    test('all', () {
      for (String userAgent in userAgents) {
        BrowserDetectCommon detect = BrowserDetectCommon()
          ..userAgent = userAgent;
        expect(isUserAgentIe(userAgent), detect.isIe);
        expect(isUserAgentSafari(userAgent), detect.isSafari);
        expect(isUserAgentChrome(userAgent), detect.isChrome);
      }
    });
  });

  test('vm', () {
    expect(isJavascriptVm, isRunningAsJavascript);
    expect(isDartVm, !isRunningAsJavascript);
  });
}

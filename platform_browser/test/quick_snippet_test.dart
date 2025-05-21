library;

import 'package:tekartik_platform_browser/src/browser_detect_common.dart';
import 'package:test/test.dart';

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
  return userAgent.contains('Trident');
}

bool isUserAgentEdge(String userAgent) {
  // Yoga Edge 12: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.10240
  return userAgent.contains('Edge/');
}

bool isUserAgentChromeEdge(String userAgent) {
  // Yoga Edge 12: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.10240
  return userAgent.contains('Edg/');
}

bool isUserAgentSafari(String userAgent) {
  // Safari 9: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.1.56 (KHTML, like Gecko) Version/9.0 Safari/601.1.56
  return !isUserAgentIe(userAgent) &&
      !canBeUserAgentChrome(userAgent) &&
      userAgent.contains('Safari');
}

bool isUserAgentChrome(String userAgent) {
  // Chrome 46: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36';
  // Edge contains Safari and Chrome markers!
  return !isUserAgentIe(userAgent) &&
      !isUserAgentEdge(userAgent) &&
      canBeUserAgentChrome(userAgent);
}

void main() {
  group('navigator', () {
    final safari9UserAgent =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.1.56 (KHTML, like Gecko) Version/9.0 Safari/601.1.56';
    final ie11UserAgent =
        'Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729; Tablet PC 2.0; MALNJS; rv:11.0) like Gecko';
    // Deprecated
    final edge12UserAgent =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.10240';
    final chrome46UserAgent =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36';
    final edge120UserAgent =
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0'; // 2023-12-20

    final userAgents = <String>[
      safari9UserAgent,
      ie11UserAgent,
      edge12UserAgent,
      chrome46UserAgent,
      edge120UserAgent,
    ];

    test('all', () {
      for (final userAgent in userAgents) {
        final detect = BrowserDetectCommon()..userAgent = userAgent;
        expect(isUserAgentIe(userAgent), detect.isIe, reason: userAgent);
        expect(
          isUserAgentSafari(userAgent),
          detect.isSafari,
          reason: userAgent,
        );
        expect(
          isUserAgentChrome(userAgent),
          detect.isChrome,
          reason: userAgent,
        );
        expect(isUserAgentEdge(userAgent), detect.isEdge, reason: userAgent);
        expect(
          isUserAgentChromeEdge(userAgent),
          detect.isChromeEdge,
          reason: userAgent,
        );
      }
    });
  });

  test('vm', () {
    expect(isJavascriptVm, isRunningAsJavascript);
    expect(isJavascriptVm, kDartIsWeb);
    expect(isDartVm, !isRunningAsJavascript);
  });
}

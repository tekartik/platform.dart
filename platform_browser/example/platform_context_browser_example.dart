import 'dart:convert';
import 'dart:core' hide print;
import 'dart:html';

import 'package:tekartik_platform/context.dart';
import 'package:tekartik_platform_browser/context_browser.dart';
import 'package:tekartik_platform_test/platform_context_example.dart' as common;

int line = 0;
Element out;

void displayPrint(String text) {
  if (out == null) {
    out = document.body.querySelector('#out');
  }
  out.appendText('$text\n');
}

void main() {
  run(platformContextBrowser);
}

void run(PlatformContext context) {
  common.print = displayPrint;
  common.run(context);

  document.body.querySelector('#context').text =
      const JsonEncoder.withIndent('  ').convert(context.toMap());

  display('navigator.platform', window.navigator.platform);
  display('navigator.userAgent', window.navigator.userAgent);
  display('navigator.appVersion', window.navigator.appVersion);
  display('navigator.language', window.navigator.language);
  display('navigator.vendor', window.navigator.vendor);
  display('navigator.appCodeName', window.navigator.appCodeName);
  display('navigator.appName', window.navigator.appName);
  display('navigator.vendorSub', window.navigator.vendorSub);
  display('navigator.dartEnabled', window.navigator.dartEnabled.toString());

  document.body.querySelector('#info').text =
      const JsonEncoder.withIndent('  ').convert(info);
}

Element list;
Map info = {};

void display(String name, String value) {
  info[name] = value;
}

/*
 Dartium

{
  "browser": {
    "navigator": "dartium",
    "version": "39.0.2171+0",
    "dartVm": true
  }
}
{
  "navigator.platform": "Linux x86_64",
  "navigator.userAgent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.0 (Dart) Safari/537.36",
  "navigator.appVersion": "5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.0 (Dart) Safari/537.36",
  "navigator.language": "en-US",
  "navigator.vendor": "Google Inc.",
  "navigator.appCodeName": "Mozilla",
  "navigator.appName": "Netscape",
  "navigator.vendorSub": "",
  "navigator.dartEnabled": "true"
}
 */

/*
Firefox
{
  "browser": {
    "navigator": "firefox",
    "version": "42.0.0"
  }
}
{
  "navigator.platform": "Linux x86_64",
  "navigator.userAgent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:42.0) Gecko/20100101 Firefox/42.0",
  "navigator.appVersion": "5.0 (X11)",
  "navigator.language": "en-US",
  "navigator.vendor": "",
  "navigator.appCodeName": "Mozilla",
  "navigator.appName": "Netscape",
  "navigator.vendorSub": "",
  "navigator.dartEnabled": "null"
}
 */

/*
Chrome

{
  "browser": {
    "navigator": "chrome",
    "version": "46.0.2490+86"
  }
}
{
  "navigator.platform": "Linux x86_64",
  "navigator.userAgent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36",
  "navigator.appVersion": "5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36",
  "navigator.language": "en-US",
  "navigator.vendor": "Google Inc.",
  "navigator.appCodeName": "Mozilla",
  "navigator.appName": "Netscape",
  "navigator.vendorSub": "",
  "navigator.dartEnabled": "null"
}
 */

/*
 Chromium

 {
  "browser": {
    "navigator": "chromium",
    "version": "45.0.2454+101"
  }
}
{
  "navigator.platform": "Linux x86_64",
  "navigator.userAgent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36",
  "navigator.appVersion": "5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/45.0.2454.101 Chrome/45.0.2454.101 Safari/537.36",
  "navigator.language": "en-US",
  "navigator.vendor": "Google Inc.",
  "navigator.appCodeName": "Mozilla",
  "navigator.appName": "Netscape",
  "navigator.vendorSub": "",
  "navigator.dartEnabled": "null"
}
 */

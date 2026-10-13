import 'dart:convert';
import 'dart:core' hide print;

import 'package:tekartik_js_utils_interop/js_converter.dart';
import 'package:tekartik_platform_browser/context_browser.dart';
import 'package:tekartik_platform_test/platform_context_example.dart' as common;
import 'package:web/web.dart';

int line = 0;
Element? out;

void displayPrint(Object? object) {
  out ??= document.body!.querySelector('#out');
  out!.appendChild(Text('$object\n'));
}

void main() {
  run(platformContextBrowser);
}

void run(PlatformContext context) {
  common.print = displayPrint;
  common.run(context);

  document.body!.querySelector('#context')!.textContent =
      const JsonEncoder.withIndent('  ').convert(context.toMap());

  // All navigator properties (own and inherited, functions excluded)
  jsObjectToPropertyMap(window.navigator).forEach((key, value) {
    display('navigator.$key', value);
  });

  document.body!.querySelector('#info')!.textContent =
      const JsonEncoder.withIndent('  ').convert(info);
}

Element? list;
Map info = {};

void display(String name, Object? value) {
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

/// The browser platform context: [platformContextBrowser] (browser, OS and
/// device read from the user agent), web only (it throws on the Dart VM).
///
/// Also exports the `tekartik_platform` interfaces (`PlatformContext`,
/// `Browser`, `OperatingSystem`, `BrowserDevice`).
library;

export 'package:tekartik_platform/context.dart';
export 'src/export/export.dart' show platformContextBrowser;

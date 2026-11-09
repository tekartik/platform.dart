/// The io platform context: [platformContextIo] on the Dart VM, CLI and
/// Flutter mobile/desktop, it throws on the web where
/// [platformContextIoOrNull] is null.
library;

import 'package:tekartik_platform/context.dart';

export 'src/export/export.dart'
    show
        platformContextIo,
        platformIo,
        platformIoOrNull,
        platformContextIoOrNull;

/// Io platform context
abstract class PlatformContextIo extends PlatformContext {
  /// Get user home path (HOME or USERPROFILE)
  String get userHomePath;

  /// Get user app data path (APPDATA on windows ~/.config on Mac/Linux)
  String get userAppDataPath;
}

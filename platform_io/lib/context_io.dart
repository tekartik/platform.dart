import 'package:tekartik_platform/context.dart';

import 'src/context_io.dart' as context_io;

abstract class PlatformContextIo extends PlatformContext {
  /// Get user home path (HOME or USERPROFILE)
  String get userHomePath;

  /// Get user app data path (APPDATA on windows ~/.config on Mac/Linux)
  String get userAppDataPath;
}

PlatformContextIo get platformContextIo => context_io.ioPlatformContext;

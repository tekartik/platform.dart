import 'package:tekartik_platform/context.dart';
import 'package:tekartik_platform_io/context_io.dart';

import 'export_stub.dart' if (dart.library.io) 'export_io.dart' as impl;

/// Io platform
Platform get platformIo => platformContextIo.platform!;

/// Io platform
Platform? get platformIoOrNull => platformContextIo.platform;

/// IO platform content, null on other platforms.
PlatformContextIo get platformContextIo => impl.platformContextIoOrNull!;

/// IO platform content, null on other platforms.
PlatformContextIo? get platformContextIoOrNull => impl.platformContextIoOrNull;

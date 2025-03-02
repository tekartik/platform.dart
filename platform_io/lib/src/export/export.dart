import 'package:tekartik_platform/context.dart';

import '../../context_io.dart';
import 'export_stub.dart' if (dart.library.io) 'export_io.dart' as impl;

/// Io platform
Platform get platformIo => platformContextIo.platform!;

/// Io platform, null on other platforms.
Platform? get platformIoOrNull => platformContextIoOrNull?.platform;

/// IO platform content, null on other platforms.
PlatformContextIo get platformContextIo => impl.platformContextIo;

/// IO platform content, null on other platforms.
PlatformContextIo? get platformContextIoOrNull => impl.platformContextIoOrNull;

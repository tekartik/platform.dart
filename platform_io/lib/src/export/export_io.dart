import 'package:tekartik_platform_io/context_io.dart';
import 'package:tekartik_platform_io/src/context_io.dart' as context_io;

/// IO platform content.
PlatformContextIo? get platformContextIoOrNull =>
    context_io.platformContextIoSingleton;

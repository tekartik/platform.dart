import 'package:tekartik_platform/context.dart';
import 'package:tekartik_platform_io/context_io.dart';

export 'export_stub.dart' if (dart.library.io) 'export_io.dart';

/// Io platform
Platform get platformIo => platformContextIo.platform!;

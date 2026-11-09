import 'package:tekartik_platform/context.dart';

import '../../context_io.dart';
import 'export_stub.dart' if (dart.library.io) 'export_io.dart' as impl;

/// The io process platform (`isWindows`, `isMacOS`, `isLinux`,
/// `environment`), throws an [UnimplementedError] on the web.
Platform get platformIo => platformContextIo.platform!;

/// The io process platform, null on the web.
Platform? get platformIoOrNull => platformContextIoOrNull?.platform;

/// The io platform context (Dart VM, Flutter mobile and desktop), throws an
/// [UnimplementedError] on the web.
PlatformContextIo get platformContextIo => impl.platformContextIo;

/// The io platform context, null on the web.
PlatformContextIo? get platformContextIoOrNull => impl.platformContextIoOrNull;

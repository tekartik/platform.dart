import 'package:tekartik_platform/util/ci_util.dart';
import 'package:tekartik_platform_io/context_io.dart';

export 'package:tekartik_platform/util/ci_util.dart';
export 'package:tekartik_platform_io/context_io.dart';

/// When running on gitlab or github and on io. Safe on all platforms (false on web)
bool get ioRunningOnCloudCi => platformIoOrNull?.runningOnCloudCi ?? false;

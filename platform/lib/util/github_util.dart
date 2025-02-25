import 'package:tekartik_platform/context.dart';

/// Git hub extension
extension TekartikPlatformGithubExt on Platform {
  /// GITHUB_ACTIONS: 'true'
  /// True if running on github
  bool get runningOnGithub => environment['GITHUB_ACTIONS'] == 'true';
}

import 'package:tekartik_platform/context.dart';

extension TekartikPlatformExt on Platform {
  bool get runningOnGithub => environment['GITHUB_ACTIONS'] == 'true';
}

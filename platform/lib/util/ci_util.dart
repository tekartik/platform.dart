import 'package:tekartik_platform/context.dart';
import 'package:tekartik_platform/util/github_util.dart';
import 'package:tekartik_platform/util/gitlab_util.dart';
export 'github_util.dart';
export 'gitlab_util.dart';

/// Git hub extension
extension TekartikPlatformCloudCiExt on Platform {
  bool get runningOnCloudCi => runningOnGitlab || runningOnGithub;
}

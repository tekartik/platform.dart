import 'package:tekartik_platform/context.dart';

extension TekartikPlatformGitlabExt on Platform {
  /// GITLAB_USER_ID: 123456
  /// CI_RUNNER_VERSION: 17.7.0~pre.103.g896916a8
  /// CI_SERVER_NAME: GitLab
  /// CI_RUNNER_DESCRIPTION: 4-green.saas-linux-small-amd64.runners-manager.gitlab.com/default
  /// CI_PROJECT_NAME: xxxx  -->
  bool get runningOnGitlab =>
      environment.containsKey('CI_PROJECT_NAME') &&
      environment.containsKey('GITLAB_USER_ID') &&
      environment.containsKey('CI_RUNNER_VERSION');
}

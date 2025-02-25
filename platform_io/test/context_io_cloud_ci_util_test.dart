@TestOn('vm')
library;

import 'package:tekartik_platform/util/ci_util.dart';
import 'package:tekartik_platform/util/gitlab_util.dart';
import 'package:tekartik_platform_io/util/github_util.dart';
import 'package:test/test.dart';

void main() {
  group('ci_util', () {
    test('info', () {
      print('running on cloud ci: ${platformIo.runningOnCloudCi}');
      print('running on github actions: ${platformIo.runningOnGithub}');
      print('running on gitab job: ${platformIo.runningOnGitlab}');
    });
    test('github vs gitlab', () {
      if (platformIo.runningOnGithub) {
        expect(platformIo.runningOnGitlab, isFalse);
      }
      if (platformIo.runningOnGitlab) {
        expect(platformIo.runningOnGithub, isFalse);
      }
    });
  });
}

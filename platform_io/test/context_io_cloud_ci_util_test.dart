library;

import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_platform_io/util/ci_util.dart';
import 'package:test/test.dart';

void main() {
  group('ci_util', () {
    test('info', () {
      // ignore: avoid_print
      print('ioRunningOnCloudCi: $ioRunningOnCloudCi');
      if (kDartIsWeb) {
        expect(ioRunningOnCloudCi, isFalse);
      } else {
        // ignore: avoid_print
        print('running on github actions: ${platformIo.runningOnGithub}');
        // ignore: avoid_print
        print('running on gitab job: ${platformIo.runningOnGitlab}');
      }
    });
    test('github vs gitlab', () {
      if (!kDartIsWeb) {
        if (platformIo.runningOnGithub) {
          expect(platformIo.runningOnGitlab, isFalse);
        }
        if (platformIo.runningOnGitlab) {
          expect(platformIo.runningOnGithub, isFalse);
        }
      }
    });
  });
}

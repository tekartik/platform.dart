@TestOn('vm')
library;

import 'package:tekartik_platform_io/util/github_util.dart';
import 'package:test/test.dart';

void main() {
  group('github_util', () {
    test('info', () {
      print('running on github actions: ${platformIo.runningOnGithub}');
    });
  });
}

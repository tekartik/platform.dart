@TestOn('vm')
library tekartik_platform_node.context_node_test;

import 'package:tekartik_platform_node/context_node.dart';
import 'package:test/test.dart';

main() {
  group('io', () {
    test('info', () {
      expect(platformContextNode.node, isNotNull);
    });
  });
}

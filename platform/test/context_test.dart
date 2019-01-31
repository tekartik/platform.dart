import 'package:tekartik_platform/context.dart';
import 'package:test/test.dart';

class PlatformContextFake implements PlatformContext {
  @override
  Browser get browser => null;

  @override
  Io get io => null;

  @override
  Node get node => null;

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

void main() {
  group('context', () {
    test('info', () {
      expect(PlatformContextFake().toMap(), {});
    });
  });
}

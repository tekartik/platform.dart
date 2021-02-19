import 'package:dev_test/package.dart';

Future main() async {
  for (var dir in [
    'platform',
    'platform_browser',
    'platform_io',
    'platform_node',
    'platform_test',
  ]) {
    await packageRunCi(dir);
  }
}

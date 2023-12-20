import 'package:dev_build/package.dart';
import 'package:path/path.dart';

Future main() async {
  for (var dir in [
    'platform',
    'platform_browser',
    'platform_io',
    'platform_test',
  ]) {
    await packageRunCi(join('..', dir));
  }
}

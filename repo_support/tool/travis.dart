import 'package:process_run/shell.dart';
import 'package:path/path.dart';

Future main() async {
  var shell = Shell();

  for (var dir in [
    'platform',
    'platform_browser',
    'platform_io',
    'platform_node',
    'platform_test',
  ]) {
    print('package: $dir');
    shell = shell.pushd(join('..', dir));
    await shell.run('''
    
    pub get
    dart tool/travis.dart
    
''');
    shell = shell.popd();
  }
}

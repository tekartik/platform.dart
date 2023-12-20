import 'package:dev_build/package.dart';
import 'package:process_run/shell.dart';

Future main() async {
  await ioPackageRunCi('.');
  var shell = Shell();

  await shell.run('''
dart example/platform_context_io_example.dart
''');
}

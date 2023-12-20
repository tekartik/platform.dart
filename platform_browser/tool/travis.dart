import 'package:dev_build/package.dart';
import 'package:process_run/shell.dart';

Future main() async {
  var shell = Shell();
  await ioPackageRunCi('.');

  // added chrome test
  await shell.run('''
pub run build_runner test -- -p chrome
''');
}

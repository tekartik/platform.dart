import 'package:process_run/shell.dart';

Future main() async {
  var shell = Shell();

  await shell.run('''
  
dart example/platform_context_io_example.dart

dartanalyzer --fatal-warnings --fatal-infos .
pub run build_runner test -- -p vm,chrome
pub run test -p vm,chrome
''');
}

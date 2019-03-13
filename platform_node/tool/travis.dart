import 'package:process_run/shell.dart';
import 'run_example.dart' as example;

Future main() async {
  await example.main();
  var shell = Shell();

  await shell.run('''
dartanalyzer --fatal-warnings --fatal-infos example lib test tool
pub run build_runner test -- -p vm,node
pub run test -p vm,node
''');
}

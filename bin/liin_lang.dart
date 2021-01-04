import 'dart:io';
import 'package:liin_lang/liin_lang.dart';
import 'package:liin_lang/colors.dart';

const _help = '''Linear Instructions Language interpreter
Usage: liin [version/help/<file name>]

version   prints current version of liin
help      prints this hint
<file>    enter path of liin code for
          it's execution

Example:
liin ./hello_world.liin

If you run program without any arguments.
you\'ll run live interpreter

More information you can read here:
https://github.com/uSlashVlad/liin_lang''';

/// Just a main function that runs if launch this file.
/// You shouldn't call this function by hands
void main(List<String> args) async {
  if (args.isNotEmpty) {
    final mainArg = args[0];
    if (mainArg == 'version') {
      await runLiin(codeLines: ['> liin']);
    } else if (mainArg == 'help') {
      print(_help);
    } else {
      // Run file
      final fileName = args[0];
      final r = await runLiin(filePath: fileName);
      if (r.executionTime != null) {
        print(comment('Executed in ${r.executionTime!.inMilliseconds}ms'));
      }
    }
  } else {
    // Run live interpreter
    await runLiin(codeLines: ['> liin'], clearAfter: false);
    stdout.write('>> ');
    var inputLine = stdin.readLineSync();
    while (inputLine != 'exit') {
      await runLiin(codeLines: inputLine!.split('\\\\\\'), clearAfter: false);
      stdout.write('>> ');
      inputLine = stdin.readLineSync();
    }
  }
}

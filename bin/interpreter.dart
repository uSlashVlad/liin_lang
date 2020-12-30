import 'dart:io';
import 'package:liin_lang/liin_lang.dart';
import 'package:liin_lang/colors.dart';

/// Just a main function that runs if launch this file.
/// You shouldn't call this function by hands
void main(List<String> args) async {
  if (args.isNotEmpty) {
    final fileName = args[0];
    final r = await runLiin(fileName: fileName);
    print(comment('Executed in ${r.executionTime.inMilliseconds}ms'));
  } else {
    await runLiin(codeLines: ['> liin'], clearAfter: false);
    stdout.write('>> ');
    var inputLine = stdin.readLineSync();
    while (inputLine != 'exit') {
      await runLiin(codeLines: inputLine.split('\\\\\\'), clearAfter: false);
      stdout.write('>> ');
      inputLine = stdin.readLineSync();
    }
  }
}

import 'dart:io';
import 'vars.dart';
import 'colors.dart';
import 'code_runner.dart';

class LiinRunResult {
  LiinRunResult({
    this.context,
    this.blocks,
    this.output,
    this.executionTime,
  });
  final Map<String, dynamic> context;
  final Map<String, List<int>> blocks;
  final List<String> output;
  final Duration executionTime;
}

Future<LiinRunResult> runLiin({
  List<String> codeLines,
  String fileName,
  List<String> runInput,
  bool clearAfter = true,
}) async {
  if (runInput != null) input = runInput;

  DateTime startTime;
  if (codeLines != null) {
    startTime = DateTime.now();
    runCode(codeLines);
  } else if (fileName != null) {
    final l = File(fileName).readAsLinesSync();
    startTime = DateTime.now();
    runCode(l);
  } else {
    print(error('No code specified!'));
  }
  final endTime = DateTime.now();

  final executionTime = endTime.difference(startTime);

  final res = LiinRunResult(
    context: context,
    blocks: blocks,
    output: output,
    executionTime: executionTime,
  );

  if (clearAfter) clearVars();

  return res;
}
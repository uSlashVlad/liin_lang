import 'dart:io';
import 'vars.dart';
import 'colors.dart';
import 'code_runner.dart';

/// Model of program execution result.
/// Contains some internal information, output and execution time
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

/// Function for running some liin code
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
    final f = File(fileName);
    if (f.existsSync()) {
      final l = f.readAsLinesSync();
      startTime = DateTime.now();
      runCode(l);
    } else {
      print(error('No such file "${f.path}"'));
    }
  } else {
    print(error('No code specified!'));
  }
  final endTime = DateTime.now();

  Duration executionTime;
  if (startTime != null) executionTime = endTime.difference(startTime);

  final res = LiinRunResult(
    context: context,
    blocks: blocks,
    output: output,
    executionTime: executionTime,
  );

  if (clearAfter) clearVars();

  return res;
}

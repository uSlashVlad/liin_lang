import 'dart:io';
import 'package:path/path.dart' as p;
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
  final Map<String?, dynamic>? context;
  final Map<String?, List<int?>>? blocks;
  final List<String?>? output;
  final Duration? executionTime;
}

/// Function for running some liin code
Future<LiinRunResult> runLiin({
  List<String>? codeLines,
  String? filePath,
  List<String>? runInput,
  bool clearAfter = true,
}) async {
  if (runInput != null) input = runInput;

  DateTime? startTime;
  if (codeLines != null) {
    startTime = DateTime.now();
    await runCode(codeLines);
  } else if (filePath != null) {
    final newPath = p.joinAll(p.split(filePath)..removeLast());
    runFilePath = newPath;
    final f = File(filePath);
    if (f.existsSync()) {
      final l = f.readAsLinesSync();
      startTime = DateTime.now();
      await runCode(l);
    } else {
      print(error('No such file "${f.path}"'));
    }
  } else {
    print(error('No code specified!'));
  }
  final endTime = DateTime.now();

  Duration? executionTime;
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

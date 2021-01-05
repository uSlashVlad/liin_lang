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
  bool blockPrint = false,
  bool clearAfter = true,
}) async {
  // If input specified, insert this input
  if (runInput != null) input = runInput;

  printToTerminal = !blockPrint;

  DateTime? startTime;
  if (codeLines != null) {
    // If code lines specified, run them
    startTime = DateTime.now();
    await runCode(codeLines);
  } else if (filePath != null) {
    // If no code lines specified, but file path specified
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

  // Calculation of this run time
  late final DateTime? endTime;
  if (startTime != null) endTime = DateTime.now();
  Duration? executionTime;
  if (startTime != null) executionTime = endTime!.difference(startTime);

  // Collecting and returning this run result
  final res = LiinRunResult(
    context: context,
    blocks: blocks,
    output: output,
    executionTime: executionTime,
  );

  if (clearAfter) clearVars();

  return res;
}

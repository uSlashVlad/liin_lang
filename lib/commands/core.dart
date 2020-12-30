import 'package:expressions/expressions.dart';
import '../vars.dart';
import '../funcs.dart';
import '../code_runner.dart';

/// Function of [if] command
void commandIf(List args) {
  final bool exp = expEval(args[0]);
  final block = defineBlockEnd(cur);
  List<int> elseBlock;
  if (lines[block[1]]['command'] == 'else') {
    elseBlock = defineBlockEnd(block[1]);
  }

  if (exp) {
    runBlock(block[0], block[1], block[3]);
    if (elseBlock != null && elseBlock[2] == block[2]) {
      cur = elseBlock[1] - 1;
    }
  } else if (elseBlock != null && elseBlock[2] == block[2]) {
    runBlock(elseBlock[0], elseBlock[1], elseBlock[3]);
  }
}

/// Function of [count] command
void commandCount(List args) {
  final num = expEval(args[0]);
  final block = defineBlockEnd(cur);
  for (var i = 0; i < num; i++) {
    runBlock(block[0], block[1], block[3]);
  }
}

/// Function of [while] command
void commandWhile(List args) {
  bool exp = expEval(args[0]);
  if (exp) {
    final block = defineBlockEnd(cur);
    while (exp) {
      runBlock(block[0], block[1], block[3]);
      exp = expEval(args[0]);
    }
  }
}

/// Function of [run] command
void commandRun(List args) {
  final String name = expEval(args[0]);
  final block = blocks[name];
  final r = cur;
  runBlock(block[0], block[1], block[3]);
  cur = r;
}

/// Function of [input] command
dynamic commandInput(List args) => expEval(Expression.parse(linput()));

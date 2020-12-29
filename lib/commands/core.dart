import 'package:expressions/expressions.dart';
import '../vars.dart';
import '../funcs.dart';
import '../code_runner.dart';

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

void commandCount(List args) {
  final num = expEval(args[0]);
  final block = defineBlockEnd(cur);
  for (var i = 0; i < num; i++) {
    runBlock(block[0], block[1], block[3]);
  }
}

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

void commandRun(List args) {
  final String name = expEval(args[0]);
  final block = blocks[name];
  final r = cur;
  runBlock(block[0], block[1], block[3]);
  cur = r;
}

dynamic commandInput(List args) => expEval(Expression.parse(linput()));

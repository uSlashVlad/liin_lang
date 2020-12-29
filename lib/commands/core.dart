import 'package:expressions/expressions.dart';
import '../vars.dart';
import '../funcs.dart';
import '../code_runner.dart';

void commandIf(List args) {
  final bool exp = expEval(args[0]);
  if (exp) {
    final block = defineBlockEnd(cur);
    runBlock(block[0], block[1], block[3]);
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

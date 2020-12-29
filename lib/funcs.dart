import 'dart:io';
import 'package:expressions/expressions.dart';
import 'vars.dart';

final evaluator = const ExpressionEvaluator();

dynamic expEval(Expression exp) => evaluator.eval(exp, context);

/// 0: start, 1: end, 2: indent_original, 3: indent_new
List<int> defineBlockEnd(int start) {
  final ior = indent, sstart = start++;
  int eor = lines[start]['indentation'];

  if (ior != eor) {
    while (lines[start]['indentation'] == eor) {
      start++;
    }
  }

  return [sstart + 1, (ior != eor) ? start : sstart, ior, eor];
}

void lprint(String content) {
  output.add(content);
  print(content);
}

class _InputIterator implements Iterator<String> {
  int _curIndex = 0;

  @override
  String get current => input[_curIndex];

  @override
  bool moveNext() {
    _curIndex++;
    return (_curIndex < input.length) ? true : false;
  }
}

final _inp = _InputIterator();

String linput() {
  if (input == null) {
    return stdin.readLineSync();
  } else {
    final newInp = _inp.current;
    _inp.moveNext();
    return newInp;
  }
}

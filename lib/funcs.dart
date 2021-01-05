import 'dart:io';
import 'package:expressions/expressions.dart';
import 'package:path/path.dart' as p;
import 'vars.dart';

final _evaluator = const ExpressionEvaluator();

/// Evaluates expressions and returns it's value
dynamic expEval(Expression exp) => _evaluator.eval(exp, context);

/// 0: start, 1: end, 2: indent_original, 3: indent_new
List<int> defineBlockEnd(int start) {
  final ior = indent, sstart = start++;
  int eor = lines[start]['indentation'];

  if (ior != eor) {
    // Defines block end by checking indentation
    while (lines[start]['indentation'] >= eor) {
      start++;
    }
  }

  return [sstart + 1, (ior != eor) ? start : sstart, ior, eor];
}

/// Function that prints text to terminal and adds this text into output list
void lprint(String content) {
  output.add(content);
  if (printToTerminal) print(content);
}

/// Iterator for inserted input
class _InputIterator implements Iterator<String> {
  int _curIndex = 0;

  @override
  String get current => input![_curIndex];

  @override
  bool moveNext() {
    _curIndex++;
    return (_curIndex < input!.length) ? true : false;
  }
}

final _inp = _InputIterator();

/// Function for work with input iterator.
/// Returns a value entered in terminal or value inserted before running
String linput() {
  if (input == null) {
    return stdin.readLineSync()!;
  } else {
    final newInp = _inp.current;
    _inp.moveNext();
    return newInp;
  }
}

String getFilePath(String originalPath) => p.join(runFilePath!, originalPath);

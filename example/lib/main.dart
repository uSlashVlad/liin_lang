import 'package:liin_lang/liin_lang.dart';

void main() async {
  final r = await runLiin(codeLines: [
    '! a = 1',
    '! b = 2',
    '! result = a + b',
  ]);
  print('Executed in ${r.executionTime.inMilliseconds}ms\nAnd result is ${r.context['result']}');
}

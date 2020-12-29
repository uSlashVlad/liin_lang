import 'package:expressions/expressions.dart';
import 'enums.dart';
import 'colors.dart';
import 'funcs.dart';

// Map with regular expressions
final Map<String, RegExp> exps = {
  'command_line': RegExp(r'^\s*>\s*'),
  'definition_line': RegExp(r'^\s*(![xX]|!>|!)\s*'),
  'definition_1type_capture': RegExp(r'^\s*(![xX]|!>|!)\s*(\w+)'),
  'definition_capture': RegExp(r'(\w+)\s*(=|\+=|-=|\*=|\/=|%=|<<)\s*(.*)'),
  'comment_line': RegExp(r'\s*\..*'),
  'word': RegExp(r'\w+'),
  'whitespace': RegExp(r'\s*'),
  'guaranted_whitespace': RegExp(r'\s'),
  'quotes_expression':
      RegExp(r'^([\+\*]?\s*("(?:[^"\\]|\\.)*"|[0-9]+)\s*[\+\*]?)+'),
  'indent': RegExp(r'^\s'),
};

Map<String, dynamic> defineLine(String str) {
  // ignore: omit_local_variable_types
  final Map<String, dynamic> result = {};

  // Defining indentation level
  var indent = 0;
  while (str.startsWith(exps['indent'])) {
    indent++;
    str = str.replaceFirst(exps['indent'], '');
  }
  result['indentation'] = indent;

  if (exps['command_line'].hasMatch(str)) {
    // If this line is a command
    result['type'] = LineType.Command;
    str = str.replaceFirst(exps['command_line'], '');

    result.addAll(_defineCommand(str));
  } else if (exps['definition_line'].hasMatch(str)) {
    // If this line is a definition
    result['type'] = LineType.Definition;

    // Capturing, spliting and clearing
    DefinitionType def_type;
    final m1 = exps['definition_1type_capture'].firstMatch(str);
    str = str.replaceFirst(exps['definition_line'], '');

    if (m1[1].toLowerCase() == '!x') {
      def_type = DefinitionType.Undef;
      result['name'] = m1[2];
    } else if (m1[1] == '!>') {
      def_type = DefinitionType.Block;
      result['name'] = m1[2];
    } else {
      // Checking operators
      final m = exps['definition_capture'].firstMatch(str);
      final op = m[2];
      dynamic other = m[3];

      if (op == '=') {
        def_type = DefinitionType.Simple;
        other = Expression.parse(other);
      } else if (op == '<<') {
        def_type = DefinitionType.Command;
        other = _defineCommand(other);
      } else {
        def_type = DefinitionType.Complex;
        other = Expression.parse(other);
      }
      result.addAll({
        'name': m[1],
        'operator': m[2],
        'value': other,
      });
    }
    result['def_type'] = def_type;
  } else if (exps['comment_line'].hasMatch(str) ||
      str == exps['whitespace'].firstMatch(str)[0]) {
    result['type'] = LineType.Comment;
  } else {
    result['type'] = LineType.Empty;
    lprint(error('Error while checking line $lineNum. Skipping...'));
  }

  return result;
}

Map<String, dynamic> _defineCommand(String str) {
  // Getting name
  final name = exps['word'].firstMatch(str)[0];
  str = str.replaceFirst(name, '').replaceFirst(exps['whitespace'], '');

  // Getting arguments
  final arguments = [];
  while (str.isNotEmpty) {
    // lprint(str);

    final stringMatch = exps['quotes_expression'].firstMatch(str);
    if (stringMatch == null) {
      final mathExp = str.split(',')[0];
      // lprint(mathExp);
      arguments
          .add(Expression.parse(mathExp.replaceAll(exps['whitespace'], '')));
      str = str.replaceFirst(mathExp, '');
    } else {
      // lprint(stringMatch[0]);
      arguments.add(Expression.parse(stringMatch[0]));
      str = str.replaceFirst(stringMatch[0], '');
    }

    str = str.replaceFirst(exps['whitespace'], '');
    if (str.startsWith(',')) str = str.replaceFirst(',', '');
    str = str.replaceFirst(exps['whitespace'], '');
  }

  return {
    'command': name,
    'arguments': arguments,
  };
}

int lineNum;
List<Map<String, dynamic>> defineMultiline(List<String> strs) {
  // ignore: omit_local_variable_types
  final List<Map<String, dynamic>> result = [];

  for (lineNum = 1; lineNum <= strs.length; lineNum++) {
    try {
      result.add(defineLine(strs[lineNum - 1]));
    } catch (e) {
      lprint(error('Error while parsing line $lineNum. Skipping...\n$e'));
    }
  }

  return result;
}

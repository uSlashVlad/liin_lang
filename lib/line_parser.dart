import 'package:expressions/expressions.dart';
import 'enums.dart';
import 'colors.dart';
import 'funcs.dart';

/// Map with regular expressions
final Map<String, RegExp> _exps = {
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
  'parentheses_expression': RegExp(r'^(\s*\+?\s*\[[^\]]*\]\s*\+?\s*)+'),
  'curly_braces_expression': RegExp(r'^{[^}]*}'),
  'indent': RegExp(r'^\s'),
};

/// Parses, analyse and preprocess lines of liin code
Map<String, dynamic> defineLine(String str) {
  // ignore: omit_local_variable_types
  final Map<String, dynamic> result = {};

  // Defining indentation level
  var indent = 0;
  while (str.startsWith(_exps['indent'])) {
    indent++;
    str = str.replaceFirst(_exps['indent'], '');
  }
  result['indentation'] = indent;

  if (_exps['command_line'].hasMatch(str)) {
    // If this line is a command
    result['type'] = LineType.Command;
    str = str.replaceFirst(_exps['command_line'], '');

    result.addAll(_defineCommand(str));
  } else if (_exps['definition_line'].hasMatch(str)) {
    // If this line is a definition
    result['type'] = LineType.Definition;

    // Capturing, spliting and clearing
    DefinitionType def_type;
    final m1 = _exps['definition_1type_capture'].firstMatch(str);
    str = str.replaceFirst(_exps['definition_line'], '');

    if (m1[1].toLowerCase() == '!x') {
      def_type = DefinitionType.Undef;
      result['name'] = m1[2];
    } else if (m1[1] == '!>') {
      def_type = DefinitionType.Block;
      result['name'] = m1[2];
    } else {
      // Checking operators
      final m = _exps['definition_capture'].firstMatch(str);
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
  } else if (_exps['comment_line'].hasMatch(str) ||
      str == _exps['whitespace'].firstMatch(str)[0]) {
    result['type'] = LineType.Comment;
  } else {
    result['type'] = LineType.Empty;
    lprint(error('Error while checking line $_lineNum. Skipping...'));
  }

  return result;
}

Map<String, dynamic> _defineCommand(String str) {
  // Getting name
  final name = _exps['word'].firstMatch(str)[0];
  str = str.replaceFirst(name, '').replaceFirst(_exps['whitespace'], '');

  // Getting arguments
  final arguments = [];
  while (str.isNotEmpty) {
    // lprint(str);
    // Searching for String expressions
    final stringMatch = _exps['quotes_expression'].firstMatch(str);
    if (stringMatch == null) {
      // Searching for collections expressions
      var bracketsMatch = _exps['parentheses_expression'].firstMatch(str);
      bracketsMatch ??= _exps['curly_braces_expression'].firstMatch(str);
      if (bracketsMatch == null) {
        // If it is normal math expression
        final mathExp = str.split(',')[0];
        // lprint(mathExp);
        arguments.add(Expression.parse(mathExp));
        str = str.replaceFirst(mathExp, '');
      } else {
        // lprint(bracketsMatch[0]);
        arguments.add(Expression.parse(bracketsMatch[0]));
        str = str.replaceFirst(bracketsMatch[0], '');
      }
    } else {
      // lprint(stringMatch[0]);
      arguments.add(Expression.parse(stringMatch[0]));
      str = str.replaceFirst(stringMatch[0], '');
    }

    str = str.replaceFirst(_exps['whitespace'], '');
    if (str.startsWith(',')) str = str.replaceFirst(',', '');
    str = str.replaceFirst(_exps['whitespace'], '');
  }

  return {
    'command': name,
    'arguments': arguments,
  };
}

int _lineNum;

/// Similar to defineLine, but defines multiple lines
List<Map<String, dynamic>> defineMultiline(List<String> strs) {
  // ignore: omit_local_variable_types
  final List<Map<String, dynamic>> result = [];

  for (_lineNum = 1; _lineNum <= strs.length; _lineNum++) {
    try {
      result.add(defineLine(strs[_lineNum - 1]));
    } catch (e) {
      lprint(error('Error while parsing line $_lineNum. Skipping...\n$e'));
    }
  }

  return result;
}

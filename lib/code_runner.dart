import 'enums.dart';
import 'vars.dart';
import 'funcs.dart';
import 'line_parser.dart';
import 'colors.dart';

void runCode(List<String> strs) {
  strs.add('');
  lines = defineMultiline(strs);
  runBlock(0, lines.length, 0);
}

void clearVars() {
  context = {};
  blocks = {};
  lines = null;
  input = null;
  output = [];
  cur = 0;
  indent = 0;
}

void runBlock(int start, int end, int newIndent) {
  final oldIndent = indent;
  indent = newIndent;

  for (cur = start; cur < end; cur++) {
    try {
      final ln = lines[cur];
      // lprint(ln);
      if (ln['indentation'] == indent) {
        // Process line
        if (ln['type'] == LineType.Command) {
          commands[ln['command']](ln['arguments']);
        } else if (ln['type'] == LineType.Definition) {
          final DefinitionType defType = ln['def_type'];
          final name = ln['name'];
          if (defType == DefinitionType.Simple) {
            // Just a simple definition
            updateVariable(name, expEval(ln['value']));
          } else if (defType == DefinitionType.Complex) {
            // Complex definition (with math operator)
            final String op = ln['operator'];
            var curVal = context[name];
            var newVal = expEval(ln['value']);
            // Checking operators
            if (op == '+=') {
              curVal += newVal;
            } else if (op == '-=') {
              curVal -= newVal;
            } else if (op == '*=') {
              curVal *= newVal;
            } else if (op == '/=') {
              curVal /= newVal;
            } else if (op == '%=') {
              curVal %= newVal;
            }
            updateVariable(name, curVal);
          } else if (defType == DefinitionType.Command) {
            // Command definition
            // Calling command and putting value of it in context
            updateVariable(name,
                commands[ln['value']['command']](ln['value']['arguments']));
          } else if (defType == DefinitionType.Undef) {
            // Undef
            context.remove(name);
          } else {
            // Block definition
            blocks[name] = defineBlockEnd(cur);
          }
        }
      }
    } catch (e) {
      lprint(error('Error while execution line ${cur + 1}. Skipping...\n$e'));
    }
  }

  indent = oldIndent;
  cur--;
}

void updateVariable(String name, dynamic value) => context[name] = value;

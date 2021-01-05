import 'enums.dart';
import 'vars.dart';
import 'funcs.dart';
import 'line_parser.dart';
import 'colors.dart';

/// Runs specified lines of code.
/// It includes parsing, analysis, preprocessing and execution
Future<void> runCode(List<String> strs) async {
  strs.add('');
  lines = await defineMultiline(strs);
  // print(lines);
  runBlock(0, lines.length, 0);
}

/// Clears all vars that can be used while code runing
void clearVars() {
  context = {};
  blocks = {};
  lines = [];
  input = null;
  output = [];
  cur = 0;
  indent = 0;
  runFilePath = null;
  printToTerminal = true;
}

/// Runs some specific block of code
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
          commands[ln['command']]!(ln['arguments']);
        } else if (ln['type'] == LineType.Definition) {
          final DefinitionType? defType = ln['def_type'];
          final name = ln['name'];
          if (defType == DefinitionType.Simple) {
            // Just a simple definition
            _updateVariable(name, expEval(ln['value']));
          } else if (defType == DefinitionType.Complex) {
            // Complex definition (with math operator)
            final String? op = ln['operator'];
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
            _updateVariable(name, curVal);
          } else if (defType == DefinitionType.Command) {
            // Command definition
            // Calling command and putting value of it in context
            _updateVariable(name,
                commands[ln['value']['command']]!(ln['value']['arguments']));
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
      print(error('Error while execution line ${cur + 1}. Skipping...\n$e'));
    }
  }

  indent = oldIndent;
  cur--;
}

void _updateVariable(String name, dynamic value) => context[name] = value;

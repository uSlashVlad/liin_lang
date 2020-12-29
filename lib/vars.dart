import 'commands/core.dart';
import 'commands/base.dart';

Map<String, dynamic> context = {};

final Map<String, Function> commands = {
  'if': commandIf,
  'count': commandCount,
  'while': commandWhile,
  'run': commandRun,
  'print': commandPrint,
  'liin': commandLiin,
  'show_context': commandShowContext,
  'input': commandInput,
};

Map<String, List<int>> blocks = {};

List<Map<String, dynamic>> lines;

List<String> input;
List<String> output = [];

int cur = 0;
int indent = 0;

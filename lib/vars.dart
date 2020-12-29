import 'commands/core.dart';
import 'commands/base.dart';
import 'commands/files.dart';

Map<String, dynamic> context = {};

final Map<String, Function> commands = {
  // Core commands
  'if': commandIf,
  'count': commandCount,
  'while': commandWhile,
  'run': commandRun,
  'input': commandInput,
  // Base commands
  'print': commandPrint,
  'liin': commandLiin,
  'show_context': commandShowContext,
  'concat': commandConcat,
  // Files commands
  'file': commandFile,
  'file_create': commandFileCreate,
  'file_copy': commandFileCopy,
  'file_write': commandFileWriteString,
  'file_writeb': commandFileWriteBytes,
  'file_read': commandFileReadString,
  'file_readb': commandFileReadBytes,
  'file_append': commandFileAppend,
  'file_exists': commandFileExists,
  'file_remove': commandFileRemove,
};

Map<String, List<int>> blocks = {};

List<Map<String, dynamic>> lines;

List<String> input;
List<String> output = [];

int cur = 0;
int indent = 0;

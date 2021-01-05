import 'commands/core.dart';
import 'commands/base.dart';
import 'commands/files.dart';
import 'commands/strings.dart';
import 'commands/collections.dart';
import 'commands/types.dart';

/// Context for expression parsing
Map<String, dynamic> context = {};

/// List of commands that available for calling
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
  // Strings commands
  'str': commandConcat,
  'str_slice': commandSlice,
  'str_length': commandLength,
  'str_color_rgb': commandColorRGB,
  'str_color': commandColorCode,
  'str_replace_first': commandReplaceFirst,
  'str_replace_all': commandReplaceAll,
  'str_contains': commandContains,
  'str_low': commandToLowerCase,
  'str_up': commandToUpperCase,
  // Collections commands
  'cl_remove': commandRemove,
  'cl_is_empty': commandIsEmpty,
  'cl_length': commandCollectionLength,
  'cl_place': commandPlace,
  'cl_join': commandJoin,
  // Types commands
  'type_is_string': commandIsString,
  'type_is_num': commandIsNum,
  'type_is_int': commandIsInt,
  'type_is_bool': commandIsBool,
  'type_is_cl': commandIsCollection,
  'type_is_list': commandIsList,
  'type_is_map': commandIsMap,
  'type_is_file': commandIsFile,
  'type_str': commandType,
};

/// Map that can contain blocks informations, like start, end and inforamtion
/// about indentation
Map<String, List<int>> blocks = {};

/// Contains lines of code. Has values after running code
late List<Map<String, dynamic>> lines;

/// List of input. Has values if they were specified before code running
List<String>? input;

/// List of all outputs of lprint
List<String> output = [];

/// Current line
int cur = 0;

/// Current indentation
int indent = 0;

/// Path to current file
String? runFilePath;

/// If it is true, lprint won't print anything to terminal
bool printToTerminal = true;

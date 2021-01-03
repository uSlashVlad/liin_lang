import 'dart:io';
import '../funcs.dart';

/// Function of [type_is_string] command
bool commandIsString(List args) => expEval(args[0]) is String;

/// Function of [type_is_num] command
bool commandIsNum(List args) => expEval(args[0]) is num;

/// Function of [type_is_int] command
bool commandIsInt(List args) => expEval(args[0]) is int;

/// Function of [type_is_bool] command
bool commandIsBool(List args) => expEval(args[0]) is bool;

/// Function of [type_is_cl] command
bool commandIsCollection(List args) {
  final a = expEval(args[0]);
  return (a is List) || (a is Map);
}

/// Function of [type_is_list] command
bool commandIsList(List args) => expEval(args[0]) is List;

/// Function of [type_is_map] command
bool commandIsMap(List args) => expEval(args[0]) is Map;

/// Function of [type_is_file] command
bool commandIsFile(List args) => expEval(args[0]) is File;

String commandType(List args) => '${expEval(args[0]).runtimeType}';

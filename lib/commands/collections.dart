import '../funcs.dart';
import '../colors.dart';

/// Function of [cl_remove] command
void commandRemove(List args) {
  final collection = expEval(args[0]);
  final index = expEval(args[1]);
  if (collection is List) {
    collection.removeAt(index);
  } else if (collection is Map) {
    collection.remove(index);
  } else {
    lprint(error('"cl_remove" can be used only with collections'));
  }
}

/// Function of [cl_is_empty] command
bool? commandIsEmpty(List args) => expEval(args[0]).isEmpty;

/// Function of [cl_lenght] command
int? commandCollectionLength(List args) => expEval(args[0]).length;

/// Function of [cl_place] command
dynamic commandPlace(List args) {
  final collection = expEval(args[0]);
  final value = expEval(args[2]);
  final index = expEval(args[1]);
  collection[index] = value;
  return collection;
}

/// Function of [cl_join] command
String commandJoin(List args) {
  final List collection = expEval(args[0]);
  final separator = expEval(args[1]);
  return collection.join(separator);
}

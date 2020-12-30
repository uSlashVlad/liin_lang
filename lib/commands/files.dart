import 'dart:io';
import '../funcs.dart';

/// Function of [file] command
File commandFile(List args) {
  String name = expEval(args[0]);
  return File(name);
}

/// Function of [file_create] command
void commandFileCreate(List args) {
  File file = expEval(args[0]);
  file.createSync(recursive: true);
}

/// Function of [file_copy] command
File commandFileCopy(List args) {
  File f1 = expEval(args[0]);
  String path = expEval(args[1]);
  return f1.copySync(path);
}

/// Function of [file_write] command
void commandFileWriteString(List args) {
  File file = expEval(args[0]);
  dynamic content = expEval(args[1]);
  file.writeAsStringSync(content.toString());
}

/// Function of [file_writeb] command
void commandFileWriteBytes(List args) {
  File file = expEval(args[0]);
  List<int> content = expEval(args[1]);
  file.writeAsBytesSync(content);
}

/// Function of [file_read] command
String commandFileReadString(List args) {
  File file = expEval(args[0]);
  return file.readAsStringSync();
}

/// Function of [file_readb] command
List<int> commandFileReadBytes(List args) {
  File file = expEval(args[0]);
  return file.readAsBytesSync();
}

/// Function of [file_append] command
void commandFileAppend(List args) {
  File file = expEval(args[0]);
  dynamic content = expEval(args[1]);
  file.writeAsStringSync(content.toString(), mode: FileMode.append);
}

/// Function of [file_exists] command
bool commandFileExists(List args) {
  File file = expEval(args[0]);
  return file.existsSync();
}

/// Function of [file_remove] command
void commandFileRemove(List args) {
  File file = expEval(args[0]);
  file.deleteSync();
}

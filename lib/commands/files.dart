import 'dart:io';
import '../funcs.dart';

File commandFile(List args) {
  String name = expEval(args[0]);
  return File(name);
}

void commandFileCreate(List args) {
  File file = expEval(args[0]);
  file.createSync(recursive: true);
}

File commandFileCopy(List args) {
  File f1 = expEval(args[0]);
  String path = expEval(args[1]);
  return f1.copySync(path);
}

void commandFileWriteString(List args) {
  File file = expEval(args[0]);
  dynamic content = expEval(args[1]);
  file.writeAsStringSync(content.toString());
}

void commandFileWriteBytes(List args) {
  File file = expEval(args[0]);
  List<int> content = expEval(args[1]);
  file.writeAsBytesSync(content);
}

String commandFileReadString(List args) {
  File file = expEval(args[0]);
  return file.readAsStringSync();
}

List<int> commandFileReadBytes(List args) {
  File file = expEval(args[0]);
  return file.readAsBytesSync();
}

void commandFileAppend(List args) {
  File file = expEval(args[0]);
  dynamic content = expEval(args[1]);
  file.writeAsStringSync(content.toString(), mode: FileMode.append);
}

bool commandFileExists(List args) {
  File file = expEval(args[0]);
  return file.existsSync();
}

void commandFileRemove(List args) {
  File file = expEval(args[0]);
  file.deleteSync();
}

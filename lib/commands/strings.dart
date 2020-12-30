import '../funcs.dart';
import '../colors.dart';

/// Function of [concat] command
String commandConcat(List args) {
  args = args.map((arg) => expEval(arg)).toList();
  return args.join();
}

/// Function of [str_slice] command
String commandSlice(List args) {
  final String str = expEval(args[0]);
  final int start = expEval(args[1]);
  var end = str.length;
  if (args.length > 2) {
    end = expEval(args[2]);
  }
  return str.substring(start, end);
}

/// Function of [str_length] command
int commandLength(List args) {
  final String str = expEval(args[0]);
  return str.length;
}

/// Function of [str_color_rgb] command
String commandColorRGB(List args) {
  final String str = expEval(args[0]);
  final num red = expEval(args[1]),
      green = expEval(args[2]),
      blue = expEval(args[3]);
  var bg = false;
  if (args.length > 4) bg = expEval(args[4]);

  final pen = rgbPen(red, green, blue, bg);

  return pen(str);
}

/// Function of [str_color] command
String commandColorCode(List args) {
  final String str = expEval(args[0]);
  final num code = expEval(args[1]);
  var bg = false;
  if (args.length > 2) bg = expEval(args[2]);

  final pen = xtermPen(code, bg);

  return pen(str);
}

/// Function of [str_replace_first] command
String commandReplaceFirst(List args) {
  final String str = expEval(args[0]),
      pattern1 = expEval(args[1]),
      pattern2 = expEval(args[2]);
  return str.replaceFirst(pattern1, pattern2);
}

/// Function of [str_replace_all] command
String commandReplaceAll(List args) {
  final String str = expEval(args[0]),
      pattern1 = expEval(args[1]),
      pattern2 = expEval(args[2]);
  return str.replaceAll(pattern1, pattern2);
}

/// Function of [str_contains] command
bool commandContains(List args) {
  final String str = expEval(args[0]), pattern = expEval(args[1]);
  return str.contains(pattern);
}

/// Function of [str_low] command
String commandToLowerCase(List args) {
  final String str = expEval(args[0]);
  return str.toLowerCase();
}

/// Function of [str_up] command
String commandToUpperCase(List args) {
  final String str = expEval(args[0]);
  return str.toUpperCase();
}

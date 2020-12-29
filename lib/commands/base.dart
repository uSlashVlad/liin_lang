import '../funcs.dart';
import '../vars.dart';
import '../colors.dart';

void commandPrint(List args) {
  args = args.map((arg) => expEval(arg)).toList();
  lprint(args.join(' '));
}

const _liin = [
  '▄▄▄     ▇▇  ▇▇  ██▄',
  ' ▀██    ▃▃  ▃▃  ████▄',
  '  ████████████████████',
  '  ▆▆    ▆▆  ▆▆  ▆▆  ▆▆',
  '  ▀██▄  ██  ██  ██  ██',
];

void commandLiin(List args) {
  var iter = RainbowIterator(196, 6);
  for (var i = 0; i < 5; i++) {
    iter.moveNext();
    lprint(iter.current(_liin[i]));
  }

  lprint('\n${purple('.!')} ${yellow('version')} = ${green('"0.1.0 alpha"')}');
  lprint('${purple('.!')} ${yellow('author')} = ${green('"u/vlad"')}');
}

void commandShowContext(List args) {
  print(comment('Vars: $context\nBlocks: $blocks'));
}

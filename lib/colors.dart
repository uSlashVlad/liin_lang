import 'package:ansicolor/ansicolor.dart';

final error = AnsiPen()..xterm(1);
final comment = AnsiPen()..gray(level: 0.4);

final pink = AnsiPen()..xterm(198);
final purple = AnsiPen()..xterm(129);
final yellow = AnsiPen()..yellow(bold: true);
final green = AnsiPen()..green(bold: true);

class RainbowIterator implements Iterator<AnsiPen> {
  RainbowIterator(this.start, this.step, [this.max]);
  final int start, max;
  int step;

  AnsiPen _currentPen;
  int _curIndex = -1;

  @override
  AnsiPen get current => _currentPen;

  @override
  bool moveNext() {
    if (_curIndex == -1) _curIndex = start;

    _currentPen = AnsiPen()..xterm(_curIndex);
    _curIndex += step;

    if (max != null && (_curIndex >= max || _curIndex <= start)) {
      step = -step;
    }

    return (_curIndex < 256) ? true : false;
  }
}

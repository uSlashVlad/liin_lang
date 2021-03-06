import 'package:ansicolor/ansicolor.dart';

/// Pen for errors
final error = xtermPen(1);

/// Pen for additional information
final comment = AnsiPen()..gray(level: 0.4);

// Some pens with some diffirent colors
final pink = xtermPen(198);
final purple = xtermPen(129);
final yellow = AnsiPen()..yellow(bold: true);
final green = AnsiPen()..green(bold: true);

/// Iterator for rainbow text :)
class RainbowIterator implements Iterator<AnsiPen?> {
  RainbowIterator(this.start, this.step, [this.max]);
  final int start;
  final int? max;
  int step;

  late AnsiPen _currentPen;
  int _curIndex = -1;

  // Gets new color and returns it if exists
  @override
  AnsiPen? get current {
    if (moveNext()) {
      return _currentPen;
    } else {
      return null;
    }
  }

  // Tries to get next xterm color
  @override
  bool moveNext() {
    if (_curIndex == -1) _curIndex = start;

    _currentPen = xtermPen(_curIndex);
    _curIndex += step;

    if (max != null && (_curIndex >= max! || _curIndex <= start)) {
      step = -step;
    }

    return (_curIndex < 256) ? true : false;
  }
}

/// Method for creating ansipen with color from rgb
AnsiPen rgbPen(double r, double g, double b, bool bg) =>
    AnsiPen()..rgb(r: r, g: g, b: b, bg: bg);

/// Method for creating ansipen with color from xterm
AnsiPen xtermPen(int code, [bool bg = false]) => AnsiPen()..xterm(code, bg: bg);

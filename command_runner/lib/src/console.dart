// Version: 0.0.0

enum ConsoleColor {
  reset('\x1B[0m'),
  red('\x1B[31m'),
  green('\x1B[32m'),
  yellow('\x1B[33m'),
  blue('\x1B[34m'),
  magenta('\x1B[35m'),
  cyan('\x1B[36m'),
  white('\x1B[37m');

  final String ansiCode;

  const ConsoleColor(this.ansiCode);

  String apply(String text) => '$ansiCode$text${ConsoleColor.reset.ansiCode}';
}

extension ConsoleColorString on String {
  String withColor(ConsoleColor color) => color.apply(this);

  String get bold => '\x1B[1m$this${ConsoleColor.reset.ansiCode}';
  String get red => withColor(ConsoleColor.red);
  String get green => withColor(ConsoleColor.green);
  String get yellow => withColor(ConsoleColor.yellow);
  String get blue => withColor(ConsoleColor.blue);
  String get cyan => withColor(ConsoleColor.cyan);
}

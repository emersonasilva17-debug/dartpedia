// Version: 0.0.1

enum OptionType {
  flag,
  option,
}

enum CommandStatus {
  success,
  failure,
  invalidArguments,
}

class Argument {
  final String name;
  final String? abbr;
  final String help;
  final OptionType type;
  final String? defaultValue;

  const Argument({
    required this.name,
    this.abbr,
    this.help = '',
    this.type = OptionType.option,
    this.defaultValue,
  });

  String get usage {
    final buffer = StringBuffer();
    if (abbr != null) {
      buffer.write('-$abbr, ');
    }
    buffer.write('--$name');
    if (help.isNotEmpty) {
      buffer.write('\t$help');
    }
    if (defaultValue != null) {
      buffer.write(' (padrão: $defaultValue)');
    }
    return buffer.toString();
  }
}

class ArgResults {
  final List<String> rest;
  final Map<String, dynamic> options;

  const ArgResults({
    this.rest = const [],
    this.options = const {},
  });
}

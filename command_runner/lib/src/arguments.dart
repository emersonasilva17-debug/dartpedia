// Version: 0.0.0

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

  const Argument({
    required this.name,
    this.abbr,
    this.help = '',
    this.type = OptionType.option,
  });
}

class ArgResults {
  final List<String> rest;
  final Map<String, dynamic> options;

  const ArgResults({
    this.rest = const [],
    this.options = const {},
  });
}

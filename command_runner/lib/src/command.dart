// Version: 0.0.1
import 'dart:async';
import 'arguments.dart';

abstract class Command {
  String get name;
  String get description;
  String get usage => 'dart run bin/dartpedia.dart $name';

  List<Argument> get options => const [];

  String get detailedUsage {
    final buffer = StringBuffer()
      ..writeln('Comando: $name')
      ..writeln('Descrição: $description')
      ..writeln('Uso: $usage');

    if (options.isNotEmpty) {
      buffer.writeln('Opções:');
      for (final opt in options) {
        buffer.writeln('  ${opt.usage}');
      }
    }
    return buffer.toString();
  }

  FutureOr<CommandStatus> run(ArgResults results);
}

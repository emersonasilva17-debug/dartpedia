// Version: 0.0.1
import '../arguments.dart';
import '../command.dart';

typedef OutputCallback = void Function(String message);

class HelpCommand extends Command {
  final Map<String, Command> _commands;
  final OutputCallback onOutput;

  HelpCommand(
    this._commands, {
    OutputCallback? onOutput,
  }) : onOutput = onOutput ?? print;

  @override
  String get name => 'help';

  @override
  String get description => 'Exibe informações detalhadas de ajuda sobre os comandos.';

  @override
  String get usage => 'dart run bin/dartpedia.dart help [comando]';

  @override
  CommandStatus run(ArgResults results) {
    final buffer = StringBuffer();

    if (results.rest.isNotEmpty) {
      final targetName = results.rest.first;
      final targetCommand = _commands[targetName];

      if (targetCommand != null) {
        buffer.write(targetCommand.detailedUsage);
        onOutput(buffer.toString().trimRight());
        return CommandStatus.success;
      } else {
        buffer.writeln('Comando "$targetName" não encontrado.\n');
      }
    }

    buffer
      ..writeln('Uso: dart run bin/dartpedia.dart <comando> [argumentos]')
      ..writeln('\nComandos disponíveis:');

    _commands.forEach((cmdName, cmd) {
      buffer.writeln('  ${cmdName.padRight(18)} ${cmd.description}');
    });

    buffer.write('\nUse "help <comando>" para ver detalhes de um comando específico.');
    onOutput(buffer.toString());
    return CommandStatus.success;
  }
}

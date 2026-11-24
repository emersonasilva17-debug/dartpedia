// Version: 0.0.0
import '../arguments.dart';
import '../command.dart';

class HelpCommand extends Command {
  final Map<String, Command> _commands;

  HelpCommand(this._commands);

  @override
  String get name => 'help';

  @override
  String get description => 'Exibe esta mensagem de ajuda com todos os comandos.';

  @override
  CommandStatus run(ArgResults results) {
    print('Uso: dart run bin/dartpedia.dart <comando> [argumentos]');
    print('Comandos disponíveis:');
    _commands.forEach((cmdName, cmd) {
      print('  ${cmdName.padRight(18)} ${cmd.description}');
    });
    return CommandStatus.success;
  }
}

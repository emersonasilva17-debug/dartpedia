// Version: 0.0.2
import 'dart:async';
import 'arguments.dart';
import 'command.dart';
import 'commands/help_command.dart';

class CommandRunner {
  final Map<String, Command> _commands = {};
  final OutputCallback onOutput;

  CommandRunner({OutputCallback? onOutput}) : onOutput = onOutput ?? print {
    registerCommand(HelpCommand(_commands, onOutput: this.onOutput));
  }

  void registerCommand(Command command) {
    _commands[command.name] = command;
  }

  Future<CommandStatus> run(List<String> rawArguments) async {
    if (rawArguments.isEmpty) {
      return _commands['help']!.run(const ArgResults());
    }

    final commandName = rawArguments.first;
    final restArgs = rawArguments.length > 1 ? rawArguments.sublist(1) : <String>[];
    final command = _commands[commandName];

    if (command == null) {
      onOutput('Comando desconhecido: "$commandName"\n');
      _commands['help']!.run(const ArgResults());
      return CommandStatus.invalidArguments;
    }

    return await command.run(ArgResults(rest: restArgs));
  }
}

// Version: 0.0.4
import 'dart:async';
import 'arguments.dart';
import 'command.dart';
import 'commands/help_command.dart';
import 'console.dart';
import 'exceptions.dart';

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
    try {
      if (rawArguments.isEmpty) {
        return await _commands['help']!.run(const ArgResults());
      }

      final commandName = rawArguments.first;
      final restArgs =
          rawArguments.length > 1 ? rawArguments.sublist(1) : <String>[];
      final command = _commands[commandName];

      if (command == null) {
        throw ArgumentException(
          'Comando desconhecido.',
          argument: commandName,
        );
      }

      return await command.run(ArgResults(rest: restArgs));
    } on ArgumentException catch (e) {
      onOutput('${e.toString()}\n'.red);
      await _commands['help']!.run(const ArgResults());
      return CommandStatus.invalidArguments;
    } on CommandExecutionException catch (e) {
      onOutput('Falha na execução: ${e.message}'.red);
      return CommandStatus.failure;
    } catch (e) {
      onOutput('Erro inesperado no aplicativo: $e'.red);
      return CommandStatus.failure;
    }
  }
}

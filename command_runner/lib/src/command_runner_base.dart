// Version: 0.0.0
import 'dart:async';

typedef CommandCallback = FutureOr<void> Function(List<String> arguments);

class CommandRunner {
  final Map<String, CommandCallback> _commands = {};
  final Map<String, String> _descriptions = {};

  void registerCommand(
    String name,
    CommandCallback callback, {
    String description = '',
  }) {
    _commands[name] = callback;
    _descriptions[name] = description;
  }

  Future<void> run(List<String> arguments) async {
    if (arguments.isEmpty || arguments.first == 'help') {
      printUsage();
      return;
    }

    final commandName = arguments.first;
    final commandArgs = arguments.length > 1 ? arguments.sublist(1) : <String>[];

    final callback = _commands[commandName];
    if (callback != null) {
      await callback(commandArgs);
    } else {
      print('Comando desconhecido: "$commandName"\n');
      printUsage();
    }
  }

  void printUsage() {
    print('Uso: dart run bin/dartpedia.dart <comando> [argumentos]');
    print('Comandos disponíveis:');
    print('  help               Exibe esta mensagem de ajuda');
    _descriptions.forEach((name, desc) {
      print('  ${name.padRight(18)} $desc');
    });
  }
}

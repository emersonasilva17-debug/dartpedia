import 'dart:io';
import 'package:command_runner/command_runner.dart';
import 'package:dartpedia/wikipedia.dart';

const version = '0.0.4';

class VersionCommand extends Command {
  @override
  String get name => 'version';

  @override
  String get description => 'Exibe a versão atual da aplicação ($version).';

  @override
  CommandStatus run(ArgResults results) {
    print('Dartpedia CLI version $version');
    return CommandStatus.success;
  }
}

class SearchCommand extends Command {
  @override
  String get name => 'search';

  @override
  String get description => 'Busca o resumo de um artigo na Wikipédia.';

  @override
  String get usage => 'dart run bin/dartpedia.dart search <artigo>';

  @override
  Future<CommandStatus> run(ArgResults results) async {
    late String articleTitle;

    if (results.rest.isEmpty) {
      stdout.write('Digite o título do artigo para buscar: ');
      final inputFromStdin = stdin.readLineSync();
      if (inputFromStdin == null || inputFromStdin.isEmpty) {
        print('Nenhum título informado. Encerrando.');
        return CommandStatus.invalidArguments;
      }
      articleTitle = inputFromStdin;
    } else {
      articleTitle = results.rest.join('_');
    }

    print('Buscando "$articleTitle" na Wikipédia...\n');
    try {
      final summary = await getWikipediaArticle(articleTitle);
      print('=== $articleTitle ===');
      print(summary);
      return CommandStatus.success;
    } catch (e) {
      print('Erro na requisição: $e');
      return CommandStatus.failure;
    }
  }
}

void main(List<String> arguments) async {
  final runner = CommandRunner()
    ..registerCommand(VersionCommand())
    ..registerCommand(SearchCommand());

  await runner.run(arguments);
}

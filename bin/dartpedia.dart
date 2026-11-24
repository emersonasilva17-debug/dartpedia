import 'dart:io';
import 'package:command_runner/command_runner.dart';
import 'package:dartpedia/wikipedia.dart';

const version = '0.0.5';

class VersionCommand extends Command {
  final OutputCallback onOutput;

  VersionCommand({OutputCallback? onOutput}) : onOutput = onOutput ?? print;

  @override
  String get name => 'version';

  @override
  String get description => 'Exibe a versão atual da aplicação ($version).';

  @override
  CommandStatus run(ArgResults results) {
    onOutput('Dartpedia CLI version $version');
    return CommandStatus.success;
  }
}

class SearchCommand extends Command {
  final OutputCallback onOutput;

  SearchCommand({OutputCallback? onOutput}) : onOutput = onOutput ?? print;

  @override
  String get name => 'search';

  @override
  String get description => 'Busca o resumo de um artigo na Wikipédia.';

  @override
  String get usage => 'dart run bin/dartpedia.dart search <artigo>';

  @override
  List<Argument> get options => const [
        Argument(
          name: 'lang',
          abbr: 'l',
          help: 'Idioma da Wikipédia (padrão: en)',
          defaultValue: 'en',
        ),
      ];

  @override
  Future<CommandStatus> run(ArgResults results) async {
    late String articleTitle;

    if (results.rest.isEmpty) {
      stdout.write('Digite o título do artigo para buscar: ');
      final inputFromStdin = stdin.readLineSync();
      if (inputFromStdin == null || inputFromStdin.isEmpty) {
        onOutput('Nenhum título informado. Encerrando.');
        return CommandStatus.invalidArguments;
      }
      articleTitle = inputFromStdin;
    } else {
      articleTitle = results.rest.join('_');
    }

    onOutput('Buscando "$articleTitle" na Wikipédia...\n');
    try {
      final summary = await getWikipediaArticle(articleTitle);
      final outputBuffer = StringBuffer()
        ..writeln('=== $articleTitle ===')
        ..write(summary);
      onOutput(outputBuffer.toString());
      return CommandStatus.success;
    } catch (e) {
      onOutput('Erro na requisição: $e');
      return CommandStatus.failure;
    }
  }
}

void main(List<String> arguments) async {
  final runner = CommandRunner(onOutput: print)
    ..registerCommand(VersionCommand(onOutput: print))
    ..registerCommand(SearchCommand(onOutput: print));

  await runner.run(arguments);
}

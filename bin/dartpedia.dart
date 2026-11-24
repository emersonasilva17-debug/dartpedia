import 'dart:io';
import 'package:command_runner/command_runner.dart';
import 'package:dartpedia/logger.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart';

const version = '0.1.0';

class VersionCommand extends Command {
  final OutputCallback onOutput;
  final Logger logger;

  VersionCommand({
    required this.logger,
    OutputCallback? onOutput,
  }) : onOutput = onOutput ?? print;

  @override
  String get name => 'version';

  @override
  String get description => 'Exibe a versão atual da aplicação ($version).';

  @override
  CommandStatus run(ArgResults results) {
    logger.info('Comando "version" executado. Versão atual: $version');
    onOutput('Dartpedia CLI version '.cyan + version.bold.green);
    return CommandStatus.success;
  }
}

class SearchCommand extends Command {
  final OutputCallback onOutput;
  final Logger logger;

  SearchCommand({
    required this.logger,
    OutputCallback? onOutput,
  }) : onOutput = onOutput ?? print;

  @override
  String get name => 'search';

  @override
  String get description => 'Busca artigos e resumos na Wikipédia via WikipediaApiClient.';

  @override
  String get usage => 'dart run bin/dartpedia.dart search <termo>';

  @override
  List<Argument> get options => const [
        Argument(
          name: 'lang',
          abbr: 'l',
          help: 'Idioma da Wikipédia (ex: en, pt)',
          defaultValue: 'en',
        ),
      ];

  @override
  Future<CommandStatus> run(ArgResults results) async {
    late String query;

    if (results.rest.isEmpty) {
      stdout.write('Digite o termo para pesquisar na Wikipédia: '.yellow);
      final inputFromStdin = stdin.readLineSync();
      if (inputFromStdin == null || inputFromStdin.isEmpty) {
        logger.warning('Pesquisa cancelada: nenhum termo informado.');
        throw const ArgumentException(
          'Nenhum termo de pesquisa foi informado.',
          command: 'search',
        );
      }
      query = inputFromStdin;
    } else {
      query = results.rest.join(' ');
    }

    final client = WikipediaApiClient(language: 'en');
    logger.info('Consultando WikipediaApiClient para: "$query"');
    onOutput('Consultando API da Wikipédia para "${query.bold}"...\n'.cyan);

    try {
      final searchResults = await client.searchArticles(query, limit: 3);
      if (searchResults.results.isEmpty) {
        onOutput('Nenhum artigo encontrado para "$query".'.yellow);
        return CommandStatus.success;
      }

      final topTitle = searchResults.results.first.title;
      final summary = await client.getArticleSummary(topTitle);

      final outputBuffer = StringBuffer()
        ..writeln('=== ${summary.title} (ID: ${summary.pageId}) ==='.bold.green);
      if (summary.description != null) {
        outputBuffer.writeln('Descrição: ${summary.description}'.yellow);
      }
      outputBuffer
        ..writeln(summary.extract)
        ..writeln('\nArtigos relacionados encontrados:'.bold.cyan);

      for (final item in searchResults.results) {
        outputBuffer.writeln(' • ${item.title} (ID: ${item.pageId})');
      }

      onOutput(outputBuffer.toString());
      logger.info('Consulta finalizada com sucesso para "${summary.title}".');
      return CommandStatus.success;
    } catch (e, stackTrace) {
      logger.severe('Erro na consulta à API da Wikipédia', e, stackTrace);
      throw CommandExecutionException(
        'Não foi possível obter os dados da Wikipédia para "$query".',
        cause: e,
      );
    } finally {
      client.close();
    }
  }
}

void main(List<String> arguments) async {
  final logger = initFileLogger('DartpediaCLI');
  logger.info('Aplicação iniciada com argumentos: $arguments');

  final runner = CommandRunner(onOutput: print)
    ..registerCommand(VersionCommand(logger: logger, onOutput: print))
    ..registerCommand(SearchCommand(logger: logger, onOutput: print));

  final status = await runner.run(arguments);
  logger.info('Execução finalizada com status: ${status.name}');
}

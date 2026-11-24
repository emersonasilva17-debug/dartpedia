import 'dart:io';
import 'package:command_runner/command_runner.dart';
import 'package:dartpedia/logger.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart';

const version = '0.0.9';

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
      stdout.write('Digite o título do artigo para buscar: '.yellow);
      final inputFromStdin = stdin.readLineSync();
      if (inputFromStdin == null || inputFromStdin.isEmpty) {
        logger.warning('Busca cancelada: nenhum título informado via stdin.');
        throw const ArgumentException(
          'Nenhum título de artigo foi informado.',
          command: 'search',
        );
      }
      articleTitle = inputFromStdin;
    } else {
      articleTitle = results.rest.join('_');
    }

    logger.info('Iniciando busca na Wikipédia pelo artigo: "$articleTitle"');
    onOutput('Buscando "${articleTitle.bold}" na Wikipédia...\n'.cyan);

    try {
      final Summary summary = await fetchWikipediaSummary(articleTitle);
      logger.info(
        'Artigo "${summary.title}" (ID: ${summary.pageId}) desserializado com sucesso.',
      );
      final outputBuffer = StringBuffer()
        ..writeln('=== ${summary.title} (ID: ${summary.pageId}) ==='.bold.green);
      if (summary.description != null) {
        outputBuffer.writeln('Descrição: ${summary.description}'.yellow);
      }
      outputBuffer.write(summary.extract);
      onOutput(outputBuffer.toString());
      return CommandStatus.success;
    } catch (e, stackTrace) {
      logger.severe('Falha ao buscar artigo "$articleTitle"', e, stackTrace);
      throw CommandExecutionException(
        'Não foi possível obter o artigo "$articleTitle".',
        cause: e,
      );
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

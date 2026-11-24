// Version: 1.0.0
// Simulador da Fase de Grupos - Copa do Mundo 2026 (CLI)
import 'dart:io';
import 'package:copa_2026_cli/models/selecao.dart';
import 'package:copa_2026_cli/services/classificacao_service.dart';
import 'package:copa_2026_cli/services/dados_service.dart';
import 'package:copa_2026_cli/services/partida_service.dart';

Future<void> main() async {
  final dadosService = DadosService();
  final partidaService = PartidaService();
  final classificacaoService = ClassificacaoService();

  print('Carregando seleções da Copa do Mundo 2026...');
  final dados = await dadosService.carregarDadosCopa();
  final Grupo grupo = dados.grupo;
  final List<Selecao> selecoes = dados.selecoes;

  while (true) {
    print('\n=== SIMULADOR GRUPO ${grupo.name} - COPA 2026 ===');
    print('1. Registrar Resultado de Jogo');
    print('2. Ver Classificação Atual');
    print('3. Sair');
    stdout.write('\nOpção: ');

    final opcao = stdin.readLineSync()?.trim();

    if (opcao == '1') {
      print('\nSelecione as duas seleções da partida:');
      for (int i = 0; i < selecoes.length; i++) {
        print('${i + 1}. ${selecoes[i].nome}');
      }

      stdout.write('Número da Seleção A: ');
      final idxA = int.tryParse(stdin.readLineSync()?.trim() ?? '');
      stdout.write('Número da Seleção B: ');
      final idxB = int.tryParse(stdin.readLineSync()?.trim() ?? '');

      if (idxA == null ||
          idxB == null ||
          idxA < 1 ||
          idxA > selecoes.length ||
          idxB < 1 ||
          idxB > selecoes.length ||
          idxA == idxB) {
        print('Erro: Seleção inválida! Escolha dois times diferentes.');
        continue;
      }

      partidaService.registrarJogo(selecoes[idxA - 1], selecoes[idxB - 1]);
    } else if (opcao == '2') {
      classificacaoService.exibirTabela(
        grupo,
        selecoes,
        partidaService.historicoPartidas,
      );
    } else if (opcao == '3') {
      print('Encerrando Simulador da Copa 2026. Até a próxima!');
      break;
    } else {
      print('Opção inválida. Digite 1, 2 ou 3.');
    }
  }
}

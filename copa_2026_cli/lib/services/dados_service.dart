// Version: 0.0.0
// Aluno 4: Analista de Dados e Testes (Lições 03, 06, 09 e 11)
import 'dart:convert';
import 'dart:io';
import '../models/selecao.dart';

class DadosService {
  Future<({Grupo grupo, List<Selecao> selecoes})> carregarDadosCopa({
    String caminhoArquivo = 'dados_copa.json',
  }) async {
    try {
      final file = File(caminhoArquivo);
      if (await file.exists()) {
        final conteudo = await file.readAsString();
        final mapa = jsonDecode(conteudo) as Map<String, dynamic>;
        final nomeGrupo = (mapa['grupo'] as String? ?? 'A').toUpperCase();
        final grupo = Grupo.values.firstWhere(
          (g) => g.name == nomeGrupo,
          orElse: () => Grupo.A,
        );
        final listaJson = mapa['selecoes'] as List<dynamic>;
        final selecoes = listaJson
            .map((item) => Selecao.fromJson(item as Map<String, dynamic>, grupo))
            .toList();
        return (grupo: grupo, selecoes: selecoes);
      }
    } catch (e) {
      print('Aviso: Falha ao ler $caminhoArquivo ($e). Usando dados padrão...');
    }

    // Fallback em memória caso executado de outro diretório
    return (
      grupo: Grupo.A,
      selecoes: [
        Selecao(nome: 'México', grupo: Grupo.A, rankingFifa: 15),
        Selecao(nome: 'África do Sul', grupo: Grupo.A, rankingFifa: 59),
        Selecao(nome: 'Rep. Checa', grupo: Grupo.A, rankingFifa: 36),
        Selecao(nome: 'Coreia do Sul', grupo: Grupo.A, rankingFifa: 22),
      ],
    );
  }
}

// Version: 0.0.0
import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/tarefa.dart';

enum FiltroTarefa { todas, pendentes, concluidas }

class TarefaProvider extends ChangeNotifier {
  List<Tarefa> _tarefas = [];
  bool _isLoading = false;
  FiltroTarefa _filtroAtual = FiltroTarefa.todas;

  bool get isLoading => _isLoading;
  FiltroTarefa get filtroAtual => _filtroAtual;

  // Exercício 01: Contadores totais e concluídos
  int get totalTarefas => _tarefas.length;
  int get totalConcluidas => _tarefas.where((t) => t.concluida).length;

  // Exercício 02: Lista filtrada conforme seleção (Todas, Pendentes, Concluídas)
  List<Tarefa> get tarefasFiltradas {
    switch (_filtroAtual) {
      case FiltroTarefa.pendentes:
        return List.unmodifiable(_tarefas.where((t) => !t.concluida));
      case FiltroTarefa.concluidas:
        return List.unmodifiable(_tarefas.where((t) => t.concluida));
      case FiltroTarefa.todas:
        return List.unmodifiable(_tarefas);
    }
  }

  void setFiltro(FiltroTarefa novoFiltro) {
    _filtroAtual = novoFiltro;
    notifyListeners();
  }

  Future<void> carregarTarefas() async {
    _isLoading = true;
    notifyListeners();

    _tarefas = await DatabaseHelper.instance.queryAll();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> adicionarTarefa(String titulo) async {
    if (titulo.trim().isEmpty) return;

    final novaTarefa = Tarefa(titulo: titulo.trim());
    final id = await DatabaseHelper.instance.insert(novaTarefa);

    _tarefas.insert(0, novaTarefa.copyWith(id: id));
    notifyListeners();
  }

  Future<void> alternarStatus(Tarefa tarefa) async {
    final tarefaAtualizada = tarefa.copyWith(concluida: !tarefa.concluida);
    await DatabaseHelper.instance.update(tarefaAtualizada);

    final index = _tarefas.indexWhere((t) => t.id == tarefa.id);
    if (index != -1) {
      _tarefas[index] = tarefaAtualizada;
      notifyListeners();
    }
  }

  // Exercício 03: Editar a descrição de uma tarefa existente no SQLite e no Provider
  Future<void> editarTarefa(Tarefa tarefa, String novoTitulo) async {
    final limpo = novoTitulo.trim();
    if (limpo.isEmpty) return;

    final tarefaEditada = tarefa.copyWith(titulo: limpo);
    await DatabaseHelper.instance.update(tarefaEditada);

    final index = _tarefas.indexWhere((t) => t.id == tarefa.id);
    if (index != -1) {
      _tarefas[index] = tarefaEditada;
      notifyListeners();
    }
  }

  Future<void> removerTarefa(int id) async {
    await DatabaseHelper.instance.delete(id);
    _tarefas.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

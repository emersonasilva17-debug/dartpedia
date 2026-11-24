// Version: 0.0.0
// Aula 08 - Tela de Tarefas com SQLite (Exercícios 01, 02 e 03)
import 'package:flutter/material.dart';
import 'database_helper.dart';

class TarefasSqliteScreen extends StatefulWidget {
  const TarefasSqliteScreen({super.key});

  @override
  State<TarefasSqliteScreen> createState() => _TarefasSqliteScreenState();
}

class _TarefasSqliteScreenState extends State<TarefasSqliteScreen> {
  final TextEditingController _novaTarefaController = TextEditingController();
  final TextEditingController _buscaController = TextEditingController();

  List<Tarefa> _tarefas = [];
  int _totalRegistradas = 0;

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  @override
  void dispose() {
    _novaTarefaController.dispose();
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _atualizarLista() async {
    final termo = _buscaController.text;
    final todas = await DatabaseHelper.instance.getAllTarefas();
    final filtradas = await DatabaseHelper.instance.searchTarefas(termo);

    setState(() {
      _totalRegistradas = todas.length;
      _tarefas = filtradas;
    });
  }

  Future<void> _adicionarTarefa() async {
    final titulo = _novaTarefaController.text.trim();
    if (titulo.isEmpty) return;

    await DatabaseHelper.instance.insertTarefa(Tarefa(titulo: titulo));
    _novaTarefaController.clear();
    await _atualizarLista();
  }

  Future<void> _alternarConcluida(Tarefa tarefa) async {
    await DatabaseHelper.instance.updateTarefa(
      Tarefa(
        id: tarefa.id,
        titulo: tarefa.titulo,
        concluida: !tarefa.concluida,
      ),
    );
    await _atualizarLista();
  }

  // Exercício 02: Ação do botão na AppBar usando DatabaseHelper.deleteAll()
  Future<void> _limparTodasTarefas() async {
    await DatabaseHelper.instance.deleteAll();
    _buscaController.clear();
    await _atualizarLista();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todas as tarefas foram removidas do SQLite!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas - SQLite'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          // Exercício 02: Botão na AppBar para limpar todas as tarefas
          IconButton(
            tooltip: 'Limpar todas as tarefas (deleteAll)',
            icon: const Icon(Icons.delete_sweep),
            onPressed: _totalRegistradas == 0 ? null : _limparTodasTarefas,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Exercício 03: Campo de busca usando WHERE titulo LIKE %...%
            TextField(
              controller: _buscaController,
              onChanged: (_) => _atualizarLista(),
              decoration: InputDecoration(
                labelText: 'Pesquisar tarefa (LIKE %...%)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _buscaController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _buscaController.clear();
                          _atualizarLista();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Campo para inserir nova tarefa
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _novaTarefaController,
                    onSubmitted: (_) => _adicionarTarefa(),
                    decoration: const InputDecoration(
                      labelText: 'Nova tarefa',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _adicionarTarefa,
                  icon: const Icon(Icons.add),
                  label: const Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lista de tarefas
            Expanded(
              child: _tarefas.isEmpty
                  ? const Center(
                      child: Text('Nenhuma tarefa encontrada no banco.'),
                    )
                  : ListView.builder(
                      itemCount: _tarefas.length,
                      itemBuilder: (context, index) {
                        final tarefa = _tarefas[index];
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: tarefa.concluida,
                              onChanged: (_) => _alternarConcluida(tarefa),
                            ),
                            title: Text(
                              tarefa.titulo,
                              style: TextStyle(
                                decoration: tarefa.concluida
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                if (tarefa.id != null) {
                                  await DatabaseHelper.instance
                                      .deleteTarefa(tarefa.id!);
                                  await _atualizarLista();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Exercício 01: Contador visual no rodapé com o total de tarefas no banco
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        color: Colors.teal.shade50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.storage, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Total de tarefas no SQLite:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Chip(
              backgroundColor: Colors.teal,
              label: Text(
                '$_totalRegistradas',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Version: 0.0.0
// Aula 12 - Persistência Reativa com Provider e SQLite (Exercícios 01, 02 e 03)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/tarefa.dart';
import 'providers/tarefa_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TarefaProvider()..carregarTarefas(),
      child: const TarefasApp(),
    ),
  );
}

class TarefasApp extends StatelessWidget {
  const TarefasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas com Provider & SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _exibirDialogNovaTarefa(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nova Tarefa'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Descrição da tarefa',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Provider.of<TarefaProvider>(context, listen: false)
                    .adicionarTarefa(controller.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  // Exercício 03: Dialog de edição disparado pelo onLongPress
  void _exibirDialogEditarTarefa(BuildContext context, Tarefa tarefa) {
    final controller = TextEditingController(text: tarefa.titulo);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Tarefa'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nova descrição da tarefa',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Provider.of<TarefaProvider>(context, listen: false)
                    .editarTarefa(tarefa, controller.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas (SQLite + Provider)'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Consumer<TarefaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final listaExibida = provider.tarefasFiltradas;
          final progresso = provider.totalTarefas == 0
              ? 0.0
              : provider.totalConcluidas / provider.totalTarefas;

          return Column(
            children: [
              // Exercício 01: Contador no topo indicando proporção de tarefas concluídas
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.indigo.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progresso das Tarefas',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${provider.totalConcluidas} de ${provider.totalTarefas} concluídas',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progresso,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),

              // Exercício 02: Filtro por botões (Todas, Pendentes, Concluídas)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: SegmentedButton<FiltroTarefa>(
                  segments: const [
                    ButtonSegment(
                      value: FiltroTarefa.todas,
                      label: Text('Todas'),
                    ),
                    ButtonSegment(
                      value: FiltroTarefa.pendentes,
                      label: Text('Pendentes'),
                    ),
                    ButtonSegment(
                      value: FiltroTarefa.concluidas,
                      label: Text('Concluídas'),
                    ),
                  ],
                  selected: {provider.filtroAtual},
                  onSelectionChanged: (selecao) {
                    provider.setFiltro(selecao.first);
                  },
                ),
              ),

              // Lista de tarefas
              Expanded(
                child: listaExibida.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma tarefa encontrada neste filtro!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: listaExibida.length,
                        itemBuilder: (ctx, index) {
                          final tarefa = listaExibida[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            child: ListTile(
                              // Exercício 03: Clique longo para editar descrição
                              onLongPress: () =>
                                  _exibirDialogEditarTarefa(context, tarefa),
                              leading: Checkbox(
                                value: tarefa.concluida,
                                onChanged: (_) {
                                  provider.alternarStatus(tarefa);
                                },
                              ),
                              title: Text(
                                tarefa.titulo,
                                style: TextStyle(
                                  decoration: tarefa.concluida
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: tarefa.concluida
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              subtitle: const Text(
                                'Segure para editar',
                                style: TextStyle(fontSize: 11),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  if (tarefa.id != null) {
                                    provider.removerTarefa(tarefa.id!);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _exibirDialogNovaTarefa(context),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

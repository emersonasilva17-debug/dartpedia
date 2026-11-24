// Version: 0.0.0
// Aula 05 - Interatividade, TextField e StatefulWidget (Exercícios 01, 02 e 03)
import 'package:flutter/material.dart';

class CadastroInterativoScreen extends StatefulWidget {
  const CadastroInterativoScreen({super.key});

  @override
  State<CadastroInterativoScreen> createState() =>
      _CadastroInterativoScreenState();
}

class _CadastroInterativoScreenState extends State<CadastroInterativoScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  // Exercício 02: Controlador para o campo 'Observador'
  final TextEditingController _observadorController = TextEditingController();

  final List> _registros = [];

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _observadorController.dispose();
    super.dispose();
  }

  // Exercício 01: Função para limpar/resetar o formulário manualmente
  void _limparFormulario() {
    setState(() {
      _tituloController.clear();
      _descricaoController.clear();
      _observadorController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  void _salvarRegistro() {
    final titulo = _tituloController.text.trim();
    final descricao = _descricaoController.text.trim();
    final observador = _observadorController.text.trim();

    if (titulo.isEmpty || observador.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha pelo menos o Título e o Observador.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _registros.add({
        'titulo': titulo,
        'descricao': descricao.isEmpty ? 'Sem descrição adicional' : descricao,
        'observador': observador,
      });
    });

    _limparFormulario();

    // Exercício 03: Exibir SnackBar com a contagem total atualizada a cada cadastro efetuado
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cadastro efetuado! Total de registros: ${_registros.length}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Interativo - Aula 05'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título do Registro',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            // Exercício 02: Campo de 'Observador' (Nome de quem registrou)
            TextField(
              controller: _observadorController,
              decoration: const InputDecoration(
                labelText: 'Observador (Nome de quem registrou)',
                prefixIcon: Icon(Icons.person_pin),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _salvarRegistro,
                    icon: const Icon(Icons.save),
                    label: const Text('Cadastrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Exercício 01: Botão de limpar/resetar o formulário manualmente
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _limparFormulario,
                    icon: const Icon(Icons.cleaning_services),
                    label: const Text('Limpar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 28),
            Text(
              'Registros Cadastrados (${_registros.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _registros.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum registro cadastrado ainda.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _registros.length,
                      itemBuilder: (context, index) {
                        final item = _registros[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: Text('${index + 1}'),
                            ),
                            title: Text(
                              item['titulo']!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // Exercício 02: Exibir o Observador no subtítulo da lista
                            subtitle: Text(
                              '${item['descricao']}\nObservador: ${item['observador']}',
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

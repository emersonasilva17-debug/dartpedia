// Version: 0.0.0
// Exercício 3: Formulário Interativo com Estado (Stateful & Forms)
import 'package:flutter/material.dart';

class Exercicio3FormularioScreen extends StatefulWidget {
  const Exercicio3FormularioScreen({super.key});

  @override
  State<Exercicio3FormularioScreen> createState() =>
      _Exercicio3FormularioScreenState();
}

class _Exercicio3FormularioScreenState
    extends State<Exercicio3FormularioScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _profissaoController = TextEditingController();

  String? _mensagemBoasVindas;

  @override
  void dispose() {
    _nomeController.dispose();
    _profissaoController.dispose();
    super.dispose();
  }

  void _cadastrarUsuario() {
    final nome = _nomeController.text.trim();
    final profissao = _profissaoController.text.trim();

    if (nome.isEmpty || profissao.isEmpty) {
      return;
    }

    setState(() {
      _mensagemBoasVindas =
          'Bem-vindo(a), $nome! Cargo cadastrado: $profissao';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário Interativo'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome Completo',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _profissaoController,
              decoration: const InputDecoration(
                labelText: 'Profissão / Cargo Desejado',
                prefixIcon: Icon(Icons.work_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cadastrarUsuario,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Cadastrar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            if (_mensagemBoasVindas != null)
              Card(
                color: Colors.indigo.shade50,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.indigo.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.indigo),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _mensagemBoasVindas!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

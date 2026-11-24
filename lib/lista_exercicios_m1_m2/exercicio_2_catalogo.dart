// Version: 0.0.0
// Exercício 2: Catálogo Dinâmico (Listas e Containers)
import 'package:flutter/material.dart';

class Exercicio2CatalogoScreen extends StatelessWidget {
  const Exercicio2CatalogoScreen({super.key});

  static const List> _itensCatalogo = [
    {
      'titulo': 'Smartphone Dev Pro',
      'descricao': 'Tela OLED 6.5", 256GB, ideal para testes de apps Flutter.',
      'icone': Icons.smartphone,
    },
    {
      'titulo': 'Notebook UltraCode',
      'descricao': '16GB RAM, SSD NVMe 512GB, compilação rápida em Dart.',
      'icone': Icons.laptop_mac,
    },
    {
      'titulo': 'Teclado Mecânico RGB',
      'descricao': 'Switches táteis silenciosos para longas sessões de código.',
      'icone': Icons.keyboard,
    },
    {
      'titulo': 'Monitor 27" IPS 4K',
      'descricao': 'Alta definição para visualizar emulador e IDE lado a lado.',
      'icone': Icons.desktop_windows,
    },
    {
      'titulo': 'Headset Noise Cancelling',
      'descricao': 'Foco total durante as aulas e projetos de desenvolvimento.',
      'icone': Icons.headphones,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo Dinâmico'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: _itensCatalogo.length,
        itemBuilder: (context, index) {
          final item = _itensCatalogo[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo.shade50,
                child: Icon(
                  item['icone'] as IconData,
                  color: Colors.indigo,
                ),
              ),
              title: Text(
                item['titulo'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                item['descricao'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        },
      ),
    );
  }
}

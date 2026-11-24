// Version: 0.0.0
// Aula 07 - Armazenamento Chave-Valor com SharedPreferences (Exercícios 01, 02 e 03)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracoesPrefsScreen extends StatefulWidget {
  const ConfiguracoesPrefsScreen({super.key});

  @override
  State<ConfiguracoesPrefsScreen> createState() =>
      _ConfiguracoesPrefsScreenState();
}

class _ConfiguracoesPrefsScreenState extends State<ConfiguracoesPrefsScreen> {
  static const String _keyTamanhoFonte = 'tamanho_fonte';
  static const String _keyNotificacoes = 'receber_notificacoes';

  String _tamanhoFonte = 'Médio';
  bool _receberNotificacoes = true;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tamanhoFonte = prefs.getString(_keyTamanhoFonte) ?? 'Médio';
      _receberNotificacoes = prefs.getBool(_keyNotificacoes) ?? true;
      _carregando = false;
    });
  }

  // Exercício 02: Salvar tamanho da fonte (Pequeno, Médio, Grande)
  Future<void> _salvarTamanhoFonte(String novoTamanho) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTamanhoFonte, novoTamanho);
    setState(() {
      _tamanhoFonte = novoTamanho;
    });
  }

  // Exercício 03: Persistir estado bool do switch "Receber Notificações"
  Future<void> _salvarNotificacoes(bool ativo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificacoes, ativo);
    setState(() {
      _receberNotificacoes = ativo;
    });
  }

  // Exercício 01: Botão "Limpar Configurações" usando prefs.clear()
  Future<void> _limparConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _tamanhoFonte = 'Médio';
      _receberNotificacoes = true;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todas as configurações foram apagadas (prefs.clear)!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  double get _fontSizeAtual {
    switch (_tamanhoFonte) {
      case 'Pequeno':
        return 14.0;
      case 'Grande':
        return 22.0;
      case 'Médio':
      default:
        return 18.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferências - SharedPreferences'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Exercício 03: Switch "Receber Notificações" (bool)
            Card(
              child: SwitchListTile(
                title: Text(
                  'Receber Notificações',
                  style: TextStyle(
                    fontSize: _fontSizeAtual,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _receberNotificacoes
                      ? 'Notificações ativadas e salvas no disco'
                      : 'Notificações desativadas',
                  style: TextStyle(fontSize: _fontSizeAtual - 2),
                ),
                secondary: Icon(
                  _receberNotificacoes
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  color: Colors.indigo,
                ),
                value: _receberNotificacoes,
                onChanged: _salvarNotificacoes,
              ),
            ),
            const SizedBox(height: 16),

            // Exercício 02: Seletor de Tamanho da Fonte (Pequeno, Médio, Grande)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tamanho da Fonte',
                      style: TextStyle(
                        fontSize: _fontSizeAtual,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Pequeno', label: Text('Pequeno')),
                        ButtonSegment(value: 'Médio', label: Text('Médio')),
                        ButtonSegment(value: 'Grande', label: Text('Grande')),
                      ],
                      selected: {_tamanhoFonte},
                      onSelectionChanged: (selecao) {
                        _salvarTamanhoFonte(selecao.first);
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pré-visualização do texto com fonte "$_tamanhoFonte" (${_fontSizeAtual.toInt()}px).',
                      style: TextStyle(fontSize: _fontSizeAtual),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Exercício 01: Botão "Limpar Configurações" usando prefs.clear()
            ElevatedButton.icon(
              onPressed: _limparConfiguracoes,
              icon: const Icon(Icons.delete_forever),
              label: const Text('Limpar Configurações'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

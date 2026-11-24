// Version: 0.0.0
// Aula 09 - Integração com APIs RESTful (ViaCEP + AwesomeAPI), Máscara CEP e Histórico
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// Modelo JSON para ViaCEP
class EnderecoCep {
  final String cep;
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  const EnderecoCep({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory EnderecoCep.fromJson(Map<String, dynamic> json) {
    return EnderecoCep(
      cep: json['cep'] as String? ?? '',
      logradouro: json['logradouro'] as String? ?? '',
      bairro: json['bairro'] as String? ?? '',
      localidade: json['localidade'] as String? ?? '',
      uf: json['uf'] as String? ?? '',
    );
  }
}

// Modelo JSON para AwesomeAPI (USD-BRL)
class CotacaoDolar {
  final String bid;
  final String ask;
  final String pctChange;
  final String createDate;

  const CotacaoDolar({
    required this.bid,
    required this.ask,
    required this.pctChange,
    required this.createDate,
  });

  factory CotacaoDolar.fromJson(Map<String, dynamic> json) {
    final usdBrl = json['USDBRL'] as Map<String, dynamic>;
    return CotacaoDolar(
      bid: usdBrl['bid'] as String? ?? '0.00',
      ask: usdBrl['ask'] as String? ?? '0.00',
      pctChange: usdBrl['pctChange'] as String? ?? '0.00',
      createDate: usdBrl['create_date'] as String? ?? '',
    );
  }
}

// Exercício 02: Máscara visual para o formato 00000-000
class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final clipped = digits.length > 8 ? digits.substring(0, 8) : digits;

    final buffer = StringBuffer();
    for (int i = 0; i < clipped.length; i++) {
      if (i == 5) buffer.write('-');
      buffer.write(clipped[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ApisRestScreen extends StatefulWidget {
  const ApisRestScreen({super.key});

  @override
  State<ApisRestScreen> createState() => _ApisRestScreenState();
}

class _ApisRestScreenState extends State<ApisRestScreen> {
  final TextEditingController _cepController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  EnderecoCep? _enderecoAtual;
  String? _erroCep;
  bool _buscandoCep = false;

  // Exercício 01: Histórico local das últimas buscas realizadas na tela
  final List<EnderecoCep> _historicoBuscas = [];

  // Exercício 03: Cotação do Dólar via AwesomeAPI
  CotacaoDolar? _cotacaoDolar;
  bool _carregandoDolar = false;
  String? _erroDolar;

  @override
  void initState() {
    super.initState();
    _buscarCotacaoDolar();
  }

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  // Exercício 03: Consumo da segunda API pública (AwesomeAPI - Dólar)
  Future<void> _buscarCotacaoDolar() async {
    setState(() {
      _carregandoDolar = true;
      _erroDolar = null;
    });

    try {
      final uri = Uri.parse(
        'https://economia.awesomeapi.com.br/json/last/USD-BRL',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _cotacaoDolar = CotacaoDolar.fromJson(decoded);
        });
      } else {
        setState(() {
          _erroDolar = 'Erro HTTP ${response.statusCode} ao obter cotação.';
        });
      }
    } catch (e) {
      setState(() {
        _erroDolar = 'Falha na conexão com AwesomeAPI: $e';
      });
    } finally {
      setState(() {
        _carregandoDolar = false;
      });
    }
  }

  Future<void> _buscarCep([String? cepDireto]) async {
    final textoCep = cepDireto ?? _cepController.text;
    if (cepDireto == null && !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final cepLimpo = textoCep.replaceAll(RegExp(r'\D'), '');
    setState(() {
      _buscandoCep = true;
      _erroCep = null;
    });

    try {
      final uri = Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['erro'] == true) {
          setState(() {
            _erroCep = 'CEP $textoCep não encontrado na base do ViaCEP.';
            _enderecoAtual = null;
          });
        } else {
          final endereco = EnderecoCep.fromJson(decoded);
          setState(() {
            _enderecoAtual = endereco;
            // Exercício 01: Atualiza histórico local sem duplicar o mesmo CEP no topo
            _historicoBuscas.removeWhere((item) => item.cep == endereco.cep);
            _historicoBuscas.insert(0, endereco);
            if (_historicoBuscas.length > 5) {
              _historicoBuscas.removeLast();
            }
          });
        }
      } else {
        setState(() {
          _erroCep = 'Erro na API ViaCEP (Status ${response.statusCode}).';
        });
      }
    } catch (e) {
      setState(() {
        _erroCep = 'Erro de rede ao consultar CEP: $e';
      });
    } finally {
      setState(() {
        _buscandoCep = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cepValido =
        RegExp(r'^\d{5}-\d{3}$').hasMatch(_cepController.text.trim());

    return Scaffold(
      appBar: AppBar(
        title: const Text('APIs RESTful - ViaCEP & Dólar'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Exercício 03: Card de Cotação do Dólar (AwesomeAPI)
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.attach_money, color: Colors.green),
                            SizedBox(width: 6),
                            Text(
                              'Cotação do Dólar (USD/BRL)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          tooltip: 'Atualizar cotação',
                          icon: const Icon(Icons.refresh),
                          onPressed:
                              _carregandoDolar ? null : _buscarCotacaoDolar,
                        ),
                      ],
                    ),
                    if (_carregandoDolar)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: LinearProgressIndicator(),
                      )
                    else if (_erroDolar != null)
                      Text(
                        _erroDolar!,
                        style: const TextStyle(color: Colors.red),
                      )
                    else if (_cotacaoDolar != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Compra: R\$ ${_cotacaoDolar!.bid}  |  Venda: R\$ ${_cotacaoDolar!.ask}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Variação: ${_cotacaoDolar!.pctChange}% • Atualizado: ${_cotacaoDolar!.createDate}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Exercício 02: TextField com máscara 00000-000 e validação visual
            Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cepController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [CepInputFormatter()],
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null ||
                            !RegExp(r'^\d{5}-\d{3}$').hasMatch(value)) {
                          return 'Formato obrigatório: 00000-000';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'CEP (00000-000)',
                        hintText: '01001-000',
                        prefixIcon: const Icon(Icons.location_on),
                        suffixIcon: Icon(
                          cepValido ? Icons.check_circle : Icons.error_outline,
                          color: cepValido ? Colors.green : Colors.orange,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _buscandoCep ? null : () => _buscarCep(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                    ),
                    child: _buscandoCep
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Buscar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_erroCep != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _erroCep!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

            if (_enderecoAtual != null)
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.home_work, color: Colors.deepPurple),
                  title: Text(
                    '${_enderecoAtual!.logradouro} - ${_enderecoAtual!.bairro}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${_enderecoAtual!.localidade}/${_enderecoAtual!.uf} • CEP: ${_enderecoAtual!.cep}',
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Exercício 01: Histórico local das últimas buscas realizadas na tela
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Histórico Local de Buscas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (_historicoBuscas.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => _historicoBuscas.clear()),
                    child: const Text('Limpar'),
                  ),
              ],
            ),
            const Divider(),
            if (_historicoBuscas.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Nenhuma busca realizada ainda nesta sessão.'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _historicoBuscas.length,
                itemBuilder: (context, index) {
                  final item = _historicoBuscas[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.history),
                    title: Text('${item.cep} — ${item.logradouro}'),
                    subtitle: Text('${item.localidade}/${item.uf}'),
                    trailing: const Icon(Icons.north_west, size: 16),
                    onTap: () {
                      _cepController.text = item.cep;
                      _buscarCep(item.cep);
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

// Version: 0.0.0
// Aula 06 - Navegação Declarativa, Rotas Nomeadas, Passagem de Parâmetros e AlertDialog
import 'package:flutter/material.dart';

class Produto {
  final String nome;
  final double preco;
  final String descricao;

  const Produto({
    required this.nome,
    required this.preco,
    required this.descricao,
  });
}

// Exercício 03: Refatorado para utilizar rotas nomeadas (routes: no MaterialApp) e Navigator.pushNamed()
class NavegacaoProdutosApp extends StatelessWidget {
  const NavegacaoProdutosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aula 06 - Rotas Nomeadas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ListaProdutosScreen(),
        '/detalhes': (context) => const DetalhesProdutoScreen(),
        '/adicionar': (context) => const AddProductScreen(),
      },
    );
  }
}

class ListaProdutosScreen extends StatefulWidget {
  const ListaProdutosScreen({super.key});

  @override
  State<ListaProdutosScreen> createState() => _ListaProdutosScreenState();
}

class _ListaProdutosScreenState extends State<ListaProdutosScreen> {
  final List<Produto> _produtos = [
    const Produto(
      nome: 'Teclado Mecânico Dev',
      preco: 349.90,
      descricao: 'Layout ABNT2, switches táteis silenciosos.',
    ),
    const Produto(
      nome: 'Mouse Ergonômico Wireless',
      preco: 189.00,
      descricao: 'Sensor óptico de alta precisão e bateria recarregável.',
    ),
  ];

  // Exercício 01 e 03: Navega para '/adicionar' via pushNamed e adiciona o produto retornado
  Future<void> _abrirTelaAdicionar() async {
    final resultado = await Navigator.pushNamed(context, '/adicionar');

    if (resultado != null && resultado is Produto) {
      setState(() {
        _produtos.add(resultado);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produto "${resultado.nome}" adicionado à lista!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _produtos.length,
        itemBuilder: (context, index) {
          final produto = _produtos[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo.shade100,
                child: const Icon(Icons.shopping_bag, color: Colors.indigo),
              ),
              title: Text(
                produto.nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              // Exercício 03: Passagem de parâmetro via arguments no pushNamed
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detalhes',
                  arguments: produto,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirTelaAdicionar,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo Produto'),
      ),
    );
  }
}

class DetalhesProdutoScreen extends StatelessWidget {
  const DetalhesProdutoScreen({super.key});

  // Exercício 02: AlertDialog confirmando se o usuário deseja voltar antes de acionar Navigator.pop()
  Future<void> _confirmarVoltar(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar saída'),
        content: const Text('Deseja realmente voltar para a lista de produtos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sim, voltar'),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final produto = ModalRoute.of(context)!.settings.arguments as Produto;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _confirmarVoltar(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Produto'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _confirmarVoltar(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    produto.nome,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preço: R\$ ${produto.preco.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  const Divider(height: 24),
                  Text(
                    produto.descricao,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _confirmarVoltar(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Voltar ao Catálogo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Exercício 01: Terceira tela (AddProductScreen) com formulário para cadastrar novos produtos
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _descricaoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  // Exercício 02: AlertDialog antes de cancelar e voltar sem salvar
  Future<void> _confirmarCancelamento() async {
    final sair = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Descartar cadastro?'),
        content: const Text('Deseja voltar sem salvar o novo produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Continuar editando'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sim, voltar'),
          ),
        ],
      ),
    );

    if (sair == true && mounted) {
      Navigator.pop(context);
    }
  }

  void _salvarProduto() {
    final nome = _nomeController.text.trim();
    final preco = double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0;
    final descricao = _descricaoController.text.trim();

    if (nome.isEmpty || preco <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe um nome válido e um preço maior que zero.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final novoProduto = Produto(
      nome: nome,
      preco: preco,
      descricao: descricao.isEmpty ? 'Sem descrição informada.' : descricao,
    );

    // Retorna o novo produto para a tela anterior
    Navigator.pop(context, novoProduto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Novo Produto'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _confirmarCancelamento,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Produto',
                prefixIcon: Icon(Icons.inventory_2),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _precoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Preço (R\$)',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descricaoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descrição do Produto',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _salvarProduto,
              icon: const Icon(Icons.check),
              label: const Text('Salvar e Voltar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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

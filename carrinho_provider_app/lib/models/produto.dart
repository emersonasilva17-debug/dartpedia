// Version: 0.0.0
class Produto {
  final String id;
  final String nome;
  final double preco;

  const Produto({
    required this.id,
    required this.nome,
    required this.preco,
  });
}

class ItemCarrinho {
  final Produto produto;
  int quantidade;

  ItemCarrinho({
    required this.produto,
    this.quantidade = 1,
  });

  double get subtotal => produto.preco * quantidade;
}

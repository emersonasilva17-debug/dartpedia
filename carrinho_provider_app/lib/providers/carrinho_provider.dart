// Version: 0.0.0
import 'package:flutter/foundation.dart';
import '../models/produto.dart';

class CarrinhoProvider extends ChangeNotifier {
  final List<ItemCarrinho> _itens = [];
  String? _cupomAplicado;
  double _percentualDesconto = 0.0;

  List<ItemCarrinho> get itens => List.unmodifiable(_itens);
  String? get cupomAplicado => _cupomAplicado;
  double get percentualDesconto => _percentualDesconto;

  // Exercício 01: Soma das quantidades individuais de todos os itens
  int get quantidadeTotalItens {
    return _itens.fold(0, (soma, item) => soma + item.quantidade);
  }

  int quantidadeDoProduto(String produtoId) {
    final index = _itens.indexWhere((i) => i.produto.id == produtoId);
    return index == -1 ? 0 : _itens[index].quantidade;
  }

  double get subtotal {
    return _itens.fold(0.0, (total, item) => total + item.subtotal);
  }

  double get valorDesconto => subtotal * _percentualDesconto;

  double get valorTotal => subtotal - valorDesconto;

  // Exercício 01: Adicionar ou incrementar quantidade individual
  void adicionar(Produto produto) {
    final index = _itens.indexWhere((i) => i.produto.id == produto.id);
    if (index != -1) {
      _itens[index].quantidade++;
    } else {
      _itens.add(ItemCarrinho(produto: produto, quantidade: 1));
    }
    notifyListeners();
  }

  // Exercício 01: Diminuir quantidade individual (remove se chegar a 0)
  void diminuirQuantidade(Produto produto) {
    final index = _itens.indexWhere((i) => i.produto.id == produto.id);
    if (index == -1) return;

    if (_itens[index].quantidade > 1) {
      _itens[index].quantidade--;
    } else {
      _itens.removeAt(index);
    }
    notifyListeners();
  }

  void removerItemCompleto(Produto produto) {
    _itens.removeWhere((i) => i.produto.id == produto.id);
    notifyListeners();
  }

  // Exercício 02: Aplicar cupom de desconto no CarrinhoProvider
  bool aplicarCupom(String codigo) {
    final limpo = codigo.trim().toUpperCase();
    if (limpo == 'DESC10') {
      _cupomAplicado = limpo;
      _percentualDesconto = 0.10;
      notifyListeners();
      return true;
    } else if (limpo == 'SENAI20') {
      _cupomAplicado = limpo;
      _percentualDesconto = 0.20;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removerCupom() {
    _cupomAplicado = null;
    _percentualDesconto = 0.0;
    notifyListeners();
  }

  void limpar() {
    _itens.clear();
    _cupomAplicado = null;
    _percentualDesconto = 0.0;
    notifyListeners();
  }
}

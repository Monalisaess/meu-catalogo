//guardo a lista de produtos e controlo os favoritos

import 'package:flutter/foundation.dart';
import '../models/item_model.dart';

class CatalogoViewModel extends ChangeNotifier {
  final List<ItemCatalogo> _itens = [
    ItemCatalogo(
      nome: "Base Tint",
      marca: "Quem Disse, Berenice?",
      categoria: "Base",
      imagem: "assets/imagens/item1.jpg",
      minhaOpiniao:
          "Cobre tudo com uma gota e deixa um matte confortável sem pesar. Dica: espalhe rapidinho pois seca super rápido!",
      nota: 4.7,
    ),
    ItemCatalogo(
      nome: "Corretivo Fix",
      marca: "Vizzela",
      categoria: "Corretivo",
      imagem: "assets/imagens/item2.jpg",
      minhaOpiniao:
          "Cobertura média natural que não pesa nada! O segredo perfeito para peles oleosas durarem o dia todo impecáveis.",
      nota: 4.8,
    ),
    ItemCatalogo(
      nome: "Blush Líquido (Sunny)",
      marca: "Bauny",
      categoria: "Blush",
      imagem: "assets/imagens/item3.jpg",
      minhaOpiniao:
          "O rei do 3 em 1 (bochecha, olho e boca)! Uma gotinha esfuma fácil, não mancha, dura horrores e rende uma vida.",
      nota: 4.8,
    ),
    ItemCatalogo(
      nome: "Pó Solto Fix HD",
      marca: "Vizzela",
      categoria: "Pó Solto",
      imagem: "assets/imagens/item4.jpg",
      minhaOpiniao:
          "Pó fininho e super resistente que segura o brilho o dia todo sem deixar a pele pesada.",
      nota: 4.6,
    ),
    ItemCatalogo(
      nome: "Contorno em Stick",
      marca: "Vizzela",
      categoria: "Contorno",
      imagem: "assets/imagens/item5.jpg",
      minhaOpiniao:
          "Esfuma fácil e não mancha. Tom suave perfeito para devolver as sombras do rosto com muita naturalidade.",
      nota: 4.4,
    ),
    ItemCatalogo(
      nome: "Blush em Stick (Red Mocha)",
      marca: "Vizzela",
      categoria: "Blush",
      imagem: "assets/imagens/item6.jpg",
      minhaOpiniao:
          "Aquele ar de 'acordei linda e corada'! Com viço natural de saúde que fica impecável na pele.",
      nota: 4.9,
    ),
    ItemCatalogo(
      nome: "Tint Oil (Harmony)",
      marca: "Bruna Tavares",
      categoria: "Lip Tint",
      imagem: "assets/imagens/item7.jpg",
      minhaOpiniao:
          "Lábios hidratados, coradinhos e com um efeito geladinho delicioso! Dura muito na boca.",
      nota: 4.3,
    ),
    ItemCatalogo(
      nome: "Blindagem para Maquiagem",
      marca: "Catharine Hill",
      categoria: "Blindagem",
      imagem: "assets/imagens/item8.jpg",
      minhaOpiniao:
          "O segredo para shows e eventos! Deixa sua make resistente para durar a noite inteira intacta.",
      nota: 4.5,
    ),
  ];

  List<ItemCatalogo> get itens => _itens;

  List<ItemCatalogo> get favoritos =>
      _itens.where((item) => item.favorito).toList();

  List<ItemCatalogo> pesquisarProdutos(
    String termo, {
    Iterable<ItemCatalogo>? itens,
  }) {
    final termoNormalizado = _normalizar(termo);
    final itensParaPesquisar = itens ?? _itens;

    if (termoNormalizado.isEmpty) {
      return itensParaPesquisar.toList();
    }

    return itensParaPesquisar
        .where(
          (item) =>
              _normalizar(item.nome).contains(termoNormalizado) ||
              _normalizar(item.marca).contains(termoNormalizado),
        )
        .toList();
  }

  String _normalizar(String texto) {
    return texto
        .toLowerCase()
        .replaceAll(RegExp('[áàâãä]'), 'a')
        .replaceAll(RegExp('[éèêë]'), 'e')
        .replaceAll(RegExp('[íìîï]'), 'i')
        .replaceAll(RegExp('[óòôõö]'), 'o')
        .replaceAll(RegExp('[úùûü]'), 'u')
        .replaceAll('ç', 'c')
        .replaceAll('ñ', 'n')
        .trim();
  }

  int get quantidadeFavoritos => favoritos.length;

  void alternarFavorito(int index) {
    _itens[index].favorito = !_itens[index].favorito;
    notifyListeners();
  }
}

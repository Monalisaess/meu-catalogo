//molde de dados para um item do catálogo

class ItemCatalogo {
  final String nome;
  final String marca;
  final String categoria;
  final String imagem;
  final String minhaOpiniao;
  final double nota;
  bool favorito;

  ItemCatalogo({
    required this.nome,
    required this.marca,
    required this.categoria,
    required this.imagem,
    required this.minhaOpiniao,
    required this.nota,
    this.favorito = false,
  });
}

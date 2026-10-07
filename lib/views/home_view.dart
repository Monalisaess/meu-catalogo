//tela principal do aplicativo, exibe o catálogo de produtos e a marcação de favoritos

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/catalogo_viewmodel.dart';
import '../models/item_model.dart';
import '../viewmodels/auth_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _somenteFavoritos = false;
  final _campoBuscaController = TextEditingController();
  String _termoBusca = '';

  @override
  void dispose() {
    _campoBuscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Catálogo de Maquiagem"),
        backgroundColor: const Color(0xFFE75480),
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _campoBuscaController,
              onChanged: (texto) => setState(() => _termoBusca = texto),
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Pesquisar por produto ou marca',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _termoBusca.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Limpar pesquisa',
                        onPressed: () {
                          _campoBuscaController.clear();
                          setState(() => _termoBusca = '');
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => context.read<AuthViewModel>().sair(),
          ),
          Consumer<CatalogoViewModel>(
            builder: (context, viewModel, _) => IconButton(
              icon: Icon(
                _somenteFavoritos ? Icons.favorite : Icons.favorite_border,
              ),
              tooltip: "Ver favoritos (${viewModel.quantidadeFavoritos})",
              onPressed: () {
                setState(() {
                  _somenteFavoritos = !_somenteFavoritos;
                });
              },
            ),
          ),
        ],
      ),
      body: Consumer<CatalogoViewModel>(
        builder: (context, viewModel, _) {
          final itensBase =
              _somenteFavoritos ? viewModel.favoritos : viewModel.itens;
          final itensExibidos = viewModel.pesquisarProdutos(
            _termoBusca,
            itens: itensBase,
          );

          if (itensExibidos.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  _termoBusca.trim().isNotEmpty
                      ? 'Nenhum produto encontrado para "$_termoBusca".'
                      : 'Você ainda não marcou nenhum produto como favorito.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemCount: itensExibidos.length,
            itemBuilder: (context, index) {
              final item = itensExibidos[index];
              final indexOriginal = viewModel.itens.indexOf(item);

              return _CartaoItem(
                item: item,
                onFavoritar: () => viewModel.alternarFavorito(indexOriginal),
              );
            },
          );
        },
      ),
    );
  }
}

class _CartaoItem extends StatelessWidget {
  final ItemCatalogo item;
  final VoidCallback onFavoritar;

  const _CartaoItem({required this.item, required this.onFavoritar});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  item.imagem,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: onFavoritar,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      item.favorito ? Icons.favorite : Icons.favorite_border,
                      color: const Color(0xFFE75480),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.marca,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(item.nota.toString(), style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.minhaOpiniao,
                  style: const TextStyle(fontSize: 11),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

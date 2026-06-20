import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../../core/constants/app_constants.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Chargement après le build, pas pendant
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesViewModel>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FavoritesViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text('Mes Favoris',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: vm.favorites.isNotEmpty
            ? [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: () => _confirmClearAll(context, vm),
          ),
        ]
            : null,
      ),
      body: vm.favorites.isEmpty
          ? _buildEmpty()
          : ListView.separated(
        itemCount: vm.favorites.length,
        separatorBuilder: (_, __) =>
        const Divider(height: 1, color: Color(0xFF1A1A1A)),
        itemBuilder: (_, i) {
          final movie = vm.favorites[i];
          return Dismissible(
            key: Key('fav-${movie.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              color: const Color(0xFFE50914),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => vm.removeFavorite(movie.id),
            child: ListTile(
              tileColor: const Color(0xFF111111),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: AppConstants.posterUrl(movie.posterPath),
                  width: 48,
                  height: 64,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 48,
                    height: 64,
                    color: const Color(0xFF1A1A1A),
                  ),
                  errorWidget: (_, __, ___) =>
                  const Icon(Icons.movie, color: Colors.grey),
                ),
              ),
              title: Text(movie.title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text(
                '${movie.year} · ⭐ ${movie.ratingFormatted}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              onTap: () => context.push('/movie/${movie.id}'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.favorite_border, size: 80, color: Colors.grey[700]),
        const SizedBox(height: 16),
        const Text('Aucun favori',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text('Ajoutez des films depuis la fiche détail',
            style: TextStyle(color: Colors.grey)),
      ],
    ),
  );

  void _confirmClearAll(BuildContext context, FavoritesViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Supprimer tout ?',
            style: TextStyle(color: Colors.white)),
        content: const Text('Tous vos favoris seront supprimés.',
            style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              vm.clearAll();
              Navigator.pop(context);
            },
            child: const Text('Supprimer',
                style: TextStyle(color: Color(0xFFE50914))),
          ),
        ],
      ),
    );
  }
}
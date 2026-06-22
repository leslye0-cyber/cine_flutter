import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/detail_viewmodel.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/actor.dart';
import '../widgets/movie_card_netflix.dart';

class DetailScreen extends StatefulWidget {
  final int movieId;
  const DetailScreen({super.key, required this.movieId});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _synopsisExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailViewModel>().loadMovie(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetailViewModel>();

    if (vm.isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (vm.error != null) return Scaffold(body: Center(child: Text(vm.error!)));
    if (vm.movie == null) return const Scaffold(body: SizedBox());

    final movie = vm.movie!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/img.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.75),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 280,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: movie.isFavorite ? const Color(0xFF4FC3F7) : Colors.white,
                    ),
                    onPressed: vm.toggleFavorite,
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: AppConstants.backdropUrl(movie.backdropPath),
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.black26),
                    errorWidget: (_, __, ___) => Container(color: Colors.black26),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre + métadonnées
                      Text(movie.title,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      if (movie.originalTitle != movie.title)
                        Text(movie.originalTitle,
                            style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                      const SizedBox(height: 8),
                      Row(children: [
                        _chip(movie.year),
                        const SizedBox(width: 8),
                        if (movie.durationFormatted.isNotEmpty) _chip(movie.durationFormatted),
                      ]),
                      const SizedBox(height: 8),
                      // Note
                      Row(children: [
                        const Icon(Icons.star, color: Color(0xFFF0A500), size: 20),
                        const SizedBox(width: 4),
                        Text('${movie.ratingFormatted} / 10',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                        const SizedBox(width: 8),
                        Text('(${movie.voteCount} votes)',
                            style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                      ]),
                      const SizedBox(height: 16),

                      // Synopsis
                      const Text('Synopsis',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview,
                        maxLines: _synopsisExpanded ? null : 4,
                        overflow: _synopsisExpanded ? null : TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _synopsisExpanded = !_synopsisExpanded),
                        child: Text(_synopsisExpanded ? 'Voir moins' : 'Voir plus', style: const TextStyle(color: Color(0xFF4FC3F7))),
                      ),

                      // Trailer
                      if (vm.trailerKey != null) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4FC3F7),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.play_circle_outline),
                            label: const Text('Voir la bande-annonce'),
                            onPressed: () => launchUrl(
                              Uri.parse('https://youtube.com/watch?v=${vm.trailerKey}'),
                              mode: LaunchMode.externalApplication,
                            ),
                          ),
                        ),
                      ],

                      // Casting
                      if (vm.cast.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text('Casting',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 110,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: vm.cast.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (_, i) => _ActorTile(actor: vm.cast[i]),
                          ),
                        ),
                      ],

                      // Films similaires
                      if (vm.similar.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text('Films similaires',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 260,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: vm.similar.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (_, i) => MovieCardNetflix(movie: vm.similar[i]),                      ),
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white12,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white24),
    ),
    child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
  );
}

class _ActorTile extends StatelessWidget {
  final Actor actor;
  const _ActorTile({required this.actor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: actor.profilePath != null
                ? CachedNetworkImageProvider(AppConstants.profileUrl(actor.profilePath))
                : null,
            child: actor.profilePath == null
                ? Text(actor.name[0], style: const TextStyle(fontSize: 20))
                : null,
          ),
          const SizedBox(height: 4),
          Text(actor.name, maxLines: 2, overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
          Text(actor.character, maxLines: 1, overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
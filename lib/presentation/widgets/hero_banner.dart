import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/movie.dart';
import '../../core/constants/app_constants.dart';

const _pink = Color(0xFFE91E8C);
const _black = Color(0xFF0A0A0A);

class HeroBanner extends StatelessWidget {
  final Movie movie;
  const HeroBanner({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: SizedBox(
        height: 520,
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: AppConstants.backdropUrl(movie.backdropPath),
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                const ColoredBox(color: Color(0xFF1A1A1A)),
                errorWidget: (_, __, ___) => const ColoredBox(
                  color: Color(0xFF1A1A1A),
                  child: Center(
                    child: Icon(Icons.movie, color: Colors.grey, size: 60),
                  ),
                ),
              ),
            ),
            // Gradient bas
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.transparent,
                      Colors.transparent,
                      _black,
                    ],
                    stops: const [0.0, 0.3, 0.55, 1.0],
                  ),
                ),
              ),
            ),
            // Gradient gauche
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      _black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Contenu
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _pink,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'TENDANCE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Titre
                  Text(
                    movie.title.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.1,
                      shadows: [Shadow(blurRadius: 20, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Note
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: _pink, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.ratingFormatted} / 10',
                        style: const TextStyle(
                          color: _pink,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        movie.year,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Synopsis
                  Text(
                    movie.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  // Boutons
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 22),
                        label: const Text('Voir',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                        onPressed: () => context.push('/movie/${movie.id}'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                              color: Colors.white54, width: 1.5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Ma liste',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        onPressed: () {},
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.info_outline,
                              color: Colors.white),
                          onPressed: () =>
                              context.push('/movie/${movie.id}'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
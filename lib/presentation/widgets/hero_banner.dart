import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/movie.dart';
import '../../core/constants/app_constants.dart';
import '../viewmodels/favorites_viewmodel.dart';

const _pink =
Color(0xFF4FC3F7);
const _black = Color(0xFF0A0A0A);

class HeroBanner extends StatefulWidget {
  final Movie movie;
  const HeroBanner({super.key, required this.movie});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  bool _justAdded = false;

  @override
  Widget build(BuildContext context) {
    final favVm = context.watch<FavoritesViewModel>();
    final isFav = favVm.favorites.any((m) => m.id == widget.movie.id);

    return GestureDetector(
      onTap: () => context.push('/movie/${widget.movie.id}'),
      child: SizedBox(
        height: 520,
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: AppConstants.backdropUrl(widget.movie.backdropPath),
                fit: BoxFit.cover,
                placeholder: (_, __) => const ColoredBox(color: Color(0xFF1A1A1A)),
                errorWidget: (_, __, ___) => const ColoredBox(
                  color: Color(0xFF1A1A1A),
                  child: Center(child: Icon(Icons.movie, color: Colors.grey, size: 60)),
                ),
              ),
            ),
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
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [_black.withOpacity(0.5), Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                  Text(
                    widget.movie.title.toUpperCase(),
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
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: _pink, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.movie.ratingFormatted} / 10',
                        style: const TextStyle(color: _pink, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 12),
                      Text(widget.movie.year, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 22),
                        label: const Text('Voir', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        onPressed: () => context.push('/movie/${widget.movie.id}'),
                      ),
                      const SizedBox(width: 12),

                      // ── BOUTON MA LISTE FONCTIONNEL ──────────────────
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: isFav ? _pink : Colors.white54,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        icon: Icon(
                          isFav ? Icons.check : Icons.add,
                          size: 20,
                          color: isFav ? _pink : Colors.white,
                        ),
                        label: Text(
                          isFav ? 'Ajoute' : 'Ma liste',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isFav ? _pink : Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          if (isFav) {
                            await favVm.removeFavorite(widget.movie.id);
                          } else {
                            await favVm.addFavorite(widget.movie);
                          }
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFav ? 'Retire de Ma Liste' : 'Ajoute a Ma Liste',
                                ),
                                duration: const Duration(seconds: 1),
                                backgroundColor: const Color(0xFF1A1A1A),
                              ),
                            );
                          }
                        },
                      ),

                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.info_outline, color: Colors.white),
                          onPressed: () => context.push('/movie/${widget.movie.id}'),
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
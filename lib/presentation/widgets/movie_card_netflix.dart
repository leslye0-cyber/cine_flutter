import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/movie.dart';
import '../../core/constants/app_constants.dart';

class MovieCardNetflix extends StatelessWidget {
  final Movie movie;
  final double width;
  final double height;
  final bool showTitle;
  final bool showRating;
  final bool showPlayButton;

  const MovieCardNetflix({
    super.key,
    required this.movie,
    this.width = 120,
    this.height = 180,
    this.showTitle = true,
    this.showRating = false,
    this.showPlayButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  // Poster
                  Hero(
                    tag: 'movie-${movie.id}',
                    child: CachedNetworkImage(
                      imageUrl: AppConstants.posterUrl(movie.posterPath),
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: width,
                        height: height,
                        color: const Color(0xFF1A1A1A),
                        child: const Icon(Icons.movie,
                            color: Colors.grey),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: width,
                        height: height,
                        color: const Color(0xFF1A1A1A),
                        child: const Icon(Icons.broken_image,
                            color: Colors.grey),
                      ),
                    ),
                  ),

                  // Overlay play button
                  if (showPlayButton)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_filled_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),

                  // Badge note jaune
                  if (showRating)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.black, size: 10),
                            const SizedBox(width: 2),
                            Text(
                              movie.ratingFormatted,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Badge favori
                  if (movie.isFavorite)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.favorite,
                            color:
Color(0xFF4FC3F7), size: 12),
                      ),
                    ),

                  // Barre rouge bas (style Netflix)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [

Color(0xFF4FC3F7),
                            Color(0xFF81D4FA),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (showTitle) ...[
              const SizedBox(height: 6),
              Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                movie.year,
                style: const TextStyle(
                    color: Colors.grey, fontSize: 11),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
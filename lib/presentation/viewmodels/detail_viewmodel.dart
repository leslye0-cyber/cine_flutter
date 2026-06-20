import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/models/actor.dart';
import '../../data/repositories/movie_repository.dart';

class DetailViewModel extends ChangeNotifier {
  final MovieRepository _repo;

  Movie? movie;
  List<Actor> cast = [];
  List<Movie> similar = [];
  String? trailerKey;
  bool isLoading = false;
  String? error;

  DetailViewModel(this._repo);

  Future<void> loadMovie(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repo.getMovieDetail(id),
        _repo.getMovieCredits(id),
        _repo.getSimilarMovies(id),
        _repo.getTrailerKey(id),
      ]);
      movie = results[0] as Movie;
      cast = results[1] as List<Actor>;
      similar = results[2] as List<Movie>;
      trailerKey = results[3] as String?;
    } catch (e) {
      error = 'Impossible de charger le film';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    if (movie == null) return;
    if (movie!.isFavorite) {
      await _repo.removeFavorite(movie!.id);
      movie = movie!.copyWith(isFavorite: false);
    } else {
      await _repo.addFavorite(movie!);
      movie = movie!.copyWith(isFavorite: true);
    }
    notifyListeners();
  }
}
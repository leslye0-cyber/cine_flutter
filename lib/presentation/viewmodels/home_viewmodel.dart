import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/models/genre.dart';
import '../../data/repositories/movie_repository.dart';

enum ViewState { idle, loading, loaded, error }

class HomeViewModel extends ChangeNotifier {
  final MovieRepository _repo;

  ViewState state = ViewState.idle;
  String? errorMessage;

  List<Movie> popularMovies = [];
  List<Movie> trendingMovies = [];
  List<Movie> upcomingMovies = [];
  List<Genre> genres = [];
  List<Movie> genreMovies = [];

  int _popularPage = 1;
  bool hasMorePopular = true;

  HomeViewModel(this._repo) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    state = ViewState.loading;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repo.getPopularMovies(),
        _repo.getTrendingMovies(),
        _repo.getUpcomingMovies(),
        _repo.getGenres(),
      ]);
      popularMovies = results[0] as List<Movie>;
      trendingMovies = results[1] as List<Movie>;
      upcomingMovies = results[2] as List<Movie>;
      genres = results[3] as List<Genre>;
      state = ViewState.loaded;
    } catch (e) {
      state = ViewState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> loadMorePopular() async {
    if (!hasMorePopular) return;
    _popularPage++;
    try {
      final more = await _repo.getPopularMovies(page: _popularPage);
      if (more.isEmpty) {
        hasMorePopular = false;
      } else {
        popularMovies = [...popularMovies, ...more];
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> loadByGenre(int genreId) async {
    genreMovies = [];
    notifyListeners();
    try {
      genreMovies = await _repo.getMoviesByGenre(genreId);
    } catch (_) {}
    notifyListeners();
  }

  Future<void> refresh() async {
    _popularPage = 1;
    hasMorePopular = true;
    genreMovies = [];
    await loadInitialData();
  }
}
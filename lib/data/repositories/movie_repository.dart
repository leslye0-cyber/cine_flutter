import '../models/movie.dart';
import '../models/actor.dart';
import '../models/genre.dart';
import '../models/tv_show.dart';
import '../services/tmdb_api_service.dart';
import '../services/local/hive_service.dart';

class MovieRepository {
  final TmdbApiService _api;
  final HiveService _hive;

  MovieRepository(this._api, this._hive);

  // Films
  Future<List<Movie>> getPopularMovies({int page = 1}) async =>
      _markFavorites(await _api.getPopularMovies(page: page));

  Future<List<Movie>> getTrendingMovies() async =>
      _markFavorites(await _api.getTrendingMovies());

  Future<List<Movie>> getUpcomingMovies({int page = 1}) async =>
      _markFavorites(await _api.getUpcomingMovies(page: page));

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async =>
      _markFavorites(await _api.searchMovies(query, page: page));

  Future<Movie> getMovieDetail(int id) async {
    final movie = await _api.getMovieDetail(id);
    return movie.copyWith(isFavorite: _hive.isFavorite(id));
  }

  Future<List<Actor>> getMovieCredits(int id) => _api.getMovieCredits(id);
  Future<String?> getTrailerKey(int id) => _api.getTrailerKey(id);

  Future<List<Movie>> getSimilarMovies(int id) async =>
      _markFavorites(await _api.getSimilarMovies(id));

  Future<List<Genre>> getGenres() => _api.getGenres();

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async =>
      _markFavorites(await _api.getMoviesByGenre(genreId, page: page));

  // Séries
  Future<List<TvShow>> getPopularTvShows({int page = 1}) =>
      _api.getPopularTvShows(page: page);

  Future<List<TvShow>> getTrendingTvShows() => _api.getTrendingTvShows();

  Future<List<TvShow>> searchTvShows(String query) =>
      _api.searchTvShows(query);

  Future<Map<String, dynamic>> searchMulti(String query) =>
      _api.searchMulti(query);

  // Favoris
  List<Movie> getFavorites() => _hive.getFavorites();
  bool isFavorite(int id) => _hive.isFavorite(id);
  Future<void> addFavorite(Movie m) => _hive.addFavorite(m);
  Future<void> removeFavorite(int id) => _hive.removeFavorite(id);
  Future<void> clearFavorites() => _hive.clearAll();

  List<Movie> _markFavorites(List<Movie> movies) =>
      movies.map((m) => m.copyWith(isFavorite: _hive.isFavorite(m.id))).toList();
}
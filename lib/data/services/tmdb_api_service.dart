import 'package:dio/dio.dart';
import '../models/movie.dart';
import '../models/actor.dart';
import '../models/genre.dart';
import '../models/tv_show.dart';
import '../../core/constants/app_constants.dart';

class TmdbApiService {
  late final Dio _dio;

  TmdbApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Intercepteur pour ajouter la clé API à chaque requête
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = AppConstants.apiKey;
          options.queryParameters['language'] = 'fr-FR';
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  // ── FILMS ──────────────────────────────────────────────────────────────
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final res = await _dio.get(
      '/movie/popular',
      queryParameters: {'page': page},
    );
    return _parseMovies(res.data);
  }

  Future<List<Movie>> getTrendingMovies({String period = 'week'}) async {
    final res = await _dio.get('/trending/movie/$period');
    return _parseMovies(res.data);
  }

  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final res = await _dio.get(
      '/movie/upcoming',
      queryParameters: {'page': page},
    );
    return _parseMovies(res.data);
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final res = await _dio.get(
      '/search/movie',
      queryParameters: {'query': query, 'page': page},
    );
    return _parseMovies(res.data);
  }

  Future<Movie> getMovieDetail(int id) async {
    final res = await _dio.get('/movie/$id');
    return Movie.fromJson(res.data as Map<String, dynamic>);
  }

  Future<List<Actor>> getMovieCredits(int id) async {
    final res = await _dio.get('/movie/$id/credits');
    final cast = res.data['cast'] as List<dynamic>? ?? [];
    return cast
        .take(10)
        .map((e) => Actor.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<String?> getTrailerKey(int id) async {
    final res = await _dio.get('/movie/$id/videos');
    final results = res.data['results'] as List<dynamic>? ?? [];
    final trailer = results.firstWhere(
          (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
      orElse: () => null,
    );
    return trailer?['key'] as String?;
  }

  Future<List<Movie>> getSimilarMovies(int id) async {
    final res = await _dio.get('/movie/$id/similar');
    return _parseMovies(res.data);
  }

  Future<List<Genre>> getGenres() async {
    final res = await _dio.get('/genre/movie/list');
    final genres = res.data['genres'] as List<dynamic>? ?? [];
    return genres
        .map((e) => Genre.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    final res = await _dio.get(
      '/discover/movie',
      queryParameters: {
        'with_genres': genreId,
        'page': page,
        'sort_by': 'popularity.desc',
      },
    );
    return _parseMovies(res.data);
  }

  // ── SERIES TV ──────────────────────────────────────────────────────────
  Future<List<TvShow>> getPopularTvShows({int page = 1}) async {
    final res = await _dio.get(
      '/tv/popular',
      queryParameters: {'page': page},
    );
    return _parseTvShows(res.data);
  }

  Future<List<TvShow>> getTrendingTvShows() async {
    final res = await _dio.get('/trending/tv/week');
    return _parseTvShows(res.data);
  }

  Future<List<TvShow>> searchTvShows(String query, {int page = 1}) async {
    final res = await _dio.get(
      '/search/tv',
      queryParameters: {'query': query, 'page': page},
    );
    return _parseTvShows(res.data);
  }

  Future<Map<String, dynamic>> searchMulti(String query) async {
    final results = await Future.wait([
      searchMovies(query),
      searchTvShows(query),
    ]);
    return {
      'movies': results[0] as List<Movie>,
      'tvShows': results[1] as List<TvShow>,
    };
  }

  // ── PARSERS ────────────────────────────────────────────────────────────
  List<Movie> _parseMovies(dynamic data) {
    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<TvShow> _parseTvShows(dynamic data) {
    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => TvShow.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
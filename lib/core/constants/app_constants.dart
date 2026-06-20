import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Cle API TMDB - lue depuis le fichier .env
  static String get apiKey {
    final key = dotenv.env['TMDB_API_KEY'] ?? '';
    if (key.isEmpty) {
      throw Exception('TMDB_API_KEY manquant dans .env');
    }
    return key;
  }

  static String get baseUrl =>
      dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';

  static String get imageUrl =>
      dotenv.env['TMDB_IMAGE_URL'] ?? 'https://image.tmdb.org/t/p/';

  // URLs images
  static String posterUrl(String? path) =>
      path != null && path.isNotEmpty ? '${imageUrl}w500$path' : '';

  static String backdropUrl(String? path) =>
      path != null && path.isNotEmpty ? '${imageUrl}w1280$path' : '';

  static String profileUrl(String? path) =>
      path != null && path.isNotEmpty ? '${imageUrl}w185$path' : '';

  // Config
  static const int searchDebounceMs = 500;
  static const int maxSearchHistory = 10;
  static const String favoritesBox = 'favorites';
  static const String themeKey = 'theme_mode';
  static const String searchHistoryKey = 'search_history';
}
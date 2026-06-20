import 'package:hive_flutter/hive_flutter.dart';
import '../../models/movie.dart';
import '../../../core/constants/app_constants.dart';

class HiveService {
  Box<Movie> get _box => Hive.box<Movie>(AppConstants.favoritesBox);

  List<Movie> getFavorites() => _box.values.toList();
  bool isFavorite(int movieId) => _box.containsKey(movieId);

  Future<void> addFavorite(Movie movie) async {
    await _box.put(movie.id, movie.copyWith(isFavorite: true));
  }

  Future<void> removeFavorite(int movieId) async {
    await _box.delete(movieId);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
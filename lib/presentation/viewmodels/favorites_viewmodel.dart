import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';

class FavoritesViewModel extends ChangeNotifier {
  final MovieRepository _repo;
  List<Movie> favorites = [];

  FavoritesViewModel(this._repo) {
    loadFavorites();
  }

  void loadFavorites() {
    favorites = _repo.getFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(Movie movie) async {
    await _repo.addFavorite(movie);
    loadFavorites();
  }

  Future<void> removeFavorite(int id) async {
    await _repo.removeFavorite(id);
    loadFavorites();
  }

  Future<void> clearAll() async {
    await _repo.clearFavorites();
    loadFavorites();
  }

  bool isFavorite(int id) => favorites.any((m) => m.id == id);
}
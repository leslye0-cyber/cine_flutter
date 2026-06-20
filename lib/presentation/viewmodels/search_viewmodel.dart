import 'package:flutter/material.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import '../../data/models/movie.dart';
import '../../data/models/tv_show.dart';
import '../../data/repositories/movie_repository.dart';
import '../../core/constants/app_constants.dart';

enum SearchType { all, movies, tvShows }

class SearchViewModel extends ChangeNotifier {
  final MovieRepository _repo;
  final SpeechToText _speech = SpeechToText();
  Timer? _debounce;

  List<Movie> movieResults = [];
  List<TvShow> tvResults = [];
  bool isLoading = false;
  String? error;
  String currentQuery = '';
  SearchType searchType = SearchType.all;

  // Vocal
  bool isListening = false;
  bool speechAvailable = false;
  String voiceStatus = '';

  SearchViewModel(this._repo) {
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    speechAvailable = await _speech.initialize(
      onError: (e) {
        isListening = false;
        voiceStatus = 'Erreur microphone';
        notifyListeners();
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          isListening = false;
          notifyListeners();
        }
      },
    );
    notifyListeners();
  }

  Future<void> startListening(Function(String) onResult) async {
    if (!speechAvailable) {
      voiceStatus = 'Microphone non disponible';
      notifyListeners();
      return;
    }
    isListening = true;
    voiceStatus = 'Écoute en cours...';
    notifyListeners();

    await _speech.listen(
      onResult: (result) {
        final words = result.recognizedWords;
        if (words.isNotEmpty) {
          onResult(words);
          if (result.finalResult) {
            isListening = false;
            voiceStatus = '';
            notifyListeners();
            onQueryChanged(words);
          }
        }
      },
      localeId: 'fr_FR',
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
    isListening = false;
    voiceStatus = '';
    notifyListeners();
  }

  void setSearchType(SearchType type) {
    searchType = type;
    notifyListeners();
    if (currentQuery.isNotEmpty) _search(currentQuery);
  }

  void onQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      Duration(milliseconds: AppConstants.searchDebounceMs),
          () => _search(query),
    );
  }

  Future<void> _search(String query) async {
    currentQuery = query.trim();
    if (currentQuery.isEmpty) {
      movieResults = [];
      tvResults = [];
      notifyListeners();
      return;
    }
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      switch (searchType) {
        case SearchType.movies:
          movieResults = await _repo.searchMovies(currentQuery);
          tvResults = [];
          break;
        case SearchType.tvShows:
          tvResults = await _repo.searchTvShows(currentQuery);
          movieResults = [];
          break;
        case SearchType.all:
          final res = await _repo.searchMulti(currentQuery);
          movieResults = res['movies'] as List<Movie>;
          tvResults = res['tvShows'] as List<TvShow>;
          break;
      }
    } catch (e) {
      error = 'Erreur de recherche';
      movieResults = [];
      tvResults = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void clear() {
    movieResults = [];
    tvResults = [];
    currentQuery = '';
    error = null;
    notifyListeners();
  }

  bool get hasResults => movieResults.isNotEmpty || tvResults.isNotEmpty;

  @override
  void dispose() {
    _debounce?.cancel();
    _speech.stop();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

class PrefsService extends ChangeNotifier {
  List<String> _searchHistory = [];

  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _searchHistory = prefs.getStringList(AppConstants.searchHistoryKey) ?? [];
    notifyListeners();
  }

  Future<void> addSearchHistory(String query) async {
    _searchHistory.remove(query);
    _searchHistory.insert(0, query);
    if (_searchHistory.length > AppConstants.maxSearchHistory) {
      _searchHistory = _searchHistory.sublist(0, AppConstants.maxSearchHistory);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(AppConstants.searchHistoryKey, _searchHistory);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _searchHistory = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.searchHistoryKey);
    notifyListeners();
  }
}
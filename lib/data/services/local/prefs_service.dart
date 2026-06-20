import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

class PrefsService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  List<String> _searchHistory = [];

  ThemeMode get themeMode => _themeMode;
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(AppConstants.themeKey);
    if (savedTheme == 'dark') _themeMode = ThemeMode.dark;
    if (savedTheme == 'light') _themeMode = ThemeMode.light;
    _searchHistory = prefs.getStringList(AppConstants.searchHistoryKey) ?? [];
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.themeKey,
        _themeMode == ThemeMode.dark ? 'dark' : 'light');
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
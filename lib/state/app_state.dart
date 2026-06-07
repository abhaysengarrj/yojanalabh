import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final Set<int> _favoriteIds = {};

  ThemeMode get themeMode => _themeMode;
  Set<int> get favoriteIds => Set.unmodifiable(_favoriteIds);
  bool get isDark => _themeMode == ThemeMode.dark;

  AppState() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final favs = prefs.getStringList('favorites') ?? [];
    _favoriteIds.addAll(favs.map((e) => int.parse(e)));
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDark);
  }

  bool isFavorite(int schemeId) => _favoriteIds.contains(schemeId);

  Future<void> toggleFavorite(int schemeId) async {
    if (_favoriteIds.contains(schemeId)) {
      _favoriteIds.remove(schemeId);
    } else {
      _favoriteIds.add(schemeId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorites',
      _favoriteIds.map((e) => e.toString()).toList(),
    );
  }
}

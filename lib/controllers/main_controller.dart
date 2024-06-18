/// Contains home controller for all app data.
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller for the main app.
///
/// Responsible for loading the app data from disk on startup and controlling the global theme mode.
///
/// Note: this class is a singleton so that all the variables can be accessed by the controllers.
class MainController extends ChangeNotifier {
  MainController._privateConstructor();

  static final MainController _instance = MainController._privateConstructor();

  static MainController get instance => _instance;

  /// Theme mode to use.
  ///
  /// - `0` : System
  /// - `1` : Light
  /// - `2` : Dark
  int themeMode = 0;

  /// Prevents the app data from being loaded again when the app is refreshed.
  static bool dataLoaded = false;

  /// Used to set the theme mode of the entire app.
  ///
  /// `0` for system mode, `1` for light mode, `2` for dark mode.
  void setThemeMode(int value) {
    themeMode = value;
    _saveThemeMode();
    notifyListeners();
  }

  /// Load data from disk.
  ///
  /// Returns 0 on success.
  Future<int> loadData() async {
    if (dataLoaded) {
      return 0;
    }

    final prefs = await SharedPreferences.getInstance();

    /// Load any data from shared preferences here
    /// ==========================================

    themeMode = prefs.getInt("themeMode") ?? 0;
    setThemeMode(themeMode);

    notifyListeners();

    dataLoaded = true;

    return 0;
  }

  /// Used to save the theme mode to disk.
  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt("themeMode", themeMode);
  }

  /// Clear all app data stored on shared preferences.
  void clearAppData() async {
    /// Clear any variables here:

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

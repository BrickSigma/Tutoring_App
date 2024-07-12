/// Contains home controller for all app data.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutoring_app/models/user.dart';

/// Controller for the main app.
///
/// Responsible for loading the app data from disk on startup and controlling the global theme mode.
///
/// Note: this class is a singleton so that all the variables can be accessed by the controllers.
class MainController extends ChangeNotifier {
  MainController._privateConstructor();

  // Singleton instance of the main controller class.
  static final MainController _instance = MainController._privateConstructor();

  static MainController get instance => _instance;

  /// Page index used to switch between login, tutor, and student pages.
  ValueNotifier<int> pageIndex = ValueNotifier(0);

  UserModel user = UserModel(uid: null);

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

    /// Load any data from Firebase here
    /// ==========================================
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      this.user = UserModel(uid: user.uid);
      await this.user.initialize();
      if (this.user.isTutor()) {
        pageIndex.value = 3;
      } else {
        pageIndex.value = 4;
      }
    }

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
  Future<void> clearAppData() async {
    /// Clear any variables here:
    dataLoaded = false;
    user = UserModel(uid: null);
    await user.initialize();
    pageIndex.value = 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

import 'package:flutter/material.dart';

/// Provider for managing theme state across the application
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Whether the current theme is dark
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Whether the current theme is light
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Whether the current theme follows system settings
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Set theme mode to light
  void setLightMode() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  /// Set theme mode to dark
  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  /// Set theme mode to follow system settings
  void setSystemMode() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  /// Toggle between light and dark mode
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setDarkMode();
    } else {
      setLightMode();
    }
  }

  /// Set theme mode directly
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

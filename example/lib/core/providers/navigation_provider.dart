import 'package:flutter/material.dart';

/// Navigation destinations for the app
enum NavigationDestinations {
  home(0, 'Home', '/'),
  components(1, 'Components', '/components'),
  playground(2, 'Playground', '/playground'),
  examples(3, 'Examples', '/examples'),
  settings(4, 'Settings', '/settings');

  const NavigationDestinations(this.navIndex, this.label, this.route);

  final int navIndex;
  final String label;
  final String route;

  static NavigationDestinations fromIndex(int index) {
    return NavigationDestinations.values.firstWhere(
      (destination) => destination.navIndex == index,
      orElse: () => NavigationDestinations.home,
    );
  }

  static NavigationDestinations fromRoute(String route) {
    return NavigationDestinations.values.firstWhere(
      (destination) => destination.route == route,
      orElse: () => NavigationDestinations.home,
    );
  }
}

/// Provider for managing navigation state with deep linking support
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  String _currentRoute = '/';
  bool _isNavigating = false;

  /// Current selected index in the bottom navigation
  int get currentIndex => _currentIndex;

  /// Current route path
  String get currentRoute => _currentRoute;

  /// Whether navigation is in progress
  bool get isNavigating => _isNavigating;

  /// Current navigation destination
  NavigationDestinations get currentDestination =>
      NavigationDestinations.fromIndex(_currentIndex);

  /// Set the current navigation index
  void setCurrentIndex(int index) {
    if (_currentIndex != index && !_isNavigating) {
      _isNavigating = true;
      _currentIndex = index;
      _currentRoute = NavigationDestinations.fromIndex(index).route;
      notifyListeners();

      // Reset navigation state after a brief delay
      Future.delayed(const Duration(milliseconds: 100), () {
        _isNavigating = false;
        notifyListeners();
      });
    }
  }

  /// Set the current route (used by router)
  void setCurrentRoute(String route) {
    if (_currentRoute != route) {
      _currentRoute = route;
      _currentIndex = NavigationDestinations.fromRoute(route).navIndex;
      notifyListeners();
    }
  }

  /// Navigate to home screen
  void goToHome() => setCurrentIndex(0);

  /// Navigate to components screen
  void goToComponents() => setCurrentIndex(1);

  /// Navigate to playground screen
  void goToPlayground() => setCurrentIndex(2);

  /// Navigate to examples screen
  void goToExamples() => setCurrentIndex(3);

  /// Navigate to settings screen
  void goToSettings() => setCurrentIndex(4);

  /// Get the name of the current screen
  String get currentScreenName => currentDestination.label;

  /// Get the icon for a specific index
  IconData getIcon(int index, {bool selected = false}) {
    switch (index) {
      case 0:
        return selected ? Icons.home : Icons.home_outlined;
      case 1:
        return selected ? Icons.widgets : Icons.widgets_outlined;
      case 2:
        return selected ? Icons.tune : Icons.tune_outlined;
      case 3:
        return selected ? Icons.apps : Icons.apps_outlined;
      case 4:
        return selected ? Icons.settings : Icons.settings_outlined;
      default:
        return Icons.help_outline;
    }
  }

  /// Check if a specific index is currently selected
  bool isSelected(int index) => _currentIndex == index;

  /// Get all navigation destinations
  List<NavigationDestinations> get allDestinations =>
      NavigationDestinations.values;
}

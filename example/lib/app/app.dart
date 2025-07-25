import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/providers/navigation_provider.dart';

/// Main application widget with bottom navigation and Material 3 styling
class ShowcaseMainApp extends StatelessWidget {
  final Widget child;

  const ShowcaseMainApp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, _) {
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationProvider.currentIndex,
            onDestinationSelected: (index) {
              if (!navigationProvider.isNavigating) {
                navigationProvider.setCurrentIndex(index);
                _navigateToIndex(context, index);
              }
            },
            elevation: 8,
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
            surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
            shadowColor: Theme.of(
              context,
            ).colorScheme.shadow.withValues(alpha: 0.1),
            animationDuration: const Duration(milliseconds: 350),
            destinations: navigationProvider.allDestinations.map((destination) {
              final isSelected = navigationProvider.isSelected(
                destination.navIndex,
              );
              return NavigationDestination(
                icon: Icon(
                  navigationProvider.getIcon(
                    destination.navIndex,
                    selected: false,
                  ),
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                selectedIcon: Icon(
                  navigationProvider.getIcon(
                    destination.navIndex,
                    selected: true,
                  ),
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                label: destination.label,
                tooltip: 'Navigate to ${destination.label}',
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Navigate to the appropriate route based on index
  void _navigateToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed('home');
        break;
      case 1:
        context.goNamed('components');
        break;
      case 2:
        context.goNamed('playground');
        break;
      case 3:
        context.goNamed('examples');
        break;
      case 4:
        context.goNamed('settings');
        break;
    }
  }
}

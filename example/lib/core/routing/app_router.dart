import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/app.dart';
import '../../features/home/home_screen.dart';
import '../../features/components/components_screen.dart';
import '../../features/playground/playground_screen.dart';
import '../../features/examples/examples_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../providers/navigation_provider.dart';

/// Application router configuration with deep linking support
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ShowcaseMainApp(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) =>
                _buildPageWithTransition(context, state, const HomeScreen(), 0),
          ),
          GoRoute(
            path: '/components',
            name: 'components',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const ComponentsScreen(),
              1,
            ),
          ),
          GoRoute(
            path: '/playground',
            name: 'playground',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const PlaygroundScreen(),
              2,
            ),
          ),
          GoRoute(
            path: '/examples',
            name: 'examples',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const ExamplesScreen(),
              3,
            ),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const SettingsScreen(),
              4,
            ),
          ),
        ],
      ),
    ],
  );

  /// Build page with custom transition animation
  static Page<dynamic> _buildPageWithTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
    int index,
  ) {
    // Update navigation provider when route changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigationProvider = context.read<NavigationProvider>();
      navigationProvider.setCurrentRoute(state.fullPath ?? '/');
    });

    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Different animations based on navigation direction
        const curve = Curves.easeInOutCubic;
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
          reverseCurve: curve.flipped,
        );

        // Fade transition with subtle slide
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// Get route name from path
  static String getRouteNameFromPath(String path) {
    switch (path) {
      case '/':
        return 'home';
      case '/components':
        return 'components';
      case '/playground':
        return 'playground';
      case '/examples':
        return 'examples';
      case '/settings':
        return 'settings';
      default:
        return 'unknown';
    }
  }

  /// Get index from route name
  static int getIndexFromRouteName(String routeName) {
    switch (routeName) {
      case 'home':
        return 0;
      case 'components':
        return 1;
      case 'playground':
        return 2;
      case 'examples':
        return 3;
      case 'settings':
        return 4;
      default:
        return 0;
    }
  }
}

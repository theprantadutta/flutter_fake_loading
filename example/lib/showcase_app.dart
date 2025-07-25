import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/navigation_provider.dart';
import 'core/providers/accessibility_provider.dart';
import 'core/routing/app_router.dart';
import 'core/services/focus_service.dart';
import 'core/services/memory_manager.dart';
import 'core/services/preloader_service.dart';
import 'core/services/sound_service.dart';

/// Entry point for the comprehensive showcase application
class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  @override
  void initState() {
    super.initState();

    // Initialize performance services
    MemoryManager().initialize();

    // Initialize sound service
    SoundService.instance.setSoundEnabled(true);
    SoundService.instance.setVolume(0.7);

    // Preload common components after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PreloaderService().preloadCommonComponents();

      // Play app launch sound
      SoundService.instance.playDemoStart();
    });
  }

  @override
  void dispose() {
    // Clean up performance services
    MemoryManager().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
      ],
      child: Consumer2<ThemeProvider, AccessibilityProvider>(
        builder: (context, themeProvider, accessibilityProvider, child) {
          return KeyboardNavigationWrapper(
            enabled: accessibilityProvider.keyboardNavigation,
            child: MaterialApp.router(
              title: 'Flutter Fake Loading Showcase',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              routerConfig: AppRouter.router,
              builder: (context, child) {
                // Apply text scaling based on accessibility settings
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(
                      accessibilityProvider.textScaleFactor,
                    ),
                  ),
                  child: child!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

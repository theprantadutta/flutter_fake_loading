import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/data/demo_helpers.dart';
import '../../../../core/utils/code_generator.dart';

/// Demonstrates FakeLoadingScreen theming and customization options.
class ThemeDemo extends StatelessWidget {
  const ThemeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Theming & Customization',
          subtitle: 'Background colors, text colors, and visual themes',
        ),
        const SizedBox(height: 16),

        // Dark theme demo
        DemoCard(
          title: 'Dark Theme',
          description: 'Dark background with light text and green accents',
          child: const _DarkThemeDemo(),
          codeSnippet: CodeGenerator.generateFakeLoadingScreenCode(
            messages: DemoHelpers.gamingMessages,
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.black,
            textColor: Colors.white,
            progressColor: Colors.green,
            showProgress: true,
          ),
        ),
        const SizedBox(height: 16),

        // Colorful theme demo
        DemoCard(
          title: 'Colorful Theme',
          description: 'Custom colors for a vibrant loading experience',
          child: const _ColorfulThemeDemo(),
          codeSnippet: CodeGenerator.generateFakeLoadingScreenCode(
            messages: DemoHelpers.creativeMessages,
            duration: const Duration(seconds: 4),
            backgroundColor: const Color(0xFF1A1B3A),
            textColor: const Color(0xFFE8E8FF),
            progressColor: const Color(0xFF6C5CE7),
            showProgress: true,
          ),
        ),
        const SizedBox(height: 16),

        // Material theme demo
        DemoCard(
          title: 'Material Theme Integration',
          description: 'Uses current Material theme colors automatically',
          child: const _MaterialThemeDemo(),
          codeSnippet: CodeGenerator.generateFakeLoadingScreenCode(
            messages: DemoHelpers.basicMessages,
            duration: const Duration(seconds: 4),
            showProgress: true,
          ),
        ),
      ],
    );
  }
}

class _DarkThemeDemo extends StatelessWidget {
  const _DarkThemeDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Dark theme preview
              Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Loading epic adventure...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Green progress bar
                      Container(
                        width: 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.7,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Demo button overlay
              Positioned(
                top: 8,
                right: 8,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _showFullScreenDemo(context, _buildDarkScreen),
                  icon: const Icon(Icons.fullscreen, size: 16),
                  label: const Text('Demo'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 32),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDarkScreen() {
    return FakeLoadingScreen(
      messages: DemoHelpers.gamingMessages,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.black,
      textColor: Colors.white,
      progressColor: Colors.green,
      showProgress: true,
      onComplete: () {},
    );
  }
}

class _ColorfulThemeDemo extends StatelessWidget {
  const _ColorfulThemeDemo();

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1A1B3A);
    const textColor = Color(0xFFE8E8FF);
    const progressColor = Color(0xFF6C5CE7);

    return SizedBox(
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Colorful theme preview
              Container(
                color: backgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Crafting digital magic...',
                        style: TextStyle(color: textColor, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Purple progress bar
                      Container(
                        width: 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: backgroundColor.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: progressColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Demo button overlay
              Positioned(
                top: 8,
                right: 8,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _showFullScreenDemo(context, _buildColorfulScreen),
                  icon: const Icon(Icons.fullscreen, size: 16),
                  label: const Text('Demo'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 32),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorfulScreen() {
    return FakeLoadingScreen(
      messages: DemoHelpers.creativeMessages,
      duration: const Duration(seconds: 4),
      backgroundColor: const Color(0xFF1A1B3A),
      textColor: const Color(0xFFE8E8FF),
      progressColor: const Color(0xFF6C5CE7),
      showProgress: true,
      onComplete: () {},
    );
  }
}

class _MaterialThemeDemo extends StatelessWidget {
  const _MaterialThemeDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Material theme preview
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Syncing with the cloud...',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Material progress bar
                      Container(
                        width: 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Demo button overlay
              Positioned(
                top: 8,
                right: 8,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _showFullScreenDemo(context, _buildMaterialScreen),
                  icon: const Icon(Icons.fullscreen, size: 16),
                  label: const Text('Demo'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 32),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialScreen() {
    return FakeLoadingScreen(
      messages: DemoHelpers.basicMessages,
      duration: const Duration(seconds: 4),
      showProgress: true,
      onComplete: () {},
    );
  }
}

/// Helper function to show full-screen loading demo
void _showFullScreenDemo(
  BuildContext context,
  Widget Function() screenBuilder,
) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) =>
          _FullScreenDemoWrapper(screenBuilder: screenBuilder),
    ),
  );
}

/// Wrapper for full-screen demos that handles completion and navigation
class _FullScreenDemoWrapper extends StatefulWidget {
  final Widget Function() screenBuilder;

  const _FullScreenDemoWrapper({required this.screenBuilder});

  @override
  State<_FullScreenDemoWrapper> createState() => _FullScreenDemoWrapperState();
}

class _FullScreenDemoWrapperState extends State<_FullScreenDemoWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The actual loading screen demo
          widget.screenBuilder(),
          // Back button overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          // Auto-close after demo completes
          FutureBuilder(
            future: Future.delayed(const Duration(seconds: 5)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                });
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

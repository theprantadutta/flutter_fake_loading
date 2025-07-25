import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/data/demo_helpers.dart';
import '../../../../core/utils/code_generator.dart';

/// Demonstrates basic FakeLoadingScreen usage with different configurations.
class BasicScreenDemo extends StatelessWidget {
  const BasicScreenDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Basic Usage',
          subtitle: 'Simple full-screen loading examples',
        ),
        const SizedBox(height: 16),

        // Simple loading screen
        DemoCard(
          title: 'Simple Loading Screen',
          description: 'Basic full-screen loading with default styling',
          child: const _SimpleLoadingDemo(),
          codeSnippet: CodeGenerator.generateFakeLoadingScreenCode(
            messages: DemoHelpers.basicMessages,
            duration: const Duration(seconds: 3),
          ),
        ),
        const SizedBox(height: 16),

        // With progress indicator
        DemoCard(
          title: 'With Progress Indicator',
          description: 'Loading screen with progress bar',
          child: const _ProgressLoadingDemo(),
          codeSnippet: CodeGenerator.generateFakeLoadingScreenCode(
            messages: DemoHelpers.basicMessages,
            duration: const Duration(seconds: 4),
            showProgress: true,
          ),
        ),
        const SizedBox(height: 16),

        // Duration-based demo
        DemoCard(
          title: 'Duration-Based Loading',
          description: 'Fixed duration with evenly distributed messages',
          child: const _DurationLoadingDemo(),
          codeSnippet: CodeGenerator.generateFakeLoadingScreenCode(
            messages: DemoHelpers.techStartupMessages,
            duration: const Duration(seconds: 5),
            showProgress: true,
          ),
        ),
      ],
    );
  }
}

class _SimpleLoadingDemo extends StatelessWidget {
  const _SimpleLoadingDemo();

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
              // Simulated loading screen preview
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading awesome content...',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
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
                      _showFullScreenDemo(context, _buildSimpleScreen),
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

  Widget _buildSimpleScreen() {
    return FakeLoadingScreen(
      messages: DemoHelpers.basicMessages,
      duration: const Duration(seconds: 3),
      onComplete: () {}, // Will be handled by demo navigation
    );
  }
}

class _ProgressLoadingDemo extends StatelessWidget {
  const _ProgressLoadingDemo();

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
              // Simulated loading screen preview
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Initializing quantum processors...',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Progress bar preview
                      Container(
                        width: 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.6,
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
                      _showFullScreenDemo(context, _buildProgressScreen),
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

  Widget _buildProgressScreen() {
    return FakeLoadingScreen(
      messages: DemoHelpers.basicMessages,
      duration: const Duration(seconds: 4),
      showProgress: true,
      onComplete: () {}, // Will be handled by demo navigation
    );
  }
}

class _DurationLoadingDemo extends StatelessWidget {
  const _DurationLoadingDemo();

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
              // Simulated loading screen preview
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Disrupting the industry...',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Progress bar preview
                      Container(
                        width: 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '5 second duration',
                        style: Theme.of(context).textTheme.bodySmall,
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
                      _showFullScreenDemo(context, _buildDurationScreen),
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

  Widget _buildDurationScreen() {
    return FakeLoadingScreen(
      messages: DemoHelpers.techStartupMessages,
      duration: const Duration(seconds: 5),
      showProgress: true,
      onComplete: () {}, // Will be handled by demo navigation
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
            future: Future.delayed(const Duration(seconds: 6)),
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

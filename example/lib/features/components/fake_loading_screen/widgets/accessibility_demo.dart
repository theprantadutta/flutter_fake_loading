import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';

/// Demonstrates FakeLoadingScreen accessibility features.
class AccessibilityDemo extends StatelessWidget {
  const AccessibilityDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Accessibility Features',
          subtitle:
              'Screen reader support, high contrast, and keyboard navigation',
        ),
        const SizedBox(height: 16),

        // Screen reader demo
        DemoCard(
          title: 'Screen Reader Support',
          description: 'Proper semantic labels and announcements',
          child: const _ScreenReaderDemo(),
          codeSnippet: _generateScreenReaderCode(),
        ),
        const SizedBox(height: 16),

        // High contrast demo
        DemoCard(
          title: 'High Contrast Mode',
          description: 'Enhanced visibility for accessibility',
          child: const _HighContrastDemo(),
          codeSnippet: _generateHighContrastCode(),
        ),
        const SizedBox(height: 16),

        // Focus management demo
        DemoCard(
          title: 'Focus Management',
          description: 'Proper focus handling during loading',
          child: const _FocusManagementDemo(),
          codeSnippet: _generateFocusManagementCode(),
        ),
      ],
    );
  }

  String _generateScreenReaderCode() {
    return '''FakeLoadingScreen(
  messages: ['Loading content...', 'Please wait...'],
  duration: Duration(seconds: 4),
  showProgress: true,
  // Screen readers will announce loading messages
  // and progress updates automatically
)''';
  }

  String _generateHighContrastCode() {
    return '''FakeLoadingScreen(
  messages: ['High contrast loading...', 'Enhanced visibility...'],
  duration: Duration(seconds: 4),
  backgroundColor: Colors.black,
  textColor: Colors.white,
  progressColor: Colors.yellow,
  showProgress: true,
  textStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
)''';
  }

  String _generateFocusManagementCode() {
    return '''FakeLoadingScreen(
  messages: ['Managing focus...', 'Accessibility first...'],
  duration: Duration(seconds: 4),
  showProgress: true,
  // Focus is automatically managed during loading
  // and restored when complete
)''';
  }
}

class _ScreenReaderDemo extends StatelessWidget {
  const _ScreenReaderDemo();

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
              // Screen reader demo preview
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Semantics(
                        label: 'Loading indicator',
                        child: const CircularProgressIndicator(),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'Loading message',
                        liveRegion: true,
                        child: Text(
                          'Loading content for screen readers...',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Progress bar with semantic label
                      Semantics(
                        label: 'Loading progress: 50%',
                        child: Container(
                          width: 200,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Screen reader friendly',
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
                      _showFullScreenDemo(context, _buildScreenReaderScreen),
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

  Widget _buildScreenReaderScreen() {
    return FakeLoadingScreen(
      messages: ['Loading content...', 'Please wait...'],
      duration: const Duration(seconds: 4),
      showProgress: true,
      onComplete: () {},
    );
  }
}

class _HighContrastDemo extends StatelessWidget {
  const _HighContrastDemo();

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
              // High contrast preview
              Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.yellow,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'High contrast loading...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // High contrast progress bar
                      Container(
                        width: 200,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.7,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enhanced visibility',
                        style: TextStyle(color: Colors.white, fontSize: 12),
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
                      _showFullScreenDemo(context, _buildHighContrastScreen),
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

  Widget _buildHighContrastScreen() {
    return FakeLoadingScreen(
      messages: ['High contrast loading...', 'Enhanced visibility...'],
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.black,
      textColor: Colors.white,
      progressColor: Colors.yellow,
      showProgress: true,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      onComplete: () {},
    );
  }
}

class _FocusManagementDemo extends StatelessWidget {
  const _FocusManagementDemo();

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
              // Focus management preview
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Focus(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Managing focus...',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Progress bar
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
                        'Focus indicators',
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
                      _showFullScreenDemo(context, _buildFocusScreen),
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

  Widget _buildFocusScreen() {
    return FakeLoadingScreen(
      messages: ['Managing focus...', 'Accessibility first...'],
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

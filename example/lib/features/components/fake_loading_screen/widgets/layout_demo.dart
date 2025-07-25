import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/data/demo_helpers.dart';
import '../../../../core/utils/code_generator.dart';

/// Demonstrates FakeLoadingScreen layout variations and responsive behavior.
class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Layout & Responsive Design',
          subtitle: 'Screen size adaptations and orientation handling',
        ),
        const SizedBox(height: 16),

        // Responsive layout demo
        DemoCard(
          title: 'Responsive Layout',
          description: 'Adapts to different screen sizes and orientations',
          child: const _ResponsiveLayoutDemo(),
          codeSnippet: CodeGenerator.generateFakeLoadingScreenCode(
            messages: DemoHelpers.basicMessages,
            duration: const Duration(seconds: 4),
            showProgress: true,
          ),
        ),
        const SizedBox(height: 16),

        // Custom padding demo
        DemoCard(
          title: 'Custom Padding',
          description: 'Customizable padding around loading content',
          child: const _CustomPaddingDemo(),
          codeSnippet: _generateCustomPaddingCode(),
        ),
        const SizedBox(height: 16),

        // Text alignment demo
        DemoCard(
          title: 'Text Alignment',
          description: 'Different text alignment options',
          child: const _TextAlignmentDemo(),
          codeSnippet: _generateTextAlignmentCode(),
        ),
      ],
    );
  }

  String _generateCustomPaddingCode() {
    return '''FakeLoadingScreen(
  messages: ['Loading with custom padding...', 'Almost there...'],
  duration: Duration(seconds: 4),
  showProgress: true,
  padding: EdgeInsets.all(32.0),
)''';
  }

  String _generateTextAlignmentCode() {
    return '''FakeLoadingScreen(
  messages: ['Left aligned text', 'Still loading...'],
  duration: Duration(seconds: 4),
  textAlign: TextAlign.left,
  showProgress: true,
)''';
  }
}

class _ResponsiveLayoutDemo extends StatelessWidget {
  const _ResponsiveLayoutDemo();

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
              // Responsive layout preview
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Adapting to screen size...',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Progress bar that adapts to width
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
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
                      const SizedBox(height: 8),
                      Text(
                        'Responsive design',
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
                      _showFullScreenDemo(context, _buildResponsiveScreen),
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

  Widget _buildResponsiveScreen() {
    return FakeLoadingScreen(
      messages: DemoHelpers.basicMessages,
      duration: const Duration(seconds: 4),
      showProgress: true,
      onComplete: () {},
    );
  }
}

class _CustomPaddingDemo extends StatelessWidget {
  const _CustomPaddingDemo();

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
              // Custom padding preview
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(32.0), // Custom padding
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading with custom padding...',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Progress bar
                      Container(
                        width: 150,
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
                        '32px padding',
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
                      _showFullScreenDemo(context, _buildPaddingScreen),
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

  Widget _buildPaddingScreen() {
    return FakeLoadingScreen(
      messages: ['Loading with custom padding...', 'Almost there...'],
      duration: const Duration(seconds: 4),
      showProgress: true,
      padding: const EdgeInsets.all(32.0),
      onComplete: () {},
    );
  }
}

class _TextAlignmentDemo extends StatelessWidget {
  const _TextAlignmentDemo();

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
              // Text alignment preview
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Left aligned loading text',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Progress bar
                      Container(
                        width: 150,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                      const SizedBox(height: 8),
                      Text(
                        'TextAlign.left',
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
                      _showFullScreenDemo(context, _buildAlignmentScreen),
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

  Widget _buildAlignmentScreen() {
    return FakeLoadingScreen(
      messages: ['Left aligned text', 'Still loading...'],
      duration: const Duration(seconds: 4),
      textAlign: TextAlign.left,
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

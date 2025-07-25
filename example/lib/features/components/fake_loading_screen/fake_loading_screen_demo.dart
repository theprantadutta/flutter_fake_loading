import 'package:flutter/material.dart';
import '../../../core/widgets/widgets.dart';
import 'widgets/basic_screen_demo.dart';
import 'widgets/theme_demo.dart';
import 'widgets/layout_demo.dart';
import 'widgets/accessibility_demo.dart';

/// Main demonstration screen for FakeLoadingScreen component.
///
/// This screen showcases all the capabilities of FakeLoadingScreen including:
/// - Basic full-screen loading examples
/// - Theme and color customization
/// - Progress indicator integration
/// - Duration-based demonstrations
class FakeLoadingScreenDemo extends StatelessWidget {
  const FakeLoadingScreenDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FakeLoadingScreen'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Full-Screen Loading Demos',
              subtitle:
                  'Complete loading screen experiences with theming and customization',
            ),
            SizedBox(height: 16),
            BasicScreenDemo(),
            SizedBox(height: 24),
            ThemeDemo(),
            SizedBox(height: 24),
            LayoutDemo(),
            SizedBox(height: 24),
            AccessibilityDemo(),
          ],
        ),
      ),
    );
  }
}

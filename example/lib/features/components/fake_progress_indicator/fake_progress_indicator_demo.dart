import 'package:flutter/material.dart';
import '../../../core/widgets/widgets.dart';
import 'widgets/basic_progress_demo.dart';
import 'widgets/custom_progress_demo.dart';
import 'widgets/animation_curves_demo.dart';
import 'widgets/progress_callbacks_demo.dart';

/// Comprehensive demonstration of FakeProgressIndicator features
class FakeProgressIndicatorDemo extends StatelessWidget {
  const FakeProgressIndicatorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FakeProgressIndicator'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Basic Progress Animations',
              subtitle:
                  'Simple progress indicators with different configurations',
            ),
            SizedBox(height: 16),
            BasicProgressDemo(),

            SizedBox(height: 32),
            SectionHeader(
              title: 'Animation Curves & Timing',
              subtitle: 'Different animation curves and duration examples',
            ),
            SizedBox(height: 16),
            AnimationCurvesDemo(),

            SizedBox(height: 32),
            SectionHeader(
              title: 'Progress State & Callbacks',
              subtitle: 'Progress tracking and state change callbacks',
            ),
            SizedBox(height: 16),
            ProgressCallbacksDemo(),

            SizedBox(height: 32),
            SectionHeader(
              title: 'Custom Progress Widgets',
              subtitle: 'Custom progress indicators with builder pattern',
            ),
            SizedBox(height: 16),
            CustomProgressDemo(),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

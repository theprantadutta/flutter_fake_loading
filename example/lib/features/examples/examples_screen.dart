import 'package:flutter/material.dart';
import '../../core/widgets/section_header.dart';
import 'scenarios/app_launch.dart';
import 'scenarios/data_loading.dart';
import 'scenarios/onboarding.dart';
import 'scenarios/game_loading.dart';

/// Screen showing real-world usage examples
class ExamplesScreen extends StatelessWidget {
  const ExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Examples')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Real-World Examples',
              subtitle:
                  'See how to integrate fake loading in real applications',
              icon: Icons.apps,
            ),
            SizedBox(height: 24),

            // App Launch Sequence Example
            AppLaunchExample(),
            SizedBox(height: 32),

            // Data Loading Scenarios Example
            DataLoadingExample(),
            SizedBox(height: 32),

            // Onboarding Flow Example
            OnboardingExample(),
            SizedBox(height: 32),

            // Game Loading Screen Example
            GameLoadingExample(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

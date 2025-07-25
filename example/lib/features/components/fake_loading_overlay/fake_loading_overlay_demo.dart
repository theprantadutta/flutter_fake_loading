import 'package:flutter/material.dart';
import '../../../core/widgets/widgets.dart';
import 'widgets/async_demo.dart';
import 'widgets/integration_demo.dart';

/// Demonstrates FakeLoadingOverlay component with various async operations
/// and integration scenarios.
class FakeLoadingOverlayDemo extends StatelessWidget {
  const FakeLoadingOverlayDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FakeLoadingOverlay'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Async Operations',
              subtitle: 'Real Future-based operations with loading overlays',
            ),
            SizedBox(height: 16),
            AsyncOperationDemo(),
            SizedBox(height: 32),
            SectionHeader(
              title: 'Integration Scenarios',
              subtitle: 'Navigation flows, forms, and multi-step processes',
            ),
            SizedBox(height: 16),
            IntegrationScenariosDemo(),
          ],
        ),
      ),
    );
  }
}

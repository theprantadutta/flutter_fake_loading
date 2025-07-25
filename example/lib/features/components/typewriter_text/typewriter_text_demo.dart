import 'package:flutter/material.dart';
import '../../../core/widgets/widgets.dart';
import 'widgets/basic_typewriter_demo.dart';
import 'widgets/cursor_demo.dart';
import 'widgets/speed_demo.dart';
import 'widgets/callback_demo.dart';
import 'widgets/controller_demo.dart';
import 'widgets/multiline_demo.dart';
import 'widgets/integration_demo.dart';

/// Demonstrates all TypewriterText component features and capabilities.
class TypewriterTextDemo extends StatelessWidget {
  const TypewriterTextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TypewriterText Demos'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'TypewriterText Component',
              subtitle:
                  'Character-by-character text animation with customizable effects',
            ),
            SizedBox(height: 24),

            // Basic typewriter examples
            BasicTypewriterDemo(),
            SizedBox(height: 32),

            // Cursor customization
            CursorDemo(),
            SizedBox(height: 32),

            // Speed and timing variations
            SpeedDemo(),
            SizedBox(height: 32),

            // Callbacks and events
            CallbackDemo(),
            SizedBox(height: 32),

            // Advanced features section
            SectionHeader(
              title: 'Advanced Features',
              subtitle:
                  'External controllers, multi-line text, and component integration',
            ),
            SizedBox(height: 16),

            // External controller management
            ControllerDemo(),
            SizedBox(height: 32),

            // Multi-line text and formatting
            MultilineDemo(),
            SizedBox(height: 32),

            // Integration with other components
            IntegrationDemo(),
          ],
        ),
      ),
    );
  }
}

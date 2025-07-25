import 'package:flutter/material.dart';
import '../../core/widgets/section_header.dart';
import 'widgets/theme_selector.dart';
import 'widgets/accessibility_options.dart';
import 'widgets/demo_settings.dart';
import 'widgets/about_section.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'App Settings',
              subtitle: 'Customize your showcase experience',
              icon: Icons.settings,
            ),
            const SizedBox(height: 24),

            // Theme Settings with Live Preview
            const ThemeSelector(),
            const SizedBox(height: 16),

            // Demo Speed and Timing Settings
            const DemoSettings(),
            const SizedBox(height: 16),

            // Accessibility Options
            const AccessibilityOptions(),
            const SizedBox(height: 16),

            // About Section
            const AboutSection(),
          ],
        ),
      ),
    );
  }
}

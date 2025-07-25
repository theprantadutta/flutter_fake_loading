import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/accessibility_provider.dart';
import '../../../core/utils/accessibility_test.dart';

/// Accessibility options and preferences
class AccessibilityOptions extends StatelessWidget {
  const AccessibilityOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibility, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.accessibility,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Accessibility',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Motion and Animation Settings
                _AccessibilitySection(
                  title: 'Motion & Animation',
                  children: [
                    _AccessibilitySwitch(
                      title: 'Reduce Motion',
                      subtitle: 'Minimize animations and transitions',
                      value: accessibility.reduceMotion,
                      onChanged: (value) {
                        accessibility.setReduceMotion(value);
                        if (value) {
                          accessibility.provideFeedback(
                            HapticFeedbackType.lightImpact,
                          );
                        }
                      },
                    ),
                    _AccessibilitySwitch(
                      title: 'Haptic Feedback',
                      subtitle: 'Enable vibration feedback for interactions',
                      value: accessibility.hapticFeedback,
                      onChanged: (value) {
                        accessibility.setHapticFeedback(value);
                        if (value) {
                          accessibility.provideFeedback(
                            HapticFeedbackType.lightImpact,
                          );
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Visual Settings
                _AccessibilitySection(
                  title: 'Visual',
                  children: [
                    _AccessibilitySwitch(
                      title: 'High Contrast',
                      subtitle: 'Increase contrast for better visibility',
                      value: accessibility.highContrast,
                      onChanged: accessibility.setHighContrast,
                    ),
                    _AccessibilitySwitch(
                      title: 'Large Text',
                      subtitle: 'Use larger text sizes throughout the app',
                      value: accessibility.largeText,
                      onChanged: accessibility.setLargeText,
                    ),
                    _AccessibilitySwitch(
                      title: 'Focus Indicators',
                      subtitle: 'Show visual focus indicators',
                      value: accessibility.showFocusIndicators,
                      onChanged: accessibility.setShowFocusIndicators,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Text Scale Factor Slider
                _TextScaleSlider(
                  value: accessibility.textScaleFactor,
                  onChanged: accessibility.setTextScaleFactor,
                ),

                const SizedBox(height: 16),

                // Navigation Settings
                _AccessibilitySection(
                  title: 'Navigation',
                  children: [
                    _AccessibilitySwitch(
                      title: 'Screen Reader Support',
                      subtitle: 'Enable semantic labels and descriptions',
                      value: accessibility.screenReaderSupport,
                      onChanged: accessibility.setScreenReaderSupport,
                    ),
                    _AccessibilitySwitch(
                      title: 'Keyboard Navigation',
                      subtitle: 'Enable full keyboard navigation support',
                      value: accessibility.keyboardNavigation,
                      onChanged: accessibility.setKeyboardNavigation,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Accessibility Test Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => AccessibilityTest.runAccessibilityTest(
                      context,
                      accessibility,
                    ),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Test Accessibility'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccessibilitySection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _AccessibilitySection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}

class _AccessibilitySwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AccessibilitySwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}

class _TextScaleSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _TextScaleSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Text Scale Factor',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${(value * 100).round()}%',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Adjust text size throughout the app',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: 0.8,
          max: 2.0,
          divisions: 12,
          onChanged: onChanged,
        ),
        // Preview text
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Preview text at ${(value * 100).round()}% scale',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize:
                  Theme.of(context).textTheme.bodyMedium!.fontSize! * value,
            ),
          ),
        ),
      ],
    );
  }
}

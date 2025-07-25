import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/data/demo_constants.dart';
import '../../../core/providers/accessibility_provider.dart';

/// Demo speed and timing adjustment settings
class DemoSettings extends StatefulWidget {
  const DemoSettings({super.key});

  @override
  State<DemoSettings> createState() => _DemoSettingsState();
}

class _DemoSettingsState extends State<DemoSettings> {
  double _animationSpeed = 1.0;
  double _defaultDuration = DemoConstants.mediumDuration.inMilliseconds
      .toDouble();
  bool _enableAnimations = true;
  bool _showCodeByDefault = false;
  bool _autoPlayDemos = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Demo Settings',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Animation Speed
            Consumer<AccessibilityProvider>(
              builder: (context, accessibility, child) {
                return _SettingSlider(
                  title: 'Animation Speed',
                  subtitle: 'Adjust the speed of all animations',
                  value: _animationSpeed,
                  min: 0.25,
                  max: 3.0,
                  divisions: 11,
                  onChanged: (value) {
                    accessibility.provideFeedback(
                      HapticFeedbackType.selectionClick,
                    );
                    setState(() {
                      _animationSpeed = value;
                    });
                  },
                  valueFormatter: (value) => '${value.toStringAsFixed(2)}x',
                );
              },
            ),

            const SizedBox(height: 16),

            // Default Duration
            _SettingSlider(
              title: 'Default Duration',
              subtitle: 'Default duration for loading demonstrations',
              value: _defaultDuration,
              min: DemoConstants.minDuration,
              max: DemoConstants.maxDuration,
              divisions: 20,
              onChanged: (value) {
                setState(() {
                  _defaultDuration = value;
                });
              },
              valueFormatter: (value) =>
                  '${(value / 1000).toStringAsFixed(1)}s',
            ),

            const SizedBox(height: 16),

            // Toggle Settings
            _SettingSwitch(
              title: 'Enable Animations',
              subtitle: 'Turn on/off all animations in demos',
              value: _enableAnimations,
              onChanged: (value) {
                setState(() {
                  _enableAnimations = value;
                });
              },
            ),

            _SettingSwitch(
              title: 'Show Code by Default',
              subtitle: 'Automatically expand code examples',
              value: _showCodeByDefault,
              onChanged: (value) {
                setState(() {
                  _showCodeByDefault = value;
                });
              },
            ),

            _SettingSwitch(
              title: 'Auto-play Demos',
              subtitle: 'Automatically start demos when viewed',
              value: _autoPlayDemos,
              onChanged: (value) {
                setState(() {
                  _autoPlayDemos = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _resetToDefaults,
                icon: const Icon(Icons.restore),
                label: const Text('Reset to Defaults'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      _animationSpeed = 1.0;
      _defaultDuration = DemoConstants.mediumDuration.inMilliseconds.toDouble();
      _enableAnimations = true;
      _showCodeByDefault = false;
      _autoPlayDemos = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings reset to defaults'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _SettingSlider extends StatelessWidget {
  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final String Function(double) valueFormatter;

  const _SettingSlider({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    required this.valueFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                valueFormatter(value),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingSwitch({
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/code_generator.dart';

/// Demonstrates different typing speeds and character delay configurations.
class SpeedDemo extends StatefulWidget {
  const SpeedDemo({super.key});

  @override
  State<SpeedDemo> createState() => _SpeedDemoState();
}

class _SpeedDemoState extends State<SpeedDemo> {
  final String _demoText =
      'Watch how typing speed affects the animation flow and user experience.';

  double _characterDelay = 50; // milliseconds

  final Map<String, double> _speedPresets = {
    'Very Slow': 200,
    'Slow': 100,
    'Normal': 50,
    'Fast': 25,
    'Very Fast': 10,
    'Instant': 1,
  };

  String _generateCode() {
    return CodeGenerator.generateTypewriterText(
      text: _demoText,
      characterDelay: Duration(milliseconds: _characterDelay.round()),
    );
  }

  void _applyPreset(double delay) {
    setState(() => _characterDelay = delay);
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Typing Speed & Character Delays',
      description:
          'Control the timing between characters for different animation effects',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Demo area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Center(
              child: TypewriterText(
                key: ValueKey(_characterDelay),
                text: _demoText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                characterDelay: Duration(milliseconds: _characterDelay.round()),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Speed control
          PropertyControl<double>(
            type: PropertyControlType.slider,
            label: 'Character Delay (${_characterDelay.round()}ms)',
            value: _characterDelay,
            options: {'min': 1.0, 'max': 300.0, 'divisions': 299},
            onChanged: (value) => setState(() => _characterDelay = value),
          ),

          const SizedBox(height: 16),

          // Speed presets
          Text('Speed Presets', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _speedPresets.entries.map((entry) {
              final name = entry.key;
              final delay = entry.value;
              final isSelected = (_characterDelay - delay).abs() < 1;

              return FilterChip(
                label: Text(name),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    _applyPreset(delay);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Multiple speed comparison
          Text(
            'Speed Comparison',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),

          ...[
            'Fast (25ms)',
            'Normal (50ms)',
            'Slow (100ms)',
          ].asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            final delay = [25, 50, 100][index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TypewriterText(
                    key: ValueKey('comparison_$delay'),
                    text: 'This is $label typing speed demonstration.',
                    characterDelay: Duration(milliseconds: delay),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 16),

          // Performance note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.secondaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.speed,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Very fast speeds (< 10ms) may appear instant on some devices. Consider user experience when choosing timing.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      codeSnippet: _generateCode(),
    );
  }
}

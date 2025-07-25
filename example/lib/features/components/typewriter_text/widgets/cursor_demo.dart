import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/code_generator.dart';

/// Demonstrates TypewriterText cursor customization and blinking options.
class CursorDemo extends StatefulWidget {
  const CursorDemo({super.key});

  @override
  State<CursorDemo> createState() => _CursorDemoState();
}

class _CursorDemoState extends State<CursorDemo> {
  final String _demoText = 'Customizing the cursor appearance...';

  String _cursor = '|';
  bool _showCursor = true;
  bool _blinkCursor = true;
  double _blinkSpeed = 500; // milliseconds

  final List<String> _cursorOptions = ['|', '_', '█', '▌', '●', '♦', '→', '✨'];

  String _generateCode() {
    return CodeGenerator.generateTypewriterText(
      text: _demoText,
      cursor: _cursor,
      showCursor: _showCursor,
      blinkCursor: _blinkCursor,
      blinkInterval: Duration(milliseconds: _blinkSpeed.round()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Cursor Customization',
      description:
          'Customize cursor appearance, visibility, and blinking behavior',
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
                key: ValueKey('$_cursor$_showCursor$_blinkCursor$_blinkSpeed'),
                text: _demoText,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'monospace',
                ),
                cursor: _cursor,
                showCursor: _showCursor,
                blinkCursor: _blinkCursor,
                blinkInterval: Duration(milliseconds: _blinkSpeed.round()),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Cursor character selection
          Text(
            'Cursor Character',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _cursorOptions.map((cursor) {
              final isSelected = cursor == _cursor;
              return FilterChip(
                label: Text(
                  cursor,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _cursor = cursor);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Controls
          PropertyControl<bool>(
            type: PropertyControlType.toggle,
            label: 'Show Cursor',
            value: _showCursor,
            onChanged: (value) => setState(() => _showCursor = value),
          ),

          const SizedBox(height: 12),

          PropertyControl<bool>(
            type: PropertyControlType.toggle,
            label: 'Blink Cursor',
            value: _blinkCursor,
            onChanged: _showCursor
                ? (value) => setState(() => _blinkCursor = value)
                : (value) {},
          ),

          const SizedBox(height: 12),

          PropertyControl<double>(
            type: PropertyControlType.slider,
            label: 'Blink Speed (${_blinkSpeed.round()}ms)',
            value: _blinkSpeed,
            options: {'min': 100.0, 'max': 2000.0, 'divisions': 19},
            onChanged: (_showCursor && _blinkCursor)
                ? (value) => setState(() => _blinkSpeed = value)
                : (value) {},
          ),

          const SizedBox(height: 16),

          // Info card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'The cursor appears during typing and can be customized with different characters, visibility, and blinking behavior.',
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

import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';

/// Demonstrates multi-line text and formatting options with TypewriterText.
class MultilineDemo extends StatefulWidget {
  const MultilineDemo({super.key});

  @override
  State<MultilineDemo> createState() => _MultilineDemoState();
}

class _MultilineDemoState extends State<MultilineDemo> {
  final Map<String, String> _demoTexts = {
    'Simple Multi-line': '''Welcome to our app!
Loading your personalized experience...
This might take a moment.
Thanks for your patience!''',

    'Code Block': '''// Initializing system...
const config = {
  theme: 'dark',
  animations: true,
  performance: 'high'
};

console.log('System ready!');''',

    'Story Format': '''Chapter 1: The Beginning

Once upon a time, in a digital realm far away, there lived a loading screen that dreamed of being more than just a spinner.

It wanted to tell stories, share jokes, and make waiting enjoyable.

And so, this package was born...''',

    'List Format': '''📋 Loading Checklist:

✓ Connecting to server
✓ Authenticating user
⏳ Loading preferences
⏳ Fetching data
⏳ Preparing interface

Almost ready!''',
  };

  String _selectedKey = 'Simple Multi-line';
  String get _selectedText => _demoTexts[_selectedKey]!;

  TextAlign _textAlign = TextAlign.start;
  double _fontSize = 16.0;
  FontWeight _fontWeight = FontWeight.normal;
  Duration _characterDelay = const Duration(milliseconds: 50);

  String _generateCode() {
    return '''
TypewriterText(
  text: """$_selectedText""",
  style: TextStyle(
    fontSize: ${_fontSize.toInt()},
    fontWeight: FontWeight.${_fontWeight.toString().split('.').last},
    height: 1.4, // Line height for better readability
  ),
  textAlign: TextAlign.${_textAlign.toString().split('.').last},
  characterDelay: Duration(milliseconds: ${_characterDelay.inMilliseconds}),
  showCursor: true,
  cursor: '|',
  autoStart: true,
)''';
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Multi-line Text & Formatting',
      description:
          'Typewriter animation with multi-line text and custom formatting',
      codeSnippet: _generateCode(),
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
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: TypewriterText(
                  key: ValueKey(
                    '$_selectedKey-$_textAlign-$_fontSize-$_fontWeight-${_characterDelay.inMilliseconds}',
                  ),
                  text: _selectedText,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: _fontWeight,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.4, // Better line height for readability
                    fontFamily: _selectedKey == 'Code Block'
                        ? 'monospace'
                        : null,
                  ),
                  textAlign: _textAlign,
                  characterDelay: _characterDelay,
                  showCursor: true,
                  cursor: '|',
                  autoStart: true,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Text selection
          const Text(
            'Text Content:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _demoTexts.keys.map((key) {
              final isSelected = key == _selectedKey;
              return FilterChip(
                label: Text(key),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedKey = key);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Formatting controls
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              PropertyControl<TextAlign>(
                type: PropertyControlType.dropdown,
                label: 'Text Align',
                value: _textAlign,
                options: {
                  'items': [
                    TextAlign.start,
                    TextAlign.center,
                    TextAlign.end,
                    TextAlign.justify,
                  ],
                  'itemLabels': ['Start', 'Center', 'End', 'Justify'],
                },
                onChanged: (value) => setState(() => _textAlign = value),
              ),
              PropertyControl<double>(
                type: PropertyControlType.slider,
                label: 'Font Size',
                value: _fontSize,
                options: {'min': 12.0, 'max': 24.0, 'divisions': 12},
                onChanged: (value) => setState(() => _fontSize = value),
              ),
              PropertyControl<FontWeight>(
                type: PropertyControlType.dropdown,
                label: 'Font Weight',
                value: _fontWeight,
                options: {
                  'items': [
                    FontWeight.normal,
                    FontWeight.w500,
                    FontWeight.w600,
                    FontWeight.bold,
                  ],
                  'itemLabels': ['Normal', 'Medium', 'Semi-bold', 'Bold'],
                },
                onChanged: (value) => setState(() => _fontWeight = value),
              ),
              PropertyControl<double>(
                type: PropertyControlType.slider,
                label: 'Character Delay (ms)',
                value: _characterDelay.inMilliseconds.toDouble(),
                options: {'min': 10.0, 'max': 200.0, 'divisions': 19},
                onChanged: (value) => setState(
                  () => _characterDelay = Duration(milliseconds: value.toInt()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

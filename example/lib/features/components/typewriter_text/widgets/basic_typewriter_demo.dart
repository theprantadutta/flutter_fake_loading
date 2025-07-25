import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/code_generator.dart';

/// Demonstrates basic TypewriterText usage with simple character-by-character animation.
class BasicTypewriterDemo extends StatefulWidget {
  const BasicTypewriterDemo({super.key});

  @override
  State<BasicTypewriterDemo> createState() => _BasicTypewriterDemoState();
}

class _BasicTypewriterDemoState extends State<BasicTypewriterDemo> {
  final List<String> _demoTexts = [
    'Hello, World!',
    'Loading your awesome content...',
    'Preparing something amazing for you!',
    'Just a moment while we work our magic...',
    'Almost there! Thanks for your patience.',
  ];

  int _currentTextIndex = 0;
  String _selectedText = 'Hello, World!';
  bool _autoStart = true;

  @override
  void initState() {
    super.initState();
    _selectedText = _demoTexts[_currentTextIndex];
  }

  void _nextText() {
    setState(() {
      _currentTextIndex = (_currentTextIndex + 1) % _demoTexts.length;
      _selectedText = _demoTexts[_currentTextIndex];
    });
  }

  String _generateCode() {
    return CodeGenerator.generateTypewriterText(
      text: _selectedText,
      autoStart: _autoStart,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Basic Typewriter Animation',
      description: 'Simple character-by-character text animation',
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
            child: Center(
              child: TypewriterText(
                key: ValueKey(_selectedText + _autoStart.toString()),
                text: _selectedText,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                autoStart: _autoStart,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Controls
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              PropertyControl<bool>(
                type: PropertyControlType.toggle,
                label: 'Auto Start',
                value: _autoStart,
                onChanged: (value) => setState(() => _autoStart = value),
              ),
              ElevatedButton.icon(
                onPressed: _nextText,
                icon: const Icon(Icons.refresh),
                label: const Text('Next Text'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Text selection
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _demoTexts.asMap().entries.map((entry) {
              final index = entry.key;
              final text = entry.value;
              final isSelected = index == _currentTextIndex;

              return FilterChip(
                label: Text(
                  text.length > 30 ? '${text.substring(0, 30)}...' : text,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onSecondaryContainer
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _currentTextIndex = index;
                      _selectedText = text;
                    });
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
      codeSnippet: _generateCode(),
    );
  }
}

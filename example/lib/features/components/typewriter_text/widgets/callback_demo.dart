import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';

/// Demonstrates TypewriterText completion callbacks and character-typed events.
class CallbackDemo extends StatefulWidget {
  const CallbackDemo({super.key});

  @override
  State<CallbackDemo> createState() => _CallbackDemoState();
}

class _CallbackDemoState extends State<CallbackDemo> {
  final String _demoText =
      'This text will trigger events as it types and when complete!';

  String _currentText = '';
  bool _isComplete = false;
  int _characterCount = 0;
  final List<String> _eventLog = [];

  void _onCharacterTyped(String text) {
    setState(() {
      _currentText = text;
      _characterCount = text.length;
      _eventLog.add(
        'Character typed: "${text.isNotEmpty ? text[text.length - 1] : ''}" (${text.length} chars)',
      );

      // Keep only last 5 events for display
      if (_eventLog.length > 5) {
        _eventLog.removeAt(0);
      }
    });
  }

  void _onComplete() {
    setState(() {
      _isComplete = true;
      _eventLog.add('✅ Animation completed!');

      if (_eventLog.length > 5) {
        _eventLog.removeAt(0);
      }
    });
  }

  void _resetDemo() {
    setState(() {
      _currentText = '';
      _isComplete = false;
      _characterCount = 0;
      _eventLog.clear();
    });
  }

  String _generateCode() {
    return '''TypewriterText(
  text: '$_demoText',
  onCharacterTyped: (text) {
    print('Current text: \$text');
    print('Character count: \${text.length}');
  },
  onComplete: () {
    print('Typewriter animation completed!');
    // Perform actions after completion
  },
)''';
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Completion Callbacks & Character Events',
      description:
          'React to typing progress and completion with callback functions',
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
                key: ValueKey(
                  'callback_demo_${DateTime.now().millisecondsSinceEpoch}',
                ),
                text: _demoText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                onCharacterTyped: _onCharacterTyped,
                onComplete: _onComplete,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Status indicators
          Row(
            children: [
              Expanded(
                child: _StatusCard(
                  title: 'Characters Typed',
                  value: '$_characterCount / ${_demoText.length}',
                  icon: Icons.text_fields,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatusCard(
                  title: 'Status',
                  value: _isComplete ? 'Complete' : 'Typing...',
                  icon: _isComplete ? Icons.check_circle : Icons.edit,
                  color: _isComplete
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Current text display
          Container(
            width: double.infinity,
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
                  'Current Text:',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentText.isEmpty ? '(No text yet)' : '"$_currentText"',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Event log
          Container(
            width: double.infinity,
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
                Row(
                  children: [
                    Text(
                      'Event Log:',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_eventLog.length} events',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_eventLog.isEmpty)
                  Text(
                    'No events yet - start typing to see callbacks!',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  ...(_eventLog.reversed
                      .take(5)
                      .map(
                        (event) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            event,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontFamily: 'monospace',
                                  color: event.contains('✅')
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Theme.of(context).colorScheme.onSurface
                                            .withOpacity(0.8),
                                ),
                          ),
                        ),
                      )),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Reset button
          Center(
            child: ElevatedButton.icon(
              onPressed: _resetDemo,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Demo'),
            ),
          ),

          const SizedBox(height: 16),

          // Usage tip
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.tertiaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Use callbacks to trigger actions, update UI state, or chain animations when typing completes.',
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

class _StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatusCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

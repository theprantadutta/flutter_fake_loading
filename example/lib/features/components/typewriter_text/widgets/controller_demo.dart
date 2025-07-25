import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';

/// Demonstrates external TypewriterController usage with pause/resume/reset functionality.
class ControllerDemo extends StatefulWidget {
  const ControllerDemo({super.key});

  @override
  State<ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<ControllerDemo> {
  late TypewriterController _controller;
  final List<String> _demoTexts = [
    'Welcome to the advanced typewriter demo!',
    'This demonstrates external controller usage.',
    'You can pause, resume, and reset the animation.',
    'The controller provides full programmatic control.',
    'Try the different buttons to see it in action!',
  ];

  int _currentTextIndex = 0;
  String get _currentText => _demoTexts[_currentTextIndex];

  @override
  void initState() {
    super.initState();
    _controller = TypewriterController(
      characterDelay: const Duration(milliseconds: 80),
      cursor: '█',
      showCursor: true,
      blinkCursor: true,
      blinkInterval: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startTyping() {
    _controller.startTyping(_currentText);
  }

  void _pauseTyping() {
    _controller.pause();
  }

  void _resumeTyping() {
    _controller.resume();
  }

  void _resetTyping() {
    _controller.reset();
  }

  void _skipToEnd() {
    _controller.skipToEnd();
  }

  void _nextText() {
    setState(() {
      _currentTextIndex = (_currentTextIndex + 1) % _demoTexts.length;
    });
    _controller.startTyping(_currentText);
  }

  String _generateCode() {
    return '''
// Create a controller for external management
final controller = TypewriterController(
  characterDelay: Duration(milliseconds: 80),
  cursor: '█',
  showCursor: true,
  blinkCursor: true,
  blinkInterval: Duration(milliseconds: 600),
);

// Use the controller with TypewriterText
TypewriterText(
  text: '$_currentText',
  controller: controller,
  autoStart: false, // Control manually
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
)

// Control the animation programmatically
controller.startTyping('Your text here');
controller.pause();
controller.resume();
controller.reset();
controller.skipToEnd();

// Listen to controller state
controller.addListener(() {
  print('Progress: \${controller.progress}');
  print('Is typing: \${controller.isTyping}');
  print('Is complete: \${controller.isComplete}');
});''';
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'External Controller Management',
      description:
          'Programmatic control with pause, resume, and reset functionality',
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
            child: Column(
              children: [
                // Typewriter text
                SizedBox(
                  height: 60,
                  child: Center(
                    child: TypewriterText(
                      text: _currentText,
                      controller: _controller,
                      autoStart: false,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Progress indicator
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Column(
                      children: [
                        LinearProgressIndicator(
                          value: _controller.progress,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Progress: ${(_controller.progress * 100).toInt()}% | '
                          'Status: ${_controller.isTyping
                              ? 'Typing'
                              : _controller.isComplete
                              ? 'Complete'
                              : 'Paused'}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Control buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _startTyping,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start'),
              ),
              ElevatedButton.icon(
                onPressed: _controller.isTyping ? _pauseTyping : null,
                icon: const Icon(Icons.pause),
                label: const Text('Pause'),
              ),
              ElevatedButton.icon(
                onPressed: !_controller.isTyping && !_controller.isComplete
                    ? _resumeTyping
                    : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Resume'),
              ),
              ElevatedButton.icon(
                onPressed: _resetTyping,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
              ElevatedButton.icon(
                onPressed: _controller.isTyping ? _skipToEnd : null,
                icon: const Icon(Icons.skip_next),
                label: const Text('Skip'),
              ),
              ElevatedButton.icon(
                onPressed: _nextText,
                icon: const Icon(Icons.navigate_next),
                label: const Text('Next Text'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

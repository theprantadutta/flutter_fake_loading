import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/demo_card.dart';
import '../../../../core/widgets/property_control.dart';
import '../../../../core/utils/code_generator.dart';

/// Widget that demonstrates message effects
class MessageEffectsDemo extends StatefulWidget {
  const MessageEffectsDemo({super.key});

  @override
  State<MessageEffectsDemo> createState() => _MessageEffectsDemoState();
}

class _MessageEffectsDemoState extends State<MessageEffectsDemo> {
  MessageEffect _selectedEffect = MessageEffect.fade;
  Duration _transitionDuration = const Duration(milliseconds: 500);
  Duration _messageDuration = const Duration(seconds: 2);

  final Map<MessageEffect, FakeLoaderController> _controllers = {};
  final Map<MessageEffect, String> _effectDescriptions = {
    MessageEffect.fade: 'Smooth fade in/out transition between messages',
    MessageEffect.slide: 'Messages slide in from right and out to left',
    MessageEffect.scale:
        'Messages scale up from small and scale down when changing',
    MessageEffect.typewriter: 'Character-by-character typing animation',
  };

  final List<String> _demoMessages = [
    'Demonstrating effects...',
    'Watch the transitions!',
    'Each effect is unique',
    'Choose your favorite!',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each effect
    for (final effect in MessageEffect.values) {
      _controllers[effect] = FakeLoaderController();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Introduction
          DemoCard(
            title: 'Message Effects Showcase',
            description:
                'Explore different animation effects for message transitions.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Message effects control how text transitions between different loading messages. '
                  'Each effect provides a unique visual style to match your app\'s personality.',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.animation,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Try different effects and timing parameters to find the perfect animation for your use case.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Side-by-side comparison
          _buildSideBySideComparison(),

          const SizedBox(height: 24),

          // Interactive effect customization
          _buildEffectCustomization(),

          const SizedBox(height: 24),

          // Timing demonstrations
          _buildTimingDemonstrations(),

          const SizedBox(height: 24),

          // Custom effect creation guide
          _buildCustomEffectGuide(),
        ],
      ),
    );
  }

  Widget _buildSideBySideComparison() {
    return DemoCard(
      title: 'Side-by-Side Effect Comparison',
      description: 'Compare all message effects running simultaneously',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('All effects running with the same messages and timing:'),
          const SizedBox(height: 16),

          // Grid of effects
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: MessageEffect.values.length,
            itemBuilder: (context, index) {
              final effect = MessageEffect.values[index];
              final controller = _controllers[effect]!;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Effect name
                      Text(
                        _getEffectDisplayName(effect),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),

                      // Demo area
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: FakeLoader(
                            controller: controller,
                            messages: _demoMessages,
                            effect: effect,
                            messageDuration: _messageDuration,
                            autoStart: false,
                            textStyle: const TextStyle(fontSize: 14),
                            spinner: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Control buttons
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _areAnyControllersRunning()
                    ? null
                    : _startAllControllers,
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Start All'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _areAnyControllersRunning()
                    ? _stopAllControllers
                    : null,
                icon: const Icon(Icons.pause, size: 18),
                label: const Text('Stop All'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: _resetAllControllers,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset All'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEffectCustomization() {
    return DemoCard(
      title: 'Interactive Effect Customization',
      description:
          'Customize effect parameters and see the results in real-time',
      showCode: true,
      codeSnippet: CodeGenerator.generateMessageEffectCode(
        _selectedEffect.name,
        _demoMessages,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Effect selection
          PropertyControl<MessageEffect>(
            label: 'Message Effect',
            value: _selectedEffect,
            onChanged: (value) {
              setState(() {
                _selectedEffect = value;
              });
            },
            type: PropertyControlType.segmentedButton,
            options: {
              'segments': MessageEffect.values.map((effect) {
                return ButtonSegment<MessageEffect>(
                  value: effect,
                  label: Text(
                    _getEffectDisplayName(effect),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
            },
          ),

          const SizedBox(height: 16),

          // Effect description
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _effectDescriptions[_selectedEffect] ??
                  'No description available',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Timing controls
          Row(
            children: [
              Expanded(
                child: PropertyControl<double>(
                  label: 'Message Duration (seconds)',
                  value: _messageDuration.inMilliseconds / 1000.0,
                  onChanged: (value) {
                    setState(() {
                      _messageDuration = Duration(
                        milliseconds: (value * 1000).round(),
                      );
                    });
                  },
                  type: PropertyControlType.slider,
                  options: {'min': 0.5, 'max': 5.0, 'divisions': 18},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PropertyControl<double>(
                  label: 'Transition Duration (ms)',
                  value: _transitionDuration.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _transitionDuration = Duration(
                        milliseconds: value.round(),
                      );
                    });
                  },
                  type: PropertyControlType.slider,
                  options: {'min': 100.0, 'max': 2000.0, 'divisions': 19},
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Live demo area
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: FakeLoader(
              controller: _controllers[_selectedEffect]!,
              messages: _demoMessages,
              effect: _selectedEffect,
              messageDuration: _messageDuration,
              autoStart: false,
              textStyle: const TextStyle(fontSize: 18),
              spinner: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Controls
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _controllers[_selectedEffect]!.isRunning
                    ? null
                    : () => _controllers[_selectedEffect]!.start(),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Start Demo'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _controllers[_selectedEffect]!.isRunning
                    ? () => _controllers[_selectedEffect]!.stop()
                    : null,
                icon: const Icon(Icons.pause, size: 18),
                label: const Text('Stop'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _controllers[_selectedEffect]!.reset(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimingDemonstrations() {
    final timingPresets = [
      {'name': 'Fast', 'message': 1000, 'transition': 200},
      {'name': 'Normal', 'message': 2000, 'transition': 500},
      {'name': 'Slow', 'message': 3000, 'transition': 800},
      {'name': 'Very Slow', 'message': 5000, 'transition': 1200},
    ];

    return DemoCard(
      title: 'Timing & Easing Demonstrations',
      description: 'See how different timing affects the user experience',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Different timing presets show how speed affects the loading experience:',
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: timingPresets.length,
            itemBuilder: (context, index) {
              final preset = timingPresets[index];
              final controller = FakeLoaderController();

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        preset['name'] as String,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '${preset['message']}ms / ${preset['transition']}ms',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: FakeLoader(
                            controller: controller,
                            messages: [
                              'Loading...',
                              'Processing...',
                              'Almost done!',
                            ],
                            effect: _selectedEffect,
                            messageDuration: Duration(
                              milliseconds: preset['message'] as int,
                            ),
                            autoStart: false,
                            textStyle: const TextStyle(fontSize: 12),
                            spinner: SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isRunning
                              ? null
                              : () => controller.start(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          child: const Text('Test'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Timing recommendations
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.tips_and_updates,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Timing Recommendations',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Fast (1s): Quick operations, progress indicators',
                ),
                const Text(
                  '• Normal (2s): Standard loading, balanced experience',
                ),
                const Text(
                  '• Slow (3s): Complex operations, detailed messages',
                ),
                const Text(
                  '• Very Slow (5s): Long operations, entertainment value',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomEffectGuide() {
    return DemoCard(
      title: 'Custom Effect Creation Guide',
      description: 'Learn how to create your own message effects',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'While the library provides built-in effects, you can create custom animations by extending the message system:',
          ),
          const SizedBox(height: 16),

          // Custom effect examples
          ExpansionTile(
            title: const Text('Custom Bounce Effect Example'),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('''// Custom bounce effect implementation
class BounceMessageEffect extends MessageEffect {
  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.bounceOut,
      )),
      child: child,
    );
  }
}''', style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ExpansionTile(
            title: const Text('Custom Rotation Effect Example'),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('''// Custom rotation effect implementation
class RotationMessageEffect extends MessageEffect {
  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return RotationTransition(
      turns: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}''', style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Implementation tips
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Implementation Tips',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('• Use Flutter\'s built-in transition widgets'),
                const Text('• Combine multiple animations for complex effects'),
                const Text(
                  '• Consider performance with many simultaneous animations',
                ),
                const Text('• Test effects with different message lengths'),
                const Text('• Provide smooth enter and exit animations'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Try custom effect button
          ElevatedButton.icon(
            onPressed: () => _showCustomEffectDemo(),
            icon: const Icon(Icons.science),
            label: const Text('Try Experimental Effects'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _getEffectDisplayName(MessageEffect effect) {
    switch (effect) {
      case MessageEffect.fade:
        return 'Fade';
      case MessageEffect.slide:
        return 'Slide';
      case MessageEffect.scale:
        return 'Scale';
      case MessageEffect.typewriter:
        return 'Typewriter';
    }
  }

  bool _areAnyControllersRunning() {
    return _controllers.values.any((controller) => controller.isRunning);
  }

  void _startAllControllers() {
    for (final controller in _controllers.values) {
      if (!controller.isRunning) {
        controller.start();
      }
    }
  }

  void _stopAllControllers() {
    for (final controller in _controllers.values) {
      if (controller.isRunning) {
        controller.stop();
      }
    }
  }

  void _resetAllControllers() {
    for (final controller in _controllers.values) {
      controller.reset();
    }
  }

  void _showCustomEffectDemo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Experimental Effects'),
        content: SizedBox(
          width: 300,
          height: 200,
          child: Column(
            children: [
              const Text(
                'Here\'s a preview of what custom effects might look like:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FakeLoader(
                  messages: [
                    'Custom bounce effect!',
                    'Experimental rotation!',
                    'Creative transitions!',
                    'Your imagination!',
                  ],
                  effect: MessageEffect.scale, // Using scale as placeholder
                  messageDuration: const Duration(seconds: 2),
                  autoStart: true,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/demo_card.dart';
import '../../../../core/widgets/property_control.dart';
import '../../../../core/data/sample_messages.dart';

/// Advanced FakeLoader demonstrations with complex features
class AdvancedFakeLoaderDemo extends StatefulWidget {
  const AdvancedFakeLoaderDemo({super.key});

  @override
  State<AdvancedFakeLoaderDemo> createState() => _AdvancedFakeLoaderDemoState();
}

class _AdvancedFakeLoaderDemoState extends State<AdvancedFakeLoaderDemo> {
  // Demo 1: Looping and max loops
  bool _loopUntilComplete = false;
  int _maxLoops = 3;
  int _currentLoopCount = 0;
  FakeLoaderController? _loopController;

  // Demo 2: Message effects comparison
  MessageEffect _selectedEffect = MessageEffect.fade;
  Duration _typewriterDelay = const Duration(milliseconds: 50);

  // Demo 3: Weighted message selection
  List<FakeMessage> _weightedMessages = [];
  bool _showWeights = true;

  // Demo 4: Custom transitions and animation curves
  Curve _animationCurve = Curves.easeInOut;
  String _selectedCurve = 'easeInOut';

  @override
  void initState() {
    super.initState();
    _loopController = FakeLoaderController();
    _setupWeightedMessages();
  }

  @override
  void dispose() {
    _loopController?.dispose();
    super.dispose();
  }

  void _setupWeightedMessages() {
    _weightedMessages = [
      FakeMessage.weighted('Common message (80%)', 0.8),
      FakeMessage.weighted('Uncommon message (15%)', 0.15),
      FakeMessage.weighted('Rare easter egg! (5%)', 0.05),
      FakeMessage.weighted('Super rare! (1%)', 0.01),
    ];
  }

  void _resetLoopDemo() {
    setState(() {
      _currentLoopCount = 0;
    });
    _loopController?.reset();
    _loopController?.start();
  }

  Curve _getCurveFromString(String curveName) {
    switch (curveName) {
      case 'easeIn':
        return Curves.easeIn;
      case 'easeOut':
        return Curves.easeOut;
      case 'easeInOut':
        return Curves.easeInOut;
      case 'bounceIn':
        return Curves.bounceIn;
      case 'bounceOut':
        return Curves.bounceOut;
      case 'elasticIn':
        return Curves.elasticIn;
      case 'elasticOut':
        return Curves.elasticOut;
      default:
        return Curves.easeInOut;
    }
  }

  Widget _buildEffectComparison() {
    return Row(
      children: MessageEffect.values.map((effect) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Text(
                  effect.name.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedEffect == effect
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dividerColor,
                      width: _selectedEffect == effect ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: FakeLoader(
                      key: ValueKey('effect_${effect.name}'),
                      messages: ['Demo ${effect.name}'],
                      effect: effect,
                      typewriterDelay: _typewriterDelay,
                      textStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Radio<MessageEffect>(
                  value: effect,
                  groupValue: _selectedEffect,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedEffect = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Demo 1: Looping and max loops
          DemoCard(
            title: 'Looping & Max Loops',
            description: 'Continuous looping with configurable limits',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: PropertyControl<bool>(
                        label: 'Loop Until Complete',
                        value: _loopUntilComplete,
                        type: PropertyControlType.toggle,
                        onChanged: (value) {
                          setState(() {
                            _loopUntilComplete = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PropertyControl<int>(
                        label: 'Max Loops',
                        value: _maxLoops,
                        type: PropertyControlType.slider,
                        options: {'min': 1, 'max': 10, 'divisions': 9},
                        onChanged: (value) {
                          setState(() {
                            _maxLoops = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: FakeLoader(
                      key: ValueKey('loop_${_loopUntilComplete}_$_maxLoops'),
                      controller: _loopController,
                      messages: SampleMessages.retroMessages.take(3).toList(),
                      loopUntilComplete: _loopUntilComplete,
                      maxLoops: _loopUntilComplete ? _maxLoops : null,
                      autoStart: false,
                      textStyle: theme.textTheme.bodyLarge,
                      onLoopComplete: () {
                        setState(() {
                          _currentLoopCount++;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Loops completed: $_currentLoopCount'),
                    ElevatedButton(
                      onPressed: _resetLoopDemo,
                      child: const Text('Start Demo'),
                    ),
                  ],
                ),
              ],
            ),
            codeSnippet:
                '''FakeLoader(
  messages: messages,
  loopUntilComplete: $_loopUntilComplete,
  maxLoops: ${_loopUntilComplete ? _maxLoops : 'null'},
  onLoopComplete: () {
    // Handle loop completion
  },
)''',
          ),

          const SizedBox(height: 24),

          // Demo 2: Message effects comparison
          DemoCard(
            title: 'Message Effects Comparison',
            description: 'Compare different animation effects side by side',
            child: Column(
              children: [
                if (_selectedEffect == MessageEffect.typewriter) ...[
                  PropertyControl<double>(
                    label: 'Typewriter Delay (ms)',
                    value: _typewriterDelay.inMilliseconds.toDouble(),
                    type: PropertyControlType.slider,
                    options: {'min': 10.0, 'max': 200.0, 'divisions': 19},
                    onChanged: (value) {
                      setState(() {
                        _typewriterDelay = Duration(
                          milliseconds: value.toInt(),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                _buildEffectComparison(),
                const SizedBox(height: 16),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: FakeLoader(
                      key: ValueKey('selected_effect_${_selectedEffect.name}'),
                      messages: SampleMessages.sciFiMessages.take(4).toList(),
                      effect: _selectedEffect,
                      typewriterDelay: _typewriterDelay,
                      textStyle: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
            codeSnippet:
                '''FakeLoader(
  messages: messages,
  effect: MessageEffect.${_selectedEffect.name},${_selectedEffect == MessageEffect.typewriter ? '\n  typewriterDelay: Duration(milliseconds: ${_typewriterDelay.inMilliseconds}),' : ''}
)''',
          ),

          const SizedBox(height: 24),

          // Demo 3: Weighted message selection
          DemoCard(
            title: 'Weighted Message Selection',
            description: 'Messages with different probability weights',
            child: Column(
              children: [
                PropertyControl<bool>(
                  label: 'Show Weights',
                  value: _showWeights,
                  type: PropertyControlType.toggle,
                  onChanged: (value) {
                    setState(() {
                      _showWeights = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (_showWeights) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Message Weights:',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        ..._weightedMessages.map((msg) {
                          final percentage = (msg.weight * 100).toStringAsFixed(
                            0,
                          );
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _getWeightColor(msg.weight),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    msg.text,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                                Text(
                                  '$percentage%',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: FakeLoader(
                      key: ValueKey(
                        'weighted_${DateTime.now().millisecondsSinceEpoch}',
                      ),
                      messages: _weightedMessages,
                      randomOrder: true,
                      textStyle: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap "Reset Demo" multiple times to see weight distribution',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            codeSnippet: '''final weightedMessages = [
  FakeMessage.weighted('Common message (80%)', 0.8),
  FakeMessage.weighted('Uncommon message (15%)', 0.15),
  FakeMessage.weighted('Rare easter egg! (5%)', 0.05),
  FakeMessage.weighted('Super rare! (1%)', 0.01),
];

FakeLoader(
  messages: weightedMessages,
  randomOrder: true,
)''',
          ),

          const SizedBox(height: 24),

          // Demo 4: Custom transitions and animation curves
          DemoCard(
            title: 'Animation Curves',
            description: 'Different animation curves for message transitions',
            child: Column(
              children: [
                PropertyControl<String>(
                  label: 'Animation Curve',
                  value: _selectedCurve,
                  type: PropertyControlType.dropdown,
                  options: {
                    'items': [
                      'easeIn',
                      'easeOut',
                      'easeInOut',
                      'bounceIn',
                      'bounceOut',
                      'elasticIn',
                      'elasticOut',
                    ],
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedCurve = value;
                      _animationCurve = _getCurveFromString(value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: FakeLoader(
                      key: ValueKey('curve_$_selectedCurve'),
                      messages: SampleMessages.cookingMessages.take(4).toList(),
                      animationCurve: _animationCurve,
                      textStyle: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Animation curve: $_selectedCurve',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            codeSnippet:
                '''FakeLoader(
  messages: messages,
  animationCurve: Curves.$_selectedCurve,
)''',
          ),
        ],
      ),
    );
  }

  Color _getWeightColor(double weight) {
    if (weight >= 0.5) return Colors.green;
    if (weight >= 0.1) return Colors.orange;
    if (weight >= 0.05) return Colors.red;
    return Colors.purple;
  }
}

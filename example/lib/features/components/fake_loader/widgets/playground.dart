import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/demo_card.dart';
import '../../../../core/widgets/property_control.dart';
import '../../../../core/widgets/code_display.dart';
import '../../../../core/data/sample_messages.dart';

/// Interactive playground for FakeLoader customization
class FakeLoaderPlayground extends StatefulWidget {
  const FakeLoaderPlayground({super.key});

  @override
  State<FakeLoaderPlayground> createState() => _FakeLoaderPlaygroundState();
}

class _FakeLoaderPlaygroundState extends State<FakeLoaderPlayground> {
  // Controller for the playground
  FakeLoaderController? _playgroundController;

  // Configuration properties
  String _selectedMessagePack = 'Fun & Quirky';
  Duration _messageDuration = const Duration(seconds: 2);
  bool _randomOrder = false;
  bool _autoStart = true;
  bool _showProgress = false;
  bool _loopUntilComplete = false;
  int _maxLoops = 3;
  MessageEffect _effect = MessageEffect.fade;
  Duration _typewriterDelay = const Duration(milliseconds: 50);
  Curve _animationCurve = Curves.easeInOut;
  String _selectedCurve = 'easeInOut';
  double _spacingBetweenSpinnerAndText = 16.0;
  TextAlign _textAlign = TextAlign.center;
  String _spinnerType = 'None';
  final Color _progressColor = Colors.blue;

  // Preset configurations
  final Map<String, Map<String, dynamic>> _presets = {
    'Default': {
      'messagePack': 'Basic',
      'duration': const Duration(seconds: 2),
      'randomOrder': false,
      'effect': MessageEffect.fade,
      'showProgress': false,
      'loopUntilComplete': false,
    },
    'Gaming': {
      'messagePack': 'Gaming',
      'duration': const Duration(milliseconds: 1500),
      'randomOrder': true,
      'effect': MessageEffect.scale,
      'showProgress': true,
      'loopUntilComplete': false,
    },
    'Typewriter': {
      'messagePack': 'Sci-Fi',
      'duration': const Duration(seconds: 3),
      'randomOrder': false,
      'effect': MessageEffect.typewriter,
      'showProgress': false,
      'loopUntilComplete': false,
    },
    'Continuous': {
      'messagePack': 'Tech Startup',
      'duration': const Duration(milliseconds: 1000),
      'randomOrder': true,
      'effect': MessageEffect.slide,
      'showProgress': true,
      'loopUntilComplete': true,
    },
  };

  @override
  void initState() {
    super.initState();
    _playgroundController = FakeLoaderController();
  }

  @override
  void dispose() {
    _playgroundController?.dispose();
    super.dispose();
  }

  void _applyPreset(String presetName) {
    final preset = _presets[presetName];
    if (preset == null) return;

    setState(() {
      _selectedMessagePack = preset['messagePack'] as String;
      _messageDuration = preset['duration'] as Duration;
      _randomOrder = preset['randomOrder'] as bool;
      _effect = preset['effect'] as MessageEffect;
      _showProgress = preset['showProgress'] as bool;
      _loopUntilComplete = preset['loopUntilComplete'] as bool;
    });

    _resetPlayground();
  }

  void _resetPlayground() {
    _playgroundController?.reset();
    if (_autoStart) {
      _playgroundController?.start();
    }
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

  Widget? _buildSpinner() {
    switch (_spinnerType) {
      case 'Circular':
        return const CircularProgressIndicator();
      case 'Linear':
        return const SizedBox(width: 100, child: LinearProgressIndicator());
      case 'Custom':
        return const Icon(Icons.hourglass_empty, size: 24);
      case 'None':
      default:
        return null;
    }
  }

  String _generateCode() {
    final properties = <String, dynamic>{
      'messages':
          'SampleMessages.${_selectedMessagePack.toLowerCase().replaceAll(' & ', '').replaceAll(' ', '')}Messages',
      'messageDuration':
          'Duration(milliseconds: ${_messageDuration.inMilliseconds})',
      'randomOrder': _randomOrder,
      'autoStart': _autoStart,
      'showProgress': _showProgress,
      'effect': 'MessageEffect.${_effect.name}',
      'textAlign': 'TextAlign.${_textAlign.name}',
      'animationCurve': 'Curves.$_selectedCurve',
      'spacingBetweenSpinnerAndText': _spacingBetweenSpinnerAndText,
    };

    if (_effect == MessageEffect.typewriter) {
      properties['typewriterDelay'] =
          'Duration(milliseconds: ${_typewriterDelay.inMilliseconds})';
    }

    if (_loopUntilComplete) {
      properties['loopUntilComplete'] = true;
      properties['maxLoops'] = _maxLoops;
    }

    if (_spinnerType != 'None') {
      properties['spinner'] = _getSpinnerCodeString();
    }

    if (_showProgress) {
      properties['progressColor'] = 'Colors.blue';
    }

    final buffer = StringBuffer();
    buffer.writeln('FakeLoader(');

    properties.forEach((key, value) {
      if (value is String &&
          !value.startsWith('Duration') &&
          !value.startsWith('MessageEffect') &&
          !value.startsWith('TextAlign') &&
          !value.startsWith('Curves') &&
          !value.startsWith('SampleMessages') &&
          !value.startsWith('Colors') &&
          !value.startsWith('CircularProgressIndicator')) {
        buffer.writeln('  $key: \'$value\',');
      } else {
        buffer.writeln('  $key: $value,');
      }
    });

    buffer.writeln(')');
    return buffer.toString();
  }

  String _getSpinnerCodeString() {
    switch (_spinnerType) {
      case 'Circular':
        return 'CircularProgressIndicator()';
      case 'Linear':
        return 'SizedBox(width: 100, child: LinearProgressIndicator())';
      case 'Custom':
        return 'Icon(Icons.hourglass_empty, size: 24)';
      default:
        return 'null';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Preset configurations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preset Configurations',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _presets.keys.map((presetName) {
                      return ElevatedButton(
                        onPressed: () => _applyPreset(presetName),
                        child: Text(presetName),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Live preview
          DemoCard(
            title: 'Live Preview',
            description: 'Real-time preview of your configuration',
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: FakeLoader(
                      key: ValueKey(
                        'playground_${DateTime.now().millisecondsSinceEpoch}',
                      ),
                      controller: _playgroundController,
                      messages: SampleMessages.getMessagesByCategory(
                        _selectedMessagePack,
                      ),
                      messageDuration: _messageDuration,
                      randomOrder: _randomOrder,
                      autoStart: _autoStart,
                      showProgress: _showProgress,
                      loopUntilComplete: _loopUntilComplete,
                      maxLoops: _loopUntilComplete ? _maxLoops : null,
                      effect: _effect,
                      typewriterDelay: _typewriterDelay,
                      animationCurve: _animationCurve,
                      textAlign: _textAlign,
                      spacingBetweenSpinnerAndText:
                          _spacingBetweenSpinnerAndText,
                      spinner: _buildSpinner(),
                      progressColor: _progressColor,
                      textStyle: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _playgroundController?.start();
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _playgroundController?.stop();
                      },
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _resetPlayground,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Property controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuration Properties',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),

                  // Basic properties
                  PropertyControl<String>(
                    label: 'Message Pack',
                    value: _selectedMessagePack,
                    type: PropertyControlType.dropdown,
                    options: {'items': SampleMessages.getAvailableCategories()},
                    onChanged: (value) {
                      setState(() {
                        _selectedMessagePack = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: PropertyControl<double>(
                          label: 'Message Duration (ms)',
                          value: _messageDuration.inMilliseconds.toDouble(),
                          type: PropertyControlType.slider,
                          options: {
                            'min': 500.0,
                            'max': 5000.0,
                            'divisions': 45,
                          },
                          onChanged: (value) {
                            setState(() {
                              _messageDuration = Duration(
                                milliseconds: value.toInt(),
                              );
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PropertyControl<MessageEffect>(
                          label: 'Effect',
                          value: _effect,
                          type: PropertyControlType.dropdown,
                          options: {
                            'items': MessageEffect.values,
                            'itemLabels': MessageEffect.values
                                .map((e) => e.name)
                                .toList(),
                          },
                          onChanged: (value) {
                            setState(() {
                              _effect = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (_effect == MessageEffect.typewriter) ...[
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

                  // Boolean properties
                  Row(
                    children: [
                      Expanded(
                        child: PropertyControl<bool>(
                          label: 'Random Order',
                          value: _randomOrder,
                          type: PropertyControlType.toggle,
                          onChanged: (value) {
                            setState(() {
                              _randomOrder = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PropertyControl<bool>(
                          label: 'Auto Start',
                          value: _autoStart,
                          type: PropertyControlType.toggle,
                          onChanged: (value) {
                            setState(() {
                              _autoStart = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: PropertyControl<bool>(
                          label: 'Show Progress',
                          value: _showProgress,
                          type: PropertyControlType.toggle,
                          onChanged: (value) {
                            setState(() {
                              _showProgress = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
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
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (_loopUntilComplete) ...[
                    PropertyControl<int>(
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
                    const SizedBox(height: 16),
                  ],

                  // Styling properties
                  Row(
                    children: [
                      Expanded(
                        child: PropertyControl<String>(
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
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PropertyControl<TextAlign>(
                          label: 'Text Align',
                          value: _textAlign,
                          type: PropertyControlType.dropdown,
                          options: {
                            'items': [
                              TextAlign.left,
                              TextAlign.center,
                              TextAlign.right,
                            ],
                            'itemLabels': ['Left', 'Center', 'Right'],
                          },
                          onChanged: (value) {
                            setState(() {
                              _textAlign = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: PropertyControl<String>(
                          label: 'Spinner Type',
                          value: _spinnerType,
                          type: PropertyControlType.dropdown,
                          options: {
                            'items': ['None', 'Circular', 'Linear', 'Custom'],
                          },
                          onChanged: (value) {
                            setState(() {
                              _spinnerType = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PropertyControl<double>(
                          label: 'Spinner Spacing',
                          value: _spacingBetweenSpinnerAndText,
                          type: PropertyControlType.slider,
                          options: {'min': 0.0, 'max': 50.0, 'divisions': 50},
                          onChanged: (value) {
                            setState(() {
                              _spacingBetweenSpinnerAndText = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Generated code
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Generated Code',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  CodeDisplay(code: _generateCode(), language: 'dart'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

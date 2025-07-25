import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/demo_card.dart';
import '../../../../core/widgets/property_control.dart';
import '../../../../core/data/sample_messages.dart';

/// Basic FakeLoader demonstrations with simple usage examples
class BasicFakeLoaderDemo extends StatefulWidget {
  const BasicFakeLoaderDemo({super.key});

  @override
  State<BasicFakeLoaderDemo> createState() => _BasicFakeLoaderDemoState();
}

class _BasicFakeLoaderDemoState extends State<BasicFakeLoaderDemo> {
  // Demo 1: Simple message list
  FakeLoaderController? _simpleController;
  bool _simpleAutoStart = true;
  String _selectedMessagePack = 'Basic';

  // Demo 2: Controller demonstration
  FakeLoaderController? _controllerDemo;
  bool _isControllerRunning = false;

  // Demo 3: Random order and duration
  bool _randomOrder = false;
  Duration _messageDuration = const Duration(seconds: 2);

  // Demo 4: Spinner customization
  Widget? _selectedSpinner;
  String _spinnerType = 'Default';

  @override
  void initState() {
    super.initState();
    _simpleController = FakeLoaderController();
    _controllerDemo = FakeLoaderController();
    _selectedSpinner = const CircularProgressIndicator();
  }

  @override
  void dispose() {
    _simpleController?.dispose();
    _controllerDemo?.dispose();
    super.dispose();
  }

  void _resetSimpleDemo() {
    _simpleController?.reset();
    if (_simpleAutoStart) {
      _simpleController?.start();
    }
  }

  void _startControllerDemo() {
    setState(() {
      _isControllerRunning = true;
    });
    _controllerDemo?.start();
  }

  void _stopControllerDemo() {
    setState(() {
      _isControllerRunning = false;
    });
    _controllerDemo?.stop();
  }

  void _resetControllerDemo() {
    setState(() {
      _isControllerRunning = false;
    });
    _controllerDemo?.reset();
  }

  Widget _buildSpinner(String type) {
    switch (type) {
      case 'Circular':
        return const CircularProgressIndicator();
      case 'Linear':
        return const SizedBox(width: 100, child: LinearProgressIndicator());
      case 'Custom':
        return const Icon(Icons.hourglass_empty, size: 24);
      case 'Dots':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      default:
        return const CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Demo 1: Simple message list
          DemoCard(
            title: 'Simple Message List',
            description: 'Basic usage with predefined message packs',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: PropertyControl<String>(
                        label: 'Message Pack',
                        value: _selectedMessagePack,
                        type: PropertyControlType.dropdown,
                        options: {
                          'items': SampleMessages.getAvailableCategories(),
                        },
                        onChanged: (value) {
                          setState(() {
                            _selectedMessagePack = value;
                          });
                          _resetSimpleDemo();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    PropertyControl<bool>(
                      label: 'Auto Start',
                      value: _simpleAutoStart,
                      type: PropertyControlType.toggle,
                      onChanged: (value) {
                        setState(() {
                          _simpleAutoStart = value;
                        });
                        _resetSimpleDemo();
                      },
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
                      key: ValueKey('simple_$_selectedMessagePack'),
                      controller: _simpleController,
                      messages: SampleMessages.getMessagesByCategory(
                        _selectedMessagePack,
                      ),
                      autoStart: _simpleAutoStart,
                      textStyle: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _resetSimpleDemo,
                  child: const Text('Reset Demo'),
                ),
              ],
            ),
            codeSnippet:
                '''FakeLoader(
  messages: ${_selectedMessagePack == 'Basic' ? 'SampleMessages.basicMessages' : 'SampleMessages.${_selectedMessagePack.toLowerCase()}Messages'},
  autoStart: $_simpleAutoStart,
)''',
          ),

          const SizedBox(height: 24),

          // Demo 2: Controller demonstration
          DemoCard(
            title: 'Controller Demonstration',
            description:
                'Programmatic control with start/stop/reset functionality',
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: FakeLoader(
                      controller: _controllerDemo,
                      messages: SampleMessages.funMessages,
                      autoStart: false,
                      textStyle: theme.textTheme.bodyLarge,
                      onComplete: () {
                        setState(() {
                          _isControllerRunning = false;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isControllerRunning
                          ? null
                          : _startControllerDemo,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isControllerRunning
                          ? _stopControllerDemo
                          : null,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _resetControllerDemo,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: ${_isControllerRunning ? 'Running' : 'Stopped'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _isControllerRunning ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
            codeSnippet: '''final controller = FakeLoaderController();

FakeLoader(
  controller: controller,
  messages: SampleMessages.funMessages,
  autoStart: false,
  onComplete: () {
    // Handle completion
  },
)

// Control methods
controller.start();
controller.stop();
controller.reset();''',
          ),

          const SizedBox(height: 24),

          // Demo 3: Random order and duration
          DemoCard(
            title: 'Random Order & Duration',
            description: 'Customize message order and timing',
            child: Column(
              children: [
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
                      child: PropertyControl<double>(
                        label: 'Message Duration (ms)',
                        value: _messageDuration.inMilliseconds.toDouble(),
                        type: PropertyControlType.slider,
                        options: {'min': 500.0, 'max': 5000.0, 'divisions': 45},
                        onChanged: (value) {
                          setState(() {
                            _messageDuration = Duration(
                              milliseconds: value.toInt(),
                            );
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
                      key: ValueKey(
                        'random_${_randomOrder}_${_messageDuration.inMilliseconds}',
                      ),
                      messages: SampleMessages.techStartupMessages,
                      randomOrder: _randomOrder,
                      messageDuration: _messageDuration,
                      textStyle: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
            codeSnippet:
                '''FakeLoader(
  messages: SampleMessages.techStartupMessages,
  randomOrder: $_randomOrder,
  messageDuration: Duration(milliseconds: ${_messageDuration.inMilliseconds}),
)''',
          ),

          const SizedBox(height: 24),

          // Demo 4: Spinner customization
          DemoCard(
            title: 'Spinner Customization',
            description:
                'Different spinner types and custom loading indicators',
            child: Column(
              children: [
                PropertyControl<String>(
                  label: 'Spinner Type',
                  value: _spinnerType,
                  type: PropertyControlType.dropdown,
                  options: {
                    'items': [
                      'Default',
                      'Circular',
                      'Linear',
                      'Custom',
                      'Dots',
                    ],
                  },
                  onChanged: (value) {
                    setState(() {
                      _spinnerType = value;
                      _selectedSpinner = _buildSpinner(value);
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
                      key: ValueKey('spinner_$_spinnerType'),
                      messages: SampleMessages.gamingMessages,
                      spinner: _spinnerType == 'Default'
                          ? null
                          : _selectedSpinner,
                      textStyle: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
            codeSnippet:
                '''FakeLoader(
  messages: SampleMessages.gamingMessages,
  spinner: ${_spinnerType == 'Default' ? 'null' : _getSpinnerCode(_spinnerType)},
)''',
          ),
        ],
      ),
    );
  }

  String _getSpinnerCode(String type) {
    switch (type) {
      case 'Circular':
        return 'CircularProgressIndicator()';
      case 'Linear':
        return '''SizedBox(
  width: 100,
  child: LinearProgressIndicator(),
)''';
      case 'Custom':
        return 'Icon(Icons.hourglass_empty, size: 24)';
      case 'Dots':
        return '''Row(
  mainAxisSize: MainAxisSize.min,
  children: List.generate(3, (index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
    );
  }),
)''';
      default:
        return 'CircularProgressIndicator()';
    }
  }
}

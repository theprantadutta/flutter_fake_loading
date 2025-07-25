import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';

/// Demonstrates TypewriterText integration with other loading components.
class IntegrationDemo extends StatefulWidget {
  const IntegrationDemo({super.key});

  @override
  State<IntegrationDemo> createState() => _IntegrationDemoState();
}

class _IntegrationDemoState extends State<IntegrationDemo> {
  final Map<String, Widget Function()> _integrationExamples = {};
  String _selectedExample = 'Progress + Typewriter';

  @override
  void initState() {
    super.initState();
    _integrationExamples.addAll({
      'Progress + Typewriter': _buildProgressTypewriterExample,
      'FakeLoader + Typewriter': _buildFakeLoaderExample,
      'Multi-step Loading': _buildMultiStepExample,
      'Loading Screen': _buildLoadingScreenExample,
    });
  }

  Widget _buildProgressTypewriterExample() {
    return _ProgressTypewriterWidget(
      key: ValueKey('progress-${DateTime.now().millisecondsSinceEpoch}'),
    );
  }

  Widget _buildFakeLoaderExample() {
    return _FakeLoaderIntegrationWidget(
      key: ValueKey('loader-${DateTime.now().millisecondsSinceEpoch}'),
    );
  }

  Widget _buildMultiStepExample() {
    return _MultiStepLoadingWidget(
      key: ValueKey('multistep-${DateTime.now().millisecondsSinceEpoch}'),
    );
  }

  Widget _buildLoadingScreenExample() {
    return _LoadingScreenPreviewWidget(
      key: ValueKey('screen-${DateTime.now().millisecondsSinceEpoch}'),
    );
  }

  String _generateCode() {
    switch (_selectedExample) {
      case 'Progress + Typewriter':
        return '''
// Combine progress indicator with typewriter text
Column(
  children: [
    TypewriterText(
      text: 'Loading your data...',
      style: TextStyle(fontSize: 18),
      onComplete: () => startProgress(),
    ),
    SizedBox(height: 16),
    FakeProgressIndicator(
      duration: Duration(seconds: 3),
    ),
  ],
)''';
      case 'FakeLoader + Typewriter':
        return '''
// Use typewriter effect in FakeLoader messages
FakeLoader(
  messages: [
    FakeMessage('Initializing system...', effect: MessageEffect.typewriter),
    FakeMessage('Loading components...', effect: MessageEffect.typewriter),
    FakeMessage('Almost ready!', effect: MessageEffect.typewriter),
  ],
  messageDuration: Duration(seconds: 3),
)''';
      case 'Multi-step Loading':
        return '''
// Multi-step loading with typewriter feedback
class MultiStepLoader extends StatefulWidget {
  @override
  _MultiStepLoaderState createState() => _MultiStepLoaderState();
}

class _MultiStepLoaderState extends State<MultiStepLoader> {
  int currentStep = 0;
  final steps = [
    'Connecting to server...',
    'Authenticating user...',
    'Loading preferences...',
    'Preparing interface...',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TypewriterText(
          text: steps[currentStep],
          onComplete: () => nextStep(),
        ),
        LinearProgressIndicator(
          value: (currentStep + 1) / steps.length,
        ),
      ],
    );
  }
}''';
      case 'Loading Screen':
        return '''
// Full loading screen with typewriter messages
FakeLoadingScreen(
  messages: [
    'Welcome to our app!',
    'Setting up your workspace...',
    'Loading your preferences...',
    'Almost ready!',
  ],
  messageEffect: MessageEffect.typewriter,
  showProgress: true,
  duration: Duration(seconds: 8),
)''';
      default:
        return '';
    }
  }

  void _restartDemo() {
    setState(() {
      // Force rebuild by changing the selected example temporarily
      final temp = _selectedExample;
      _selectedExample = '';
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          _selectedExample = temp;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: 'Integration with Other Components',
      description:
          'TypewriterText combined with progress indicators and loading screens',
      codeSnippet: _generateCode(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Demo area
          Container(
            width: double.infinity,
            height: 200,
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
            child: Center(child: _integrationExamples[_selectedExample]!()),
          ),

          const SizedBox(height: 16),

          // Example selection
          const Text(
            'Integration Examples:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _integrationExamples.keys.map((key) {
              final isSelected = key == _selectedExample;
              return FilterChip(
                label: Text(key),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedExample = key);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Control button
          ElevatedButton.icon(
            onPressed: _restartDemo,
            icon: const Icon(Icons.refresh),
            label: const Text('Restart Demo'),
          ),
        ],
      ),
    );
  }
}

// Progress + Typewriter integration widget
class _ProgressTypewriterWidget extends StatefulWidget {
  const _ProgressTypewriterWidget({super.key});

  @override
  State<_ProgressTypewriterWidget> createState() =>
      _ProgressTypewriterWidgetState();
}

class _ProgressTypewriterWidgetState extends State<_ProgressTypewriterWidget> {
  bool _showProgress = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TypewriterText(
          text: 'Preparing your data for processing...',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          characterDelay: const Duration(milliseconds: 60),
          onComplete: () {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() => _showProgress = true);
              }
            });
          },
        ),
        const SizedBox(height: 16),
        if (_showProgress)
          SizedBox(
            width: 200,
            child: FakeProgressIndicator(
              duration: const Duration(seconds: 3),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );
  }
}

// FakeLoader integration widget
class _FakeLoaderIntegrationWidget extends StatelessWidget {
  const _FakeLoaderIntegrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FakeLoader(
      messages: [
        FakeMessage(
          'Initializing system components...',
          effect: MessageEffect.typewriter,
        ),
        FakeMessage(
          'Loading user preferences...',
          effect: MessageEffect.typewriter,
        ),
        FakeMessage(
          'Preparing interface elements...',
          effect: MessageEffect.typewriter,
        ),
        FakeMessage('System ready!', effect: MessageEffect.typewriter),
      ],
      messageDuration: const Duration(seconds: 2),
      textStyle: const TextStyle(fontSize: 14),
    );
  }
}

// Multi-step loading widget
class _MultiStepLoadingWidget extends StatefulWidget {
  const _MultiStepLoadingWidget({super.key});

  @override
  State<_MultiStepLoadingWidget> createState() =>
      _MultiStepLoadingWidgetState();
}

class _MultiStepLoadingWidgetState extends State<_MultiStepLoadingWidget> {
  int _currentStep = 0;
  final List<String> _steps = [
    'Connecting to server...',
    'Authenticating user...',
    'Loading preferences...',
    'Preparing interface...',
    'Complete!',
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _currentStep++);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TypewriterText(
          key: ValueKey(_currentStep),
          text: _steps[_currentStep],
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          characterDelay: const Duration(milliseconds: 40),
          onComplete: _nextStep,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / _steps.length,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Step ${_currentStep + 1} of ${_steps.length}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// Loading screen preview widget
class _LoadingScreenPreviewWidget extends StatelessWidget {
  const _LoadingScreenPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TypewriterText(
            text: 'Welcome to our app!',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            characterDelay: Duration(milliseconds: 80),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          SizedBox(
            width: 100,
            height: 4,
            child: FakeProgressIndicator(duration: Duration(seconds: 4)),
          ),
        ],
      ),
    );
  }
}

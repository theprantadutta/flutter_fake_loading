import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/code_generator.dart';

/// Demonstrates progress state tracking and callbacks
class ProgressCallbacksDemo extends StatefulWidget {
  const ProgressCallbacksDemo({super.key});

  @override
  State<ProgressCallbacksDemo> createState() => _ProgressCallbacksDemoState();
}

class _ProgressCallbacksDemoState extends State<ProgressCallbacksDemo> {
  ProgressState? _currentState;
  bool _isComplete = false;
  final List<String> _progressLog = [];
  int _restartCount = 0;

  void _onProgressChanged(ProgressState state) {
    setState(() {
      _currentState = state;

      // Log significant progress milestones
      final percentage = state.progressPercentage.round();
      if (percentage % 10 == 0 && percentage > 0) {
        final logEntry =
            '$percentage% - ${state.elapsed.inMilliseconds}ms elapsed';
        if (_progressLog.isEmpty || _progressLog.last != logEntry) {
          _progressLog.add(logEntry);
          if (_progressLog.length > 10) {
            _progressLog.removeAt(0);
          }
        }
      }
    });
  }

  void _onComplete() {
    setState(() {
      _isComplete = true;
      _progressLog.add(
        '✅ Complete! Total time: ${_currentState?.elapsed.inMilliseconds}ms',
      );
    });
  }

  void _restart() {
    setState(() {
      _currentState = null;
      _isComplete = false;
      _progressLog.clear();
      _restartCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Real-time progress tracking
        DemoCard(
          title: 'Real-time Progress Tracking',
          description: 'Monitor progress state changes and completion events',
          codeSnippet: CodeGenerator.generateFakeProgressIndicatorCode({
            'duration': 'Duration(seconds: 5)',
            'onProgressChanged':
                '(ProgressState state) {\n  print("Progress: \${state.progressPercentage.toStringAsFixed(1)}%");\n}',
            'onComplete': '() {\n  print("Progress completed!");\n}',
          }),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FakeProgressIndicator(
                key: ValueKey('progress_tracking_$_restartCount'),
                duration: const Duration(seconds: 5),
                height: 8,
                color: Colors.blue,
                onProgressChanged: _onProgressChanged,
                onComplete: _onComplete,
              ),

              const SizedBox(height: 16),

              // Current state display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current State',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    if (_currentState != null) ...[
                      _StateInfoRow(
                        label: 'Progress',
                        value:
                            '${_currentState!.progressPercentage.toStringAsFixed(1)}%',
                        icon: Icons.trending_up,
                      ),
                      _StateInfoRow(
                        label: 'Elapsed',
                        value:
                            '${(_currentState!.elapsed.inMilliseconds / 1000).toStringAsFixed(1)}s',
                        icon: Icons.timer,
                      ),
                      if (_currentState!.estimatedRemaining != null)
                        _StateInfoRow(
                          label: 'Remaining',
                          value:
                              '${(_currentState!.estimatedRemaining!.inMilliseconds / 1000).toStringAsFixed(1)}s',
                          icon: Icons.hourglass_bottom,
                        ),
                      _StateInfoRow(
                        label: 'Status',
                        value: _isComplete ? 'Complete' : 'In Progress',
                        icon: _isComplete
                            ? Icons.check_circle
                            : Icons.hourglass_empty,
                        valueColor: _isComplete ? Colors.green : null,
                      ),
                    ] else ...[
                      const Text('No progress data yet'),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Progress log
              Container(
                width: double.infinity,
                height: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Log',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _progressLog.isEmpty
                          ? const Text('Progress events will appear here...')
                          : ListView.builder(
                              itemCount: _progressLog.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    _progressLog[index],
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontFamily: 'monospace'),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _restart,
                icon: const Icon(Icons.refresh),
                label: const Text('Restart Demo'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Multiple progress indicators with different callbacks
        DemoCard(
          title: 'Multiple Progress Indicators',
          description:
              'Different progress indicators with individual state tracking',
          codeSnippet: '''
// Each indicator can have its own callbacks
FakeProgressIndicator(
  onProgressChanged: (state) => handleProgress1(state),
  onComplete: () => onComplete1(),
),
FakeProgressIndicator(
  onProgressChanged: (state) => handleProgress2(state),
  onComplete: () => onComplete2(),
),''',
          child: const _MultipleProgressDemo(),
        ),
      ],
    );
  }
}

class _StateInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _StateInfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _MultipleProgressDemo extends StatefulWidget {
  const _MultipleProgressDemo();

  @override
  State<_MultipleProgressDemo> createState() => _MultipleProgressDemoState();
}

class _MultipleProgressDemoState extends State<_MultipleProgressDemo> {
  final Map<String, ProgressState?> _states = {
    'Fast': null,
    'Medium': null,
    'Slow': null,
  };

  final Map<String, bool> _completions = {
    'Fast': false,
    'Medium': false,
    'Slow': false,
  };

  int _restartCount = 0;

  void _onProgressChanged(String key, ProgressState state) {
    setState(() {
      _states[key] = state;
    });
  }

  void _onComplete(String key) {
    setState(() {
      _completions[key] = true;
    });
  }

  void _restart() {
    setState(() {
      _states.updateAll((key, value) => null);
      _completions.updateAll((key, value) => false);
      _restartCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allComplete = _completions.values.every((complete) => complete);

    return Column(
      children: [
        // Progress indicators
        _MultiProgressItem(
          key: ValueKey('fast_$_restartCount'),
          title: 'Fast (2s)',
          duration: const Duration(seconds: 2),
          color: Colors.red,
          state: _states['Fast'],
          isComplete: _completions['Fast']!,
          onProgressChanged: (state) => _onProgressChanged('Fast', state),
          onComplete: () => _onComplete('Fast'),
        ),

        const SizedBox(height: 12),

        _MultiProgressItem(
          key: ValueKey('medium_$_restartCount'),
          title: 'Medium (4s)',
          duration: const Duration(seconds: 4),
          color: Colors.blue,
          state: _states['Medium'],
          isComplete: _completions['Medium']!,
          onProgressChanged: (state) => _onProgressChanged('Medium', state),
          onComplete: () => _onComplete('Medium'),
        ),

        const SizedBox(height: 12),

        _MultiProgressItem(
          key: ValueKey('slow_$_restartCount'),
          title: 'Slow (6s)',
          duration: const Duration(seconds: 6),
          color: Colors.green,
          state: _states['Slow'],
          isComplete: _completions['Slow']!,
          onProgressChanged: (state) => _onProgressChanged('Slow', state),
          onComplete: () => _onComplete('Slow'),
        ),

        const SizedBox(height: 16),

        // Overall status
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: allComplete
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: allComplete ? Colors.green : Colors.grey),
          ),
          child: Row(
            children: [
              Icon(
                allComplete ? Icons.check_circle : Icons.hourglass_empty,
                color: allComplete ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                allComplete
                    ? 'All progress indicators completed!'
                    : 'Progress indicators running...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: allComplete ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        ElevatedButton.icon(
          onPressed: _restart,
          icon: const Icon(Icons.refresh),
          label: const Text('Restart All'),
        ),
      ],
    );
  }
}

class _MultiProgressItem extends StatelessWidget {
  final String title;
  final Duration duration;
  final Color color;
  final ProgressState? state;
  final bool isComplete;
  final Function(ProgressState) onProgressChanged;
  final VoidCallback onComplete;

  const _MultiProgressItem({
    super.key,
    required this.title,
    required this.duration,
    required this.color,
    required this.state,
    required this.isComplete,
    required this.onProgressChanged,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (state != null)
                Text(
                  '${state!.progressPercentage.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          FakeProgressIndicator(
            duration: duration,
            height: 6,
            color: color,
            onProgressChanged: onProgressChanged,
            onComplete: onComplete,
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                isComplete ? Icons.check_circle : Icons.hourglass_empty,
                size: 14,
                color: isComplete ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                isComplete
                    ? 'Complete'
                    : state != null
                    ? 'Elapsed: ${(state!.elapsed.inMilliseconds / 1000).toStringAsFixed(1)}s'
                    : 'Starting...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isComplete ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

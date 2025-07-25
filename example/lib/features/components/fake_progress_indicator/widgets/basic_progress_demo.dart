import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/code_generator.dart';

/// Demonstrates basic FakeProgressIndicator usage
class BasicProgressDemo extends StatefulWidget {
  const BasicProgressDemo({super.key});

  @override
  State<BasicProgressDemo> createState() => _BasicProgressDemoState();
}

class _BasicProgressDemoState extends State<BasicProgressDemo> {
  final List<GlobalKey<_ProgressDemoItemState>> _demoKeys = [
    GlobalKey<_ProgressDemoItemState>(),
    GlobalKey<_ProgressDemoItemState>(),
    GlobalKey<_ProgressDemoItemState>(),
    GlobalKey<_ProgressDemoItemState>(),
  ];

  void _restartAll() {
    for (final key in _demoKeys) {
      key.currentState?.restart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Basic Progress Examples',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton.icon(
              onPressed: _restartAll,
              icon: const Icon(Icons.refresh),
              label: const Text('Restart All'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Default progress indicator
        _ProgressDemoItem(
          key: _demoKeys[0],
          title: 'Default Progress',
          description: 'Basic progress indicator with default styling',
          progressIndicator: const FakeProgressIndicator(
            duration: Duration(seconds: 3),
          ),
          codeSnippet: CodeGenerator.generateFakeProgressIndicatorCode({
            'duration': 'Duration(seconds: 3)',
          }),
        ),

        const SizedBox(height: 16),

        // Custom color and height
        _ProgressDemoItem(
          key: _demoKeys[1],
          title: 'Custom Styling',
          description: 'Progress with custom color, height, and border radius',
          progressIndicator: FakeProgressIndicator(
            duration: const Duration(seconds: 4),
            color: Colors.green,
            backgroundColor: Colors.green.withValues(alpha: 0.2),
            height: 8.0,
            borderRadius: BorderRadius.circular(4.0),
          ),
          codeSnippet: CodeGenerator.generateFakeProgressIndicatorCode({
            'duration': 'Duration(seconds: 4)',
            'color': 'Colors.green',
            'backgroundColor': 'Colors.green.withValues(alpha: 0.2)',
            'height': '8.0',
            'borderRadius': 'BorderRadius.circular(4.0)',
          }),
        ),

        const SizedBox(height: 16),

        // Thick progress bar
        _ProgressDemoItem(
          key: _demoKeys[2],
          title: 'Thick Progress Bar',
          description: 'Thicker progress bar with rounded corners',
          progressIndicator: FakeProgressIndicator(
            duration: const Duration(seconds: 2),
            color: Colors.purple,
            backgroundColor: Colors.purple.withValues(alpha: 0.1),
            height: 12.0,
            borderRadius: BorderRadius.circular(6.0),
          ),
          codeSnippet: CodeGenerator.generateFakeProgressIndicatorCode({
            'duration': 'Duration(seconds: 2)',
            'color': 'Colors.purple',
            'backgroundColor': 'Colors.purple.withValues(alpha: 0.1)',
            'height': '12.0',
            'borderRadius': 'BorderRadius.circular(6.0)',
          }),
        ),

        const SizedBox(height: 16),

        // Manual start
        _ProgressDemoItem(
          key: _demoKeys[3],
          title: 'Manual Start',
          description: 'Progress that starts manually with button control',
          progressIndicator: const FakeProgressIndicator(
            duration: Duration(seconds: 3),
            autoStart: false,
            color: Colors.orange,
          ),
          codeSnippet: CodeGenerator.generateFakeProgressIndicatorCode({
            'duration': 'Duration(seconds: 3)',
            'autoStart': 'false',
            'color': 'Colors.orange',
          }),
          showManualControls: true,
        ),
      ],
    );
  }
}

class _ProgressDemoItem extends StatefulWidget {
  final String title;
  final String description;
  final FakeProgressIndicator progressIndicator;
  final String codeSnippet;
  final bool showManualControls;

  const _ProgressDemoItem({
    super.key,
    required this.title,
    required this.description,
    required this.progressIndicator,
    required this.codeSnippet,
    this.showManualControls = false,
  });

  @override
  State<_ProgressDemoItem> createState() => _ProgressDemoItemState();
}

class _ProgressDemoItemState extends State<_ProgressDemoItem> {
  late FakeProgressIndicator _progressIndicator;
  final GlobalKey<_FakeProgressIndicatorState> _progressKey = GlobalKey();
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _createProgressIndicator();
  }

  void _createProgressIndicator() {
    _progressIndicator = FakeProgressIndicator(
      key: _progressKey,
      duration: widget.progressIndicator.duration,
      color: widget.progressIndicator.color,
      backgroundColor: widget.progressIndicator.backgroundColor,
      height: widget.progressIndicator.height,
      borderRadius: widget.progressIndicator.borderRadius,
      curve: widget.progressIndicator.curve,
      autoStart: widget.progressIndicator.autoStart,
      onComplete: () {
        setState(() {
          _isComplete = true;
        });
      },
    );
  }

  void restart() {
    setState(() {
      _isComplete = false;
      _createProgressIndicator();
    });
  }

  void _startProgress() {
    _progressKey.currentState?.start();
  }

  void _stopProgress() {
    _progressKey.currentState?.stop();
  }

  void _resetProgress() {
    setState(() {
      _isComplete = false;
    });
    _progressKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: widget.title,
      description: widget.description,
      codeSnippet: widget.codeSnippet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
                _progressIndicator,
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _isComplete ? Icons.check_circle : Icons.hourglass_empty,
                      size: 16,
                      color: _isComplete ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isComplete ? 'Complete!' : 'Loading...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _isComplete ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (widget.showManualControls) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _startProgress,
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text('Start'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 32),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _stopProgress,
                  icon: const Icon(Icons.pause, size: 16),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 32),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _resetProgress,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 32),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Helper class to access FakeProgressIndicator state
class _FakeProgressIndicatorState extends State<FakeProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onComplete != null) {
        widget.onComplete!();
      }
    });

    if (widget.autoStart) {
      start();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void start() => _controller.forward();
  void stop() => _controller.stop();
  void reset() => _controller.reset();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final theme = Theme.of(context);
        final progressColor = widget.color ?? theme.primaryColor;
        final trackColor =
            widget.backgroundColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.1);

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius:
                widget.borderRadius ?? BorderRadius.circular(widget.height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _animation.value,
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius:
                    widget.borderRadius ??
                    BorderRadius.circular(widget.height / 2),
              ),
            ),
          ),
        );
      },
    );
  }
}

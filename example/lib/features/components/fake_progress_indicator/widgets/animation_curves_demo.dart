import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/code_generator.dart';

/// Demonstrates different animation curves and timing for FakeProgressIndicator
class AnimationCurvesDemo extends StatefulWidget {
  const AnimationCurvesDemo({super.key});

  @override
  State<AnimationCurvesDemo> createState() => _AnimationCurvesDemoState();
}

class _AnimationCurvesDemoState extends State<AnimationCurvesDemo> {
  final List<GlobalKey<_CurveDemoItemState>> _demoKeys = [];

  final List<_CurveDemo> _curveDemos = [
    _CurveDemo(
      name: 'Linear',
      curve: Curves.linear,
      description: 'Constant speed throughout',
      duration: Duration(seconds: 3),
    ),
    _CurveDemo(
      name: 'Ease In Out',
      curve: Curves.easeInOut,
      description: 'Slow start and end, fast middle',
      duration: Duration(seconds: 3),
    ),
    _CurveDemo(
      name: 'Bounce Out',
      curve: Curves.bounceOut,
      description: 'Bouncy finish effect',
      duration: Duration(seconds: 3),
    ),
    _CurveDemo(
      name: 'Elastic Out',
      curve: Curves.elasticOut,
      description: 'Elastic spring effect',
      duration: Duration(seconds: 3),
    ),
    _CurveDemo(
      name: 'Fast Out Slow In',
      curve: Curves.fastOutSlowIn,
      description: 'Material Design standard',
      duration: Duration(seconds: 3),
    ),
    _CurveDemo(
      name: 'Decelerate',
      curve: Curves.decelerate,
      description: 'Fast start, slow finish',
      duration: Duration(seconds: 3),
    ),
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _curveDemos.length; i++) {
      _demoKeys.add(GlobalKey<_CurveDemoItemState>());
    }
  }

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
              'Animation Curves Comparison',
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

        // Grid of curve demonstrations
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _curveDemos.length,
          itemBuilder: (context, index) {
            final demo = _curveDemos[index];
            return _CurveDemoItem(key: _demoKeys[index], demo: demo);
          },
        ),

        const SizedBox(height: 24),

        // Duration comparison
        DemoCard(
          title: 'Duration Variations',
          description: 'Same curve with different durations',
          codeSnippet: CodeGenerator.generateFakeProgressIndicatorCode({
            'duration': 'Duration(seconds: 1) // or 3, 5',
            'curve': 'Curves.easeInOut',
          }),
          child: Column(
            children: [
              _DurationDemoItem(
                title: 'Fast (1s)',
                duration: const Duration(seconds: 1),
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              _DurationDemoItem(
                title: 'Medium (3s)',
                duration: const Duration(seconds: 3),
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              _DurationDemoItem(
                title: 'Slow (5s)',
                duration: const Duration(seconds: 5),
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CurveDemo {
  final String name;
  final Curve curve;
  final String description;
  final Duration duration;

  const _CurveDemo({
    required this.name,
    required this.curve,
    required this.description,
    required this.duration,
  });
}

class _CurveDemoItem extends StatefulWidget {
  final _CurveDemo demo;

  const _CurveDemoItem({super.key, required this.demo});

  @override
  State<_CurveDemoItem> createState() => _CurveDemoItemState();
}

class _CurveDemoItemState extends State<_CurveDemoItem> {
  bool _isComplete = false;
  int _restartCount = 0;

  void restart() {
    setState(() {
      _isComplete = false;
      _restartCount++;
    });
  }

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
          Text(
            widget.demo.name,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            widget.demo.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),

          FakeProgressIndicator(
            key: ValueKey('${widget.demo.name}_$_restartCount'),
            duration: widget.demo.duration,
            curve: widget.demo.curve,
            height: 6,
            color: Theme.of(context).primaryColor,
            onComplete: () {
              setState(() {
                _isComplete = true;
              });
            },
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                _isComplete ? Icons.check_circle : Icons.hourglass_empty,
                size: 14,
                color: _isComplete ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _isComplete ? 'Done' : 'Loading...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _isComplete ? Colors.green : Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DurationDemoItem extends StatefulWidget {
  final String title;
  final Duration duration;
  final Color color;

  const _DurationDemoItem({
    required this.title,
    required this.duration,
    required this.color,
  });

  @override
  State<_DurationDemoItem> createState() => _DurationDemoItemState();
}

class _DurationDemoItemState extends State<_DurationDemoItem> {
  bool _isComplete = false;
  int _restartCount = 0;

  void _restart() {
    setState(() {
      _isComplete = false;
      _restartCount++;
    });
  }

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
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FakeProgressIndicator(
              key: ValueKey('${widget.title}_$_restartCount'),
              duration: widget.duration,
              curve: Curves.easeInOut,
              height: 6,
              color: widget.color,
              onComplete: () {
                setState(() {
                  _isComplete = true;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 60,
            child: Row(
              children: [
                Icon(
                  _isComplete ? Icons.check_circle : Icons.hourglass_empty,
                  size: 16,
                  color: _isComplete ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 4),
                if (!_isComplete)
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: _restart,
            icon: const Icon(Icons.refresh, size: 16),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

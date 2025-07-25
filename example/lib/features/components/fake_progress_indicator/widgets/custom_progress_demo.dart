import 'package:flutter/material.dart';
import '../../../../core/widgets/widgets.dart';

/// Demonstrates custom progress widgets using the builder pattern
class CustomProgressDemo extends StatefulWidget {
  const CustomProgressDemo({super.key});

  @override
  State<CustomProgressDemo> createState() => _CustomProgressDemoState();
}

class _CustomProgressDemoState extends State<CustomProgressDemo> {
  final List<GlobalKey<_CustomProgressItemState>> _demoKeys = [];

  @override
  void initState() {
    super.initState();
    // Initialize keys for each demo
    for (int i = 0; i < 4; i++) {
      _demoKeys.add(GlobalKey<_CustomProgressItemState>());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(
          title: 'Custom Progress Widgets',
          subtitle: 'Create custom progress indicators with builder patterns',
        ),
        const SizedBox(height: 16),

        // Circular Progress with Text Overlay
        _CustomProgressItem(
          key: _demoKeys[0],
          title: 'Circular with Text Overlay',
          description: 'Custom circular progress with percentage display',
          builder: (context, progress) => SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Linear Progress with Gradient
        _CustomProgressItem(
          key: _demoKeys[1],
          title: 'Gradient Linear Progress',
          description: 'Linear progress bar with gradient colors',
          builder: (context, progress) => Container(
            width: 300,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.lerp(Colors.red, Colors.green, progress) ?? Colors.blue,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Animated Dots Progress
        _CustomProgressItem(
          key: _demoKeys[2],
          title: 'Animated Dots Progress',
          description: 'Custom animated dots showing progress',
          builder: (context, progress) => SizedBox(
            width: 200,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final dotProgress = (progress * 5 - index).clamp(0.0, 1.0);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20 + (dotProgress * 10),
                  height: 20 + (dotProgress * 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.3 + (dotProgress * 0.7)),
                  ),
                );
              }),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Wave Progress
        _CustomProgressItem(
          key: _demoKeys[3],
          title: 'Wave Progress',
          description: 'Animated wave-style progress indicator',
          builder: (context, progress) => Container(
            width: 200,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 96 * progress,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.3),
                            Theme.of(context).primaryColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: progress > 0.5 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Control buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                for (final key in _demoKeys) {
                  key.currentState?.startProgress();
                }
              },
              child: const Text('Start All'),
            ),
            ElevatedButton(
              onPressed: () {
                for (final key in _demoKeys) {
                  key.currentState?.resetProgress();
                }
              },
              child: const Text('Reset All'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Individual custom progress item widget
class _CustomProgressItem extends StatefulWidget {
  final String title;
  final String description;
  final Widget Function(BuildContext context, double progress) builder;

  const _CustomProgressItem({
    super.key,
    required this.title,
    required this.description,
    required this.builder,
  });

  @override
  State<_CustomProgressItem> createState() => _CustomProgressItemState();
}

class _CustomProgressItemState extends State<_CustomProgressItem>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startProgress() {
    if (!_isAnimating) {
      setState(() {
        _isAnimating = true;
      });
      _controller.forward().then((_) {
        setState(() {
          _isAnimating = false;
        });
      });
    }
  }

  void resetProgress() {
    _controller.reset();
    setState(() {
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: widget.title,
      description: widget.description,
      showCode: true,
      codeSnippet: _generateCode(),
      child: Column(
        children: [
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return widget.builder(context, _animation.value);
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isAnimating ? null : startProgress,
                child: Text(_isAnimating ? 'Running...' : 'Start'),
              ),
              OutlinedButton(
                onPressed: resetProgress,
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _generateCode() {
    return '''
// Custom Progress Widget Example
class CustomProgressWidget extends StatefulWidget {
  @override
  _CustomProgressWidgetState createState() => _CustomProgressWidgetState();
}

class _CustomProgressWidgetState extends State<CustomProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ${_getBuilderCode()};
      },
    );
  }
}''';
  }

  String _getBuilderCode() {
    switch (widget.title) {
      case 'Circular with Text Overlay':
        return '''Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: _animation.value,
              strokeWidth: 8,
            ),
            Text('\${(_animation.value * 100).toInt()}%'),
          ],
        )''';
      case 'Gradient Linear Progress':
        return '''LinearProgressIndicator(
          value: _animation.value,
          valueColor: AlwaysStoppedAnimation<Color>(
            Color.lerp(Colors.red, Colors.green, _animation.value),
          ),
        )''';
      case 'Animated Dots Progress':
        return '''Row(
          children: List.generate(5, (index) {
            final dotProgress = (_animation.value * 5 - index).clamp(0.0, 1.0);
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 20 + (dotProgress * 10),
              height: 20 + (dotProgress * 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha: 0.3 + (dotProgress * 0.7)),
              ),
            );
          }),
        )''';
      case 'Wave Progress':
        return '''Container(
          height: 100,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 100 * _animation.value,
                  color: Colors.blue,
                ),
              ),
              Center(child: Text('\${(_animation.value * 100).toInt()}%')),
            ],
          ),
        )''';
      default:
        return 'CustomProgressWidget()';
    }
  }
}

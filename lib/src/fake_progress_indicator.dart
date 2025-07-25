import 'package:flutter/material.dart';
import 'models/progress_state.dart';

/// A customizable progress indicator that animates from 0% to 100%
///
/// This widget provides smooth progress animation with customizable styling
/// and supports custom progress widgets via builder pattern.
class FakeProgressIndicator extends StatefulWidget {
  /// Duration for the progress animation to complete
  final Duration duration;

  /// Color of the progress bar
  final Color? color;

  /// Height of the progress bar
  final double height;

  /// Border radius for the progress bar
  final BorderRadius? borderRadius;

  /// Background color of the progress bar track
  final Color? backgroundColor;

  /// Custom builder for progress widget
  /// If provided, this will be used instead of the default progress bar
  final Widget Function(BuildContext context, ProgressState state)? builder;

  /// Callback when progress animation completes
  final VoidCallback? onComplete;

  /// Animation curve for the progress animation
  final Curve curve;

  /// Whether to start the animation automatically
  final bool autoStart;

  /// Callback for progress state changes
  final void Function(ProgressState state)? onProgressChanged;

  const FakeProgressIndicator({
    super.key,
    this.duration = const Duration(seconds: 3),
    this.color,
    this.height = 4.0,
    this.borderRadius,
    this.backgroundColor,
    this.builder,
    this.onComplete,
    this.curve = Curves.easeInOut,
    this.autoStart = true,
    this.onProgressChanged,
  });

  @override
  State<FakeProgressIndicator> createState() => _FakeProgressIndicatorState();
}

class _FakeProgressIndicatorState extends State<FakeProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Stopwatch _stopwatch;
  ProgressState? _currentState;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();

    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _animation.addListener(_onProgressChanged);
    _animation.addStatusListener(_onAnimationStatusChanged);

    if (widget.autoStart) {
      start();
    }
  }

  @override
  void didUpdateWidget(FakeProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (oldWidget.curve != widget.curve) {
      _animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  void _onProgressChanged() {
    final elapsed = Duration(milliseconds: _stopwatch.elapsedMilliseconds);
    final progress = _animation.value;
    final estimatedTotal = widget.duration;
    final estimatedRemaining = progress < 1.0
        ? Duration(
            milliseconds: ((1.0 - progress) * estimatedTotal.inMilliseconds)
                .round(),
          )
        : Duration.zero;

    final newState = ProgressState(
      progress: progress,
      currentMessageIndex: 0, // Will be updated by parent widget if needed
      totalMessages: 1, // Will be updated by parent widget if needed
      elapsed: elapsed,
      estimatedRemaining: estimatedRemaining,
    );

    _currentState = newState;

    if (widget.onProgressChanged != null) {
      widget.onProgressChanged!(newState);
    }

    setState(() {});
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _stopwatch.stop();
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    }
  }

  /// Start the progress animation
  void start() {
    _stopwatch.start();
    _controller.forward();
  }

  /// Stop the progress animation
  void stop() {
    _stopwatch.stop();
    _controller.stop();
  }

  /// Reset the progress animation to the beginning
  void reset() {
    _stopwatch.reset();
    _controller.reset();
  }

  /// Complete the progress animation immediately
  void complete() {
    _stopwatch.stop();
    _controller.forward(from: 1.0);
  }

  /// Get the current progress state
  ProgressState? get currentState => _currentState;

  /// Get the current progress value (0.0 to 1.0)
  double get progress => _animation.value;

  /// Whether the progress animation is running
  bool get isAnimating => _controller.isAnimating;

  /// Whether the progress animation is complete
  bool get isComplete => _controller.isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = widget.color ?? theme.primaryColor;
    final trackColor =
        widget.backgroundColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.1);

    // Use custom builder if provided
    if (widget.builder != null && _currentState != null) {
      return widget.builder!(context, _currentState!);
    }

    // Default progress bar implementation
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
                widget.borderRadius ?? BorderRadius.circular(widget.height / 2),
          ),
        ),
      ),
    );
  }
}

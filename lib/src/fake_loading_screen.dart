import 'package:flutter/material.dart';
import 'fake_loader.dart';
import 'fake_loader_controller.dart';
import 'models/message_effect.dart';

/// A high-level widget that provides a complete full-screen loading experience.
///
/// This widget wraps [FakeLoader] with additional layout and styling options
/// to create a polished full-screen loading screen with background color support,
/// progress indicators, and comprehensive customization options.
class FakeLoadingScreen extends StatefulWidget {
  /// List of messages to display. Can be strings or FakeMessage objects.
  final List<dynamic> messages;

  /// Controller for programmatic control of the loader.
  final FakeLoaderController? controller;

  /// Total duration for the loading screen. If provided, this overrides
  /// individual message durations and distributes time evenly across messages.
  final Duration? duration;

  /// Background color for the entire screen.
  final Color? backgroundColor;

  /// Color for the loading messages text.
  final Color? textColor;

  /// Color for progress indicators and accents.
  final Color? progressColor;

  /// Whether to show a progress indicator.
  final bool showProgress;

  /// Text style for the loading messages.
  final TextStyle? textStyle;

  /// Widget to display as a spinner/loading indicator.
  final Widget? spinner;

  /// Callback when loading sequence completes.
  final VoidCallback? onComplete;

  /// Callback when each message changes.
  final void Function(String message, int index)? onMessageChanged;

  /// Whether to display messages in random order.
  final bool randomOrder;

  /// Default visual effect for messages.
  final MessageEffect effect;

  /// Delay between characters for typewriter effect.
  final Duration typewriterDelay;

  /// Whether to loop the message sequence until manually stopped.
  final bool loopUntilComplete;

  /// Maximum number of loops. If null, loops indefinitely when loopUntilComplete is true.
  final int? maxLoops;

  /// Callback when a loop completes.
  final VoidCallback? onLoopComplete;

  /// Text alignment for messages.
  final TextAlign textAlign;

  /// Padding around the loading content.
  final EdgeInsets? padding;

  /// Spacing between spinner and text.
  final double spacingBetweenSpinnerAndText;

  /// Animation curve for transitions.
  final Curve animationCurve;

  /// Whether to auto-start the loading sequence.
  final bool autoStart;

  /// Custom progress widget. If provided, this will be used instead of the default progress bar.
  final Widget? progressWidget;

  FakeLoadingScreen({
    super.key,
    required this.messages,
    this.controller,
    this.duration,
    this.backgroundColor,
    this.textColor,
    this.progressColor,
    this.showProgress = false,
    this.textStyle,
    this.spinner,
    this.onComplete,
    this.onMessageChanged,
    this.randomOrder = false,
    this.effect = MessageEffect.fade,
    this.typewriterDelay = const Duration(milliseconds: 50),
    this.loopUntilComplete = false,
    this.maxLoops,
    this.onLoopComplete,
    this.textAlign = TextAlign.center,
    this.padding,
    this.spacingBetweenSpinnerAndText = 16.0,
    this.animationCurve = Curves.easeInOut,
    this.autoStart = true,
    this.progressWidget,
  }) : assert(messages.isNotEmpty, 'Messages list cannot be empty'),
       assert(
         maxLoops == null || maxLoops > 0,
         'maxLoops must be greater than 0',
       ),
       assert(
         spacingBetweenSpinnerAndText >= 0,
         'spacingBetweenSpinnerAndText must be >= 0',
       );

  @override
  State<FakeLoadingScreen> createState() => _FakeLoadingScreenState();
}

class _FakeLoadingScreenState extends State<FakeLoadingScreen> {
  late FakeLoaderController _controller;
  Duration? _calculatedMessageDuration;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? FakeLoaderController();
    _calculateMessageDuration();
  }

  @override
  void didUpdateWidget(FakeLoadingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller ?? FakeLoaderController();
    }

    if (widget.duration != oldWidget.duration ||
        widget.messages != oldWidget.messages) {
      _calculateMessageDuration();
    }
  }

  void _calculateMessageDuration() {
    if (widget.duration != null) {
      // Distribute total duration evenly across messages
      final messageCount = widget.messages.length;
      _calculatedMessageDuration = Duration(
        milliseconds: (widget.duration!.inMilliseconds / messageCount).round(),
      );
    }
  }

  TextStyle _getEffectiveTextStyle() {
    final baseStyle =
        widget.textStyle ??
        Theme.of(context).textTheme.bodyLarge ??
        const TextStyle();

    // Apply text color if specified
    if (widget.textColor != null) {
      return baseStyle.copyWith(color: widget.textColor);
    }

    return baseStyle;
  }

  @override
  void dispose() {
    // Only dispose controller if we created it
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        widget.backgroundColor ?? theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: effectiveBackgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: widget.padding ?? const EdgeInsets.all(24.0),
          child: Center(
            child: FakeLoader(
              messages: widget.messages,
              controller: _controller,
              messageDuration:
                  _calculatedMessageDuration ?? const Duration(seconds: 2),
              randomOrder: widget.randomOrder,
              textStyle: _getEffectiveTextStyle(),
              spinner: widget.spinner,
              onComplete: widget.onComplete,
              onMessageChanged: widget.onMessageChanged,
              autoStart: widget.autoStart,
              showProgress: widget.showProgress,
              progressDuration: widget.duration,
              progressColor: widget.progressColor,
              progressWidget: widget.progressWidget,
              effect: widget.effect,
              typewriterDelay: widget.typewriterDelay,
              loopUntilComplete: widget.loopUntilComplete,
              maxLoops: widget.maxLoops,
              onLoopComplete: widget.onLoopComplete,
              textAlign: widget.textAlign,
              spacingBetweenSpinnerAndText: widget.spacingBetweenSpinnerAndText,
              animationCurve: widget.animationCurve,
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'fake_loader_controller.dart';
import 'fake_progress_indicator.dart';
import 'typewriter_text.dart';
import 'models/fake_message.dart';
import 'models/message_effect.dart';
import 'utils/message_selector.dart';

/// A widget that displays fake loading messages with customizable styling and behavior.
class FakeLoader extends StatefulWidget {
  /// List of messages to display. Can be strings or FakeMessage objects.
  final List<dynamic> messages;

  /// Controller for programmatic control of the loader.
  final FakeLoaderController? controller;

  /// Default duration for each message if not specified individually.
  final Duration messageDuration;

  /// Whether to display messages in random order.
  final bool randomOrder;

  /// Text style for the loading messages.
  final TextStyle? textStyle;

  /// Widget to display as a spinner/loading indicator.
  final Widget? spinner;

  /// Transition animation between messages.
  final Widget Function(Widget child, Animation<double> animation)? transition;

  /// Callback when loading sequence completes.
  final VoidCallback? onComplete;

  /// Callback when each message changes.
  final void Function(String message, int index)? onMessageChanged;

  /// Whether to auto-start the loading sequence.
  final bool autoStart;

  /// Whether to show a progress indicator.
  final bool showProgress;

  /// Duration for the progress animation to complete.
  final Duration? progressDuration;

  /// Color of the progress indicator.
  final Color? progressColor;

  /// Custom progress widget. If provided, this will be used instead of the default progress bar.
  final Widget? progressWidget;

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

  /// Padding around the content.
  final EdgeInsets? contentPadding;

  /// Spacing between spinner and text.
  final double spacingBetweenSpinnerAndText;

  /// Animation curve for transitions.
  final Curve animationCurve;

  const FakeLoader({
    super.key,
    required this.messages,
    this.controller,
    this.messageDuration = const Duration(seconds: 2),
    this.randomOrder = false,
    this.textStyle,
    this.spinner,
    this.transition,
    this.onComplete,
    this.onMessageChanged,
    this.autoStart = true,
    this.showProgress = false,
    this.progressDuration,
    this.progressColor,
    this.progressWidget,
    this.effect = MessageEffect.fade,
    this.typewriterDelay = const Duration(milliseconds: 50),
    this.loopUntilComplete = false,
    this.maxLoops,
    this.onLoopComplete,
    this.textAlign = TextAlign.center,
    this.contentPadding,
    this.spacingBetweenSpinnerAndText = 16.0,
    this.animationCurve = Curves.easeInOut,
  }) : assert(messages.length > 0, 'Messages list cannot be empty'),
       assert(
         maxLoops == null || maxLoops > 0,
         'maxLoops must be greater than 0',
       ),
       assert(
         spacingBetweenSpinnerAndText >= 0,
         'spacingBetweenSpinnerAndText must be >= 0',
       );

  @override
  State<FakeLoader> createState() => _FakeLoaderState();
}

class _FakeLoaderState extends State<FakeLoader> with TickerProviderStateMixin {
  late FakeLoaderController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Timer? _messageTimer;
  List<FakeMessage> _processedMessages = [];
  String _currentMessage = '';
  GlobalKey? _progressKey;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? FakeLoaderController();
    _controller.addListener(_onControllerChanged);

    // Configure looping behavior on the controller
    _controller.configureLooping(
      loopUntilComplete: widget.loopUntilComplete,
      maxLoops: widget.maxLoops,
      onLoopComplete: widget.onLoopComplete,
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );

    _processMessages();

    // Initialize progress indicator if needed
    if (widget.showProgress) {
      _progressKey = GlobalKey();
    }

    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.start();
      });
    }
  }

  @override
  void didUpdateWidget(FakeLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.messages != oldWidget.messages) {
      _processMessages();
    }

    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onControllerChanged);
      _controller = widget.controller ?? FakeLoaderController();
      _controller.addListener(_onControllerChanged);
    }

    // Update loop configuration if changed
    if (widget.loopUntilComplete != oldWidget.loopUntilComplete ||
        widget.maxLoops != oldWidget.maxLoops ||
        widget.onLoopComplete != oldWidget.onLoopComplete) {
      _controller.configureLooping(
        loopUntilComplete: widget.loopUntilComplete,
        maxLoops: widget.maxLoops,
        onLoopComplete: widget.onLoopComplete,
      );
    }

    // Update animation curve if changed
    if (widget.animationCurve != oldWidget.animationCurve) {
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: widget.animationCurve,
        ),
      );
    }
  }

  void _processMessages() {
    // Use MessageSelector for weighted selection
    _processedMessages = MessageSelector.selectMessages(
      widget.messages,
      randomOrder: widget.randomOrder,
      respectWeights: true,
    );

    if (_processedMessages.isNotEmpty) {
      _currentMessage = _processedMessages[0].text;
    }
  }

  void _onControllerChanged() {
    if (_controller.isRunning && !_controller.isCompleted) {
      // Check if we've looped back to the beginning (for randomOrder support)
      if (_controller.currentMessageIndex == 0 && widget.randomOrder) {
        _processMessages();
      }
      _startMessageSequence();
    } else if (_controller.isCompleted) {
      _onLoadingComplete();
    }

    if (_controller.currentMessageIndex < _processedMessages.length) {
      final newMessage =
          _processedMessages[_controller.currentMessageIndex].text;
      if (newMessage != _currentMessage) {
        _updateMessage(newMessage, _controller.currentMessageIndex);
      }
    }
  }

  void _startMessageSequence() {
    if (_processedMessages.isEmpty) return;

    _animationController.forward();
    _scheduleNextMessage();

    // Progress indicator will auto-start when created
  }

  void _scheduleNextMessage() {
    _messageTimer?.cancel();

    if (_controller.currentMessageIndex >= _processedMessages.length) {
      return;
    }

    final currentFakeMessage =
        _processedMessages[_controller.currentMessageIndex];
    final duration = currentFakeMessage.duration ?? widget.messageDuration;

    _controller.setupTimer(duration, _processedMessages.length);
  }

  void _updateMessage(String message, int index) {
    setState(() {
      _currentMessage = message;
    });

    _animationController.reset();
    _animationController.forward();

    widget.onMessageChanged?.call(message, index);

    if (_controller.isRunning) {
      _scheduleNextMessage();
    }
  }

  void _onLoadingComplete() {
    _messageTimer?.cancel();
    widget.onComplete?.call();
  }

  Widget _buildMessageWidget() {
    final currentFakeMessage =
        _processedMessages.isNotEmpty &&
            _controller.currentMessageIndex < _processedMessages.length
        ? _processedMessages[_controller.currentMessageIndex]
        : null;

    final effectToUse = currentFakeMessage?.effect ?? widget.effect;

    Widget messageWidget;

    // Handle different message effects
    switch (effectToUse) {
      case MessageEffect.typewriter:
        messageWidget = TypewriterText(
          text: _currentMessage,
          style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
          characterDelay: widget.typewriterDelay,
          textAlign: widget.textAlign,
          autoStart: true,
        );
        break;
      case MessageEffect.slide:
        messageWidget = SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(_fadeAnimation),
          child: Text(
            _currentMessage,
            style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
            textAlign: widget.textAlign,
          ),
        );
        break;
      case MessageEffect.scale:
        messageWidget = ScaleTransition(
          scale: _fadeAnimation,
          child: Text(
            _currentMessage,
            style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
            textAlign: widget.textAlign,
          ),
        );
        break;
      case MessageEffect.fade:
        messageWidget = Text(
          _currentMessage,
          style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
          textAlign: widget.textAlign,
        );
        break;
    }

    // Apply custom transition if provided
    if (widget.transition != null) {
      messageWidget = widget.transition!(messageWidget, _fadeAnimation);
    } else if (effectToUse == MessageEffect.fade) {
      messageWidget = FadeTransition(
        opacity: _fadeAnimation,
        child: messageWidget,
      );
    }

    return messageWidget;
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _animationController.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageWidget = _buildMessageWidget();

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.spinner != null) ...[
          widget.spinner!,
          SizedBox(height: widget.spacingBetweenSpinnerAndText),
        ],
        messageWidget,
        if (widget.showProgress) ...[
          const SizedBox(height: 16),
          widget.progressWidget ??
              FakeProgressIndicator(
                key: _progressKey,
                duration:
                    widget.progressDuration ??
                    Duration(
                      milliseconds: (_processedMessages.fold<int>(
                        0,
                        (sum, msg) =>
                            sum +
                            (msg.duration?.inMilliseconds ??
                                widget.messageDuration.inMilliseconds),
                      )),
                    ),
                color: widget.progressColor,
                autoStart: false,
              ),
        ],
      ],
    );

    if (widget.contentPadding != null) {
      content = Padding(padding: widget.contentPadding!, child: content);
    }

    return content;
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'fake_loader_controller.dart';
import 'models/fake_message.dart';

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
  }) : assert(messages.length > 0, 'Messages list cannot be empty');

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

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? FakeLoaderController();
    _controller.addListener(_onControllerChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _processMessages();

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
  }

  void _processMessages() {
    _processedMessages = widget.messages.map((message) {
      if (message is String) {
        return FakeMessage(message);
      } else if (message is FakeMessage) {
        return message;
      } else {
        return FakeMessage(message.toString());
      }
    }).toList();

    if (widget.randomOrder) {
      _processedMessages.shuffle(Random());
    }

    if (_processedMessages.isNotEmpty) {
      _currentMessage = _processedMessages[0].text;
    }
  }

  void _onControllerChanged() {
    if (_controller.isRunning && !_controller.isCompleted) {
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
    Widget messageWidget = Text(
      _currentMessage,
      style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );

    if (widget.transition != null) {
      messageWidget = widget.transition!(messageWidget, _fadeAnimation);
    } else {
      messageWidget = FadeTransition(
        opacity: _fadeAnimation,
        child: messageWidget,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.spinner != null) ...[
          widget.spinner!,
          const SizedBox(height: 16),
        ],
        messageWidget,
      ],
    );
  }
}

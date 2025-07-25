import 'package:flutter/material.dart';
import 'typewriter_controller.dart';

/// A widget that displays text with a typewriter animation effect.
///
/// The text appears character by character, optionally with a blinking cursor.
/// This widget can be used standalone or integrated with other loading components.
class TypewriterText extends StatefulWidget {
  /// The text to display with typewriter animation.
  final String text;

  /// The style to apply to the text.
  final TextStyle? style;

  /// The delay between each character being typed.
  final Duration characterDelay;

  /// The cursor character to display during typing.
  final String cursor;

  /// Whether to show the cursor during typing.
  final bool showCursor;

  /// Whether the cursor should blink.
  final bool blinkCursor;

  /// The interval for cursor blinking.
  final Duration blinkInterval;

  /// Called when the typewriter animation completes.
  final VoidCallback? onComplete;

  /// Called when each character is typed.
  final ValueChanged<String>? onCharacterTyped;

  /// Whether to start the animation automatically when the widget is built.
  final bool autoStart;

  /// The alignment of the text.
  final TextAlign textAlign;

  /// An optional controller to manage the typewriter animation externally.
  final TypewriterController? controller;

  /// Creates a TypewriterText widget.
  ///
  /// The [text] parameter is required and specifies the text to animate.
  /// All other parameters are optional and provide customization options.
  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.characterDelay = const Duration(milliseconds: 50),
    this.cursor = '|',
    this.showCursor = true,
    this.blinkCursor = true,
    this.blinkInterval = const Duration(milliseconds: 500),
    this.onComplete,
    this.onCharacterTyped,
    this.autoStart = true,
    this.textAlign = TextAlign.start,
    this.controller,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  late TypewriterController _controller;
  bool _isExternalController = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
      _isExternalController = true;
    } else {
      _controller = TypewriterController(
        characterDelay: widget.characterDelay,
        cursor: widget.cursor,
        showCursor: widget.showCursor,
        blinkCursor: widget.blinkCursor,
        blinkInterval: widget.blinkInterval,
      );
      _isExternalController = false;
    }

    _controller.addListener(_onControllerUpdate);

    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.startTyping(widget.text);
      });
    }
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller changes
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onControllerUpdate);

      if (!_isExternalController) {
        _controller.dispose();
      }

      if (widget.controller != null) {
        _controller = widget.controller!;
        _isExternalController = true;
      } else {
        _controller = TypewriterController(
          characterDelay: widget.characterDelay,
          cursor: widget.cursor,
          showCursor: widget.showCursor,
          blinkCursor: widget.blinkCursor,
          blinkInterval: widget.blinkInterval,
        );
        _isExternalController = false;
      }

      _controller.addListener(_onControllerUpdate);
    }

    // Handle text changes
    if (widget.text != oldWidget.text) {
      if (widget.autoStart) {
        _controller.startTyping(widget.text);
      }
    }
  }

  void _onControllerUpdate() {
    setState(() {});

    // Call callbacks
    if (_controller.isComplete && widget.onComplete != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onComplete!();
      });
    }

    if (widget.onCharacterTyped != null && _controller.isTyping) {
      widget.onCharacterTyped!(_controller.displayText);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    if (!_isExternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _controller.displayText,
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}

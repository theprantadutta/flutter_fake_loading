import 'dart:async';
import 'package:flutter/foundation.dart';

/// Controller for managing character-by-character typewriter animation.
///
/// This controller manages the state and timing of typewriter text animation,
/// allowing for customizable typing speed, cursor display, and completion detection.
class TypewriterController extends ChangeNotifier {
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

  String _fullText = '';
  String _displayText = '';
  bool _isTyping = false;
  bool _isComplete = false;
  bool _showCursorState = true;
  Timer? _typingTimer;
  Timer? _blinkTimer;
  int _currentIndex = 0;

  /// Creates a new TypewriterController.
  ///
  /// [characterDelay] controls how fast characters are typed.
  /// [cursor] is the character to show as the cursor (default: '|').
  /// [showCursor] determines if the cursor is visible during typing.
  /// [blinkCursor] determines if the cursor should blink.
  /// [blinkInterval] controls how fast the cursor blinks.
  TypewriterController({
    this.characterDelay = const Duration(milliseconds: 50),
    this.cursor = '|',
    this.showCursor = true,
    this.blinkCursor = true,
    this.blinkInterval = const Duration(milliseconds: 500),
  });

  /// The current text being displayed, including cursor if applicable.
  String get displayText {
    if (!showCursor || _isComplete) {
      return _displayText;
    }

    if (_isTyping) {
      return _displayText + (_showCursorState ? cursor : '');
    }

    return _displayText;
  }

  /// Whether the typewriter animation is currently running.
  bool get isTyping => _isTyping;

  /// Whether the typewriter animation has completed.
  bool get isComplete => _isComplete;

  /// The full text that will be typed out.
  String get fullText => _fullText;

  /// The current typing progress as a value between 0.0 and 1.0.
  double get progress {
    if (_fullText.isEmpty) return 1.0;
    return _currentIndex / _fullText.length;
  }

  /// Starts typing the given text character by character.
  ///
  /// If text is already being typed, it will be reset and the new text will start.
  void startTyping(String text) {
    _fullText = text;
    _displayText = '';
    _currentIndex = 0;
    _isTyping = true;
    _isComplete = false;

    _stopTimers();

    if (blinkCursor && showCursor) {
      _startBlinkTimer();
    }

    _startTypingTimer();
    notifyListeners();
  }

  /// Skips to the end of the current text immediately.
  void skipToEnd() {
    if (!_isTyping) return;

    _stopTimers();
    _displayText = _fullText;
    _currentIndex = _fullText.length;
    _isTyping = false;
    _isComplete = true;
    notifyListeners();
  }

  /// Resets the controller to its initial state.
  void reset() {
    _stopTimers();
    _fullText = '';
    _displayText = '';
    _currentIndex = 0;
    _isTyping = false;
    _isComplete = false;
    _showCursorState = true;
    notifyListeners();
  }

  /// Pauses the typewriter animation.
  void pause() {
    if (!_isTyping) return;
    _stopTimers();
    _isTyping = false;
    notifyListeners();
  }

  /// Resumes the typewriter animation from where it was paused.
  void resume() {
    if (_isComplete || _currentIndex >= _fullText.length) return;

    _isTyping = true;
    if (blinkCursor && showCursor) {
      _startBlinkTimer();
    }
    _startTypingTimer();
    notifyListeners();
  }

  void _startTypingTimer() {
    _typingTimer = Timer.periodic(characterDelay, (timer) {
      if (_currentIndex < _fullText.length) {
        _displayText = _fullText.substring(0, _currentIndex + 1);
        _currentIndex++;
        notifyListeners();
      } else {
        _completeTyping();
      }
    });
  }

  void _startBlinkTimer() {
    _blinkTimer = Timer.periodic(blinkInterval, (timer) {
      _showCursorState = !_showCursorState;
      notifyListeners();
    });
  }

  void _completeTyping() {
    _stopTimers();
    _isTyping = false;
    _isComplete = true;
    _displayText = _fullText;
    notifyListeners();
  }

  void _stopTimers() {
    _typingTimer?.cancel();
    _typingTimer = null;
    _blinkTimer?.cancel();
    _blinkTimer = null;
  }

  @override
  void dispose() {
    _stopTimers();
    _isTyping = false;
    _isComplete = false;
    super.dispose();
  }
}

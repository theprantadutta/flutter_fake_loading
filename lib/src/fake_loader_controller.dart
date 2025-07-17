import 'dart:async';
import 'package:flutter/foundation.dart';

/// Controller for managing the state and flow of a FakeLoader.
class FakeLoaderController extends ChangeNotifier {
  bool _isRunning = false;
  bool _isCompleted = false;
  int _currentMessageIndex = 0;
  Timer? _timer;

  /// Whether the fake loader is currently running.
  bool get isRunning => _isRunning;

  /// Whether the fake loader has completed.
  bool get isCompleted => _isCompleted;

  /// The current message index being displayed.
  int get currentMessageIndex => _currentMessageIndex;

  /// Starts the fake loading sequence.
  void start() {
    if (_isRunning || _isCompleted) return;

    _isRunning = true;
    _isCompleted = false;
    _currentMessageIndex = 0;
    notifyListeners();
  }

  /// Stops the fake loading sequence.
  void stop() {
    if (!_isRunning) return;

    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  /// Skips to the end of the loading sequence.
  void skip() {
    if (!_isRunning) return;

    _timer?.cancel();
    _complete();
  }

  /// Resets the controller to its initial state.
  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _isCompleted = false;
    _currentMessageIndex = 0;
    notifyListeners();
  }

  /// Internal method to advance to the next message.
  void _nextMessage(int totalMessages) {
    if (!_isRunning) return;

    _currentMessageIndex++;

    if (_currentMessageIndex >= totalMessages) {
      _complete();
    } else {
      notifyListeners();
    }
  }

  /// Internal method to complete the loading sequence.
  void _complete() {
    _timer?.cancel();
    _isRunning = false;
    _isCompleted = true;
    notifyListeners();
  }

  /// Sets up the timer for message progression.
  void setupTimer(Duration duration, int totalMessages) {
    _timer?.cancel();
    _timer = Timer(duration, () => _nextMessage(totalMessages));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

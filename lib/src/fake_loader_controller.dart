import 'dart:async';
import 'package:flutter/foundation.dart';

/// Controller for managing the state and flow of a FakeLoader.
class FakeLoaderController extends ChangeNotifier {
  bool _isRunning = false;
  bool _isCompleted = false;
  int _currentMessageIndex = 0;
  int _currentLoopCount = 0;
  Timer? _timer;

  // Loop configuration
  bool _loopUntilComplete = false;
  int? _maxLoops;
  VoidCallback? _onLoopComplete;

  /// Whether the fake loader is currently running.
  bool get isRunning => _isRunning;

  /// Whether the fake loader has completed.
  bool get isCompleted => _isCompleted;

  /// The current message index being displayed.
  int get currentMessageIndex => _currentMessageIndex;

  /// The current loop count (0-based).
  int get currentLoopCount => _currentLoopCount;

  /// Whether the loader is configured to loop until manually stopped.
  bool get loopUntilComplete => _loopUntilComplete;

  /// Maximum number of loops allowed (null means infinite).
  int? get maxLoops => _maxLoops;

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

  /// Restarts the message sequence from the beginning.
  /// This will reset the current message index and start the sequence again.
  void replay() {
    _timer?.cancel();
    _currentMessageIndex = 0;
    _isCompleted = false;

    if (!_isRunning) {
      _isRunning = true;
    }

    notifyListeners();
  }

  /// Configures loop behavior for the controller.
  ///
  /// [loopUntilComplete] - Whether to loop the message sequence continuously
  /// [maxLoops] - Maximum number of loops (null for infinite)
  /// [onLoopComplete] - Callback called when each loop completes
  void configureLooping({
    bool loopUntilComplete = false,
    int? maxLoops,
    VoidCallback? onLoopComplete,
  }) {
    assert(maxLoops == null || maxLoops > 0, 'maxLoops must be greater than 0');

    _loopUntilComplete = loopUntilComplete;
    _maxLoops = maxLoops;
    _onLoopComplete = onLoopComplete;
  }

  /// Resets the loop count to zero.
  void resetLoopCount() {
    _currentLoopCount = 0;
  }

  /// Internal method to advance to the next message.
  void _nextMessage(int totalMessages) {
    if (!_isRunning) return;

    _currentMessageIndex++;

    if (_currentMessageIndex >= totalMessages) {
      // Check if we should loop
      if (_loopUntilComplete &&
          (_maxLoops == null || _currentLoopCount < _maxLoops!)) {
        _currentLoopCount++;
        _currentMessageIndex = 0;

        // Call the loop complete callback
        _onLoopComplete?.call();

        notifyListeners();
      } else {
        _complete();
      }
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

    // Handle edge case of zero messages
    if (totalMessages <= 0) {
      _complete();
      return;
    }

    _timer = Timer(duration, () => _nextMessage(totalMessages));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Represents the current state of progress animation
class ProgressState {
  /// Current progress value from 0.0 to 1.0
  final double progress;

  /// Index of the current message being displayed
  final int currentMessageIndex;

  /// Total number of messages in the sequence
  final int totalMessages;

  /// Time elapsed since progress started
  final Duration elapsed;

  /// Estimated time remaining (optional)
  final Duration? estimatedRemaining;

  /// Whether the progress animation is complete
  bool get isComplete => progress >= 1.0;

  /// Progress as a percentage (0-100)
  double get progressPercentage => progress * 100;

  const ProgressState({
    required this.progress,
    required this.currentMessageIndex,
    required this.totalMessages,
    required this.elapsed,
    this.estimatedRemaining,
  }) : assert(
         progress >= 0.0 && progress <= 1.0,
         'Progress must be between 0.0 and 1.0',
       ),
       assert(
         currentMessageIndex >= 0,
         'Current message index must be non-negative',
       ),
       assert(totalMessages > 0, 'Total messages must be positive');

  /// Creates a copy of this state with updated values
  ProgressState copyWith({
    double? progress,
    int? currentMessageIndex,
    int? totalMessages,
    Duration? elapsed,
    Duration? estimatedRemaining,
  }) {
    return ProgressState(
      progress: progress ?? this.progress,
      currentMessageIndex: currentMessageIndex ?? this.currentMessageIndex,
      totalMessages: totalMessages ?? this.totalMessages,
      elapsed: elapsed ?? this.elapsed,
      estimatedRemaining: estimatedRemaining ?? this.estimatedRemaining,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProgressState &&
        other.progress == progress &&
        other.currentMessageIndex == currentMessageIndex &&
        other.totalMessages == totalMessages &&
        other.elapsed == elapsed &&
        other.estimatedRemaining == estimatedRemaining;
  }

  @override
  int get hashCode {
    return Object.hash(
      progress,
      currentMessageIndex,
      totalMessages,
      elapsed,
      estimatedRemaining,
    );
  }

  @override
  String toString() {
    return 'ProgressState('
        'progress: ${progressPercentage.toStringAsFixed(1)}%, '
        'message: $currentMessageIndex/$totalMessages, '
        'elapsed: ${elapsed.inMilliseconds}ms'
        ')';
  }
}

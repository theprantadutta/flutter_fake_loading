/// Represents a single fake loading message with optional duration.
class FakeMessage {
  /// The text to display during loading.
  final String text;

  /// Optional duration for this specific message.
  /// If null, uses the default duration from FakeLoader.
  final Duration? duration;

  const FakeMessage(this.text, {this.duration});

  @override
  String toString() => 'FakeMessage(text: $text, duration: $duration)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FakeMessage &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          duration == other.duration;

  @override
  int get hashCode => text.hashCode ^ duration.hashCode;
}

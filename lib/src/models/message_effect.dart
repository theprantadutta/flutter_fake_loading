/// Defines the visual effect to apply when displaying a message.
///
/// Each effect provides a different animation style for message transitions,
/// allowing you to match the loading experience to your app's personality.
///
/// Example usage:
/// ```dart
/// FakeLoader(
///   messages: ['Loading...', 'Almost there...'],
///   effect: MessageEffect.typewriter,
/// )
/// ```
enum MessageEffect {
  /// Standard fade transition between messages.
  ///
  /// Messages fade in and out smoothly. This is the default effect
  /// and works well for most applications.
  fade,

  /// Slide transition between messages.
  ///
  /// Messages slide in from the right and slide out to the left.
  /// Creates a dynamic, flowing animation.
  slide,

  /// Character-by-character typewriter animation.
  ///
  /// Text appears one character at a time, like an old typewriter.
  /// Perfect for retro themes or when you want to draw attention
  /// to the loading messages.
  typewriter,

  /// Scale transition between messages.
  ///
  /// Messages scale up from small to normal size and scale down
  /// when transitioning. Creates a bouncy, playful effect.
  scale,
}

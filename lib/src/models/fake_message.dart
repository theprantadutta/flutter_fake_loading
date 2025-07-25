import 'message_effect.dart';
import '../utils/validation.dart';

/// Represents a single fake loading message with optional duration, weight, and effect.
class FakeMessage {
  /// The text to display during loading.
  final String text;

  /// Optional duration for this specific message.
  /// If null, uses the default duration from FakeLoader.
  final Duration? duration;

  /// Weight for weighted random selection. Must be >= 0.
  /// Higher weights make the message more likely to be selected.
  /// Default is 1.0 (equal probability with other messages).
  final double weight;

  /// Optional visual effect to apply when displaying this message.
  /// If null, uses the default effect from FakeLoader.
  final MessageEffect? effect;

  FakeMessage(
    String text, {
    Duration? duration,
    double weight = 1.0,
    MessageEffect? effect,
  }) : text = ValidationUtils.validateNonEmptyString(text, 'message text'),
       duration = ValidationUtils.validateOptionalDuration(
         'message duration',
         duration,
       ),
       weight = _validateWeight(weight),
       effect = _validateEffect(effect);

  static double _validateWeight(double weight) {
    ValidationUtils.validateWeight(weight, context: 'message weight');
    return weight;
  }

  static MessageEffect? _validateEffect(MessageEffect? effect) {
    ValidationUtils.validateMessageEffect(effect);
    return effect;
  }

  /// Creates a FakeMessage with a specific weight for weighted random selection.
  ///
  /// [text] The message text to display.
  /// [weight] The probability weight (must be >= 0).
  /// [duration] Optional duration override for this message.
  /// [effect] Optional visual effect for this message.
  factory FakeMessage.weighted(
    String text,
    double weight, {
    Duration? duration,
    MessageEffect? effect,
  }) {
    return FakeMessage(
      text,
      duration: duration,
      weight: weight,
      effect: effect,
    );
  }

  /// Creates a FakeMessage with typewriter effect.
  ///
  /// [text] The message text to display character by character.
  /// [duration] Optional duration override for this message.
  /// [weight] Optional weight for weighted selection (default 1.0).
  factory FakeMessage.typewriter(
    String text, {
    Duration? duration,
    double weight = 1.0,
  }) {
    return FakeMessage(
      text,
      duration: duration,
      weight: weight,
      effect: MessageEffect.typewriter,
    );
  }

  @override
  String toString() =>
      'FakeMessage(text: $text, duration: $duration, weight: $weight, effect: $effect)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FakeMessage &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          duration == other.duration &&
          weight == other.weight &&
          effect == other.effect;

  @override
  int get hashCode => Object.hash(text, duration, weight, effect);
}

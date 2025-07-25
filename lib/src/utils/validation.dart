import 'package:flutter/foundation.dart';
import '../exceptions/fake_loading_exception.dart';
import '../models/fake_message.dart';
import '../models/message_effect.dart';

/// Utility class for validating parameters and configurations
/// used throughout the flutter_fake_loading package.
class ValidationUtils {
  /// Validates a list of messages.
  ///
  /// Throws [FakeLoadingException] if the messages are invalid.
  /// Returns the validated messages as a list of [FakeMessage] objects.
  static List<FakeMessage> validateMessages(List<dynamic>? messages) {
    if (messages == null || messages.isEmpty) {
      throw FakeLoadingException.invalidMessages(
        'Message list is null or empty',
      );
    }

    final validatedMessages = <FakeMessage>[];

    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];

      if (message == null) {
        throw FakeLoadingException.invalidMessages(
          'Message at index $i is null',
        );
      }

      try {
        if (message is FakeMessage) {
          // Validate the FakeMessage properties
          validateWeight(message.weight, context: 'message at index $i');
          if (message.duration != null) {
            validateDuration('message duration', message.duration!);
          }
          validatedMessages.add(message);
        } else if (message is String) {
          if (message.trim().isEmpty) {
            throw FakeLoadingException.invalidMessages(
              'String message at index $i is empty or whitespace only',
            );
          }
          validatedMessages.add(FakeMessage(message));
        } else {
          // Convert other types to string
          final stringMessage = message.toString();
          if (stringMessage.trim().isEmpty) {
            throw FakeLoadingException.invalidMessages(
              'Message at index $i converts to empty string',
            );
          }
          validatedMessages.add(FakeMessage(stringMessage));
        }
      } catch (e) {
        if (e is FakeLoadingException) {
          rethrow;
        }
        throw FakeLoadingException.invalidMessages(
          'Error processing message at index $i: ${e.toString()}',
        );
      }
    }

    return validatedMessages;
  }

  /// Validates a duration parameter.
  ///
  /// Throws [FakeLoadingException] if the duration is invalid.
  static void validateDuration(String parameterName, Duration duration) {
    if (duration.isNegative) {
      throw FakeLoadingException.invalidDuration(parameterName, duration);
    }

    if (duration == Duration.zero) {
      throw FakeLoadingException.invalidDuration(parameterName, duration);
    }

    // Check for extremely long durations that might indicate an error
    if (duration.inHours > 24) {
      throw FakeLoadingException.validationFailed(
        parameterName,
        'Duration is unusually long (${duration.inHours} hours)',
      );
    }
  }

  /// Validates an optional duration parameter.
  ///
  /// Returns null if the duration is null, otherwise validates and returns it.
  static Duration? validateOptionalDuration(
    String parameterName,
    Duration? duration,
  ) {
    if (duration == null) return null;
    validateDuration(parameterName, duration);
    return duration;
  }

  /// Validates a weight value.
  ///
  /// Throws [FakeLoadingException] if the weight is invalid.
  static void validateWeight(double weight, {String? context}) {
    if (weight.isNaN) {
      throw FakeLoadingException.invalidWeight(weight, context: context);
    }

    if (weight.isInfinite) {
      throw FakeLoadingException.invalidWeight(weight, context: context);
    }

    if (weight < 0) {
      throw FakeLoadingException.invalidWeight(weight, context: context);
    }

    // Check for extremely large weights that might indicate an error
    if (weight > 1000000) {
      throw FakeLoadingException.validationFailed(
        context ?? 'weight',
        'Weight is unusually large ($weight)',
      );
    }
  }

  /// Validates a list of weights.
  ///
  /// Throws [FakeLoadingException] if any weight is invalid.
  static void validateWeights(List<double> weights) {
    for (int i = 0; i < weights.length; i++) {
      validateWeight(weights[i], context: 'weight at index $i');
    }

    // Check if all weights are zero
    if (weights.every((w) => w == 0.0)) {
      throw FakeLoadingException.validationFailed(
        'weights',
        'All weights are zero - at least one weight must be positive',
      );
    }
  }

  /// Validates a loop count parameter.
  ///
  /// Throws [FakeLoadingException] if the count is invalid.
  static void validateLoopCount(int? maxLoops) {
    if (maxLoops == null) return;

    if (maxLoops <= 0) {
      throw FakeLoadingException.validationFailed(
        'maxLoops',
        'Loop count must be positive, got $maxLoops',
      );
    }

    // Check for extremely large loop counts
    if (maxLoops > 10000) {
      throw FakeLoadingException.validationFailed(
        'maxLoops',
        'Loop count is unusually large ($maxLoops) - this might cause performance issues',
      );
    }
  }

  /// Validates a progress value (0.0 to 1.0).
  ///
  /// Throws [FakeLoadingException] if the progress is invalid.
  static void validateProgress(double progress) {
    if (progress.isNaN || progress.isInfinite) {
      throw FakeLoadingException.validationFailed(
        'progress',
        'Progress must be a finite number, got $progress',
      );
    }

    if (progress < 0.0 || progress > 1.0) {
      throw FakeLoadingException.validationFailed(
        'progress',
        'Progress must be between 0.0 and 1.0, got $progress',
      );
    }
  }

  /// Validates a message effect.
  ///
  /// Throws [FakeLoadingException] if the effect is not supported.
  static void validateMessageEffect(MessageEffect? effect) {
    if (effect == null) return;

    // All current effects are supported, but this provides a place
    // for future validation if certain effects have requirements
    switch (effect) {
      case MessageEffect.fade:
      case MessageEffect.slide:
      case MessageEffect.scale:
      case MessageEffect.typewriter:
        // All effects are currently supported
        break;
    }
  }

  /// Validates configuration consistency between related parameters.
  ///
  /// Throws [FakeLoadingException] if the configuration is inconsistent.
  static void validateConfiguration({
    List<dynamic>? messages,
    Duration? messageDuration,
    Duration? progressDuration,
    bool showProgress = false,
    bool loopUntilComplete = false,
    int? maxLoops,
  }) {
    // Validate messages if provided
    if (messages != null) {
      validateMessages(messages);
    }

    // Validate durations if provided
    if (messageDuration != null) {
      validateDuration('messageDuration', messageDuration);
    }

    if (progressDuration != null) {
      validateDuration('progressDuration', progressDuration);
    }

    // Validate loop configuration
    if (maxLoops != null) {
      validateLoopCount(maxLoops);

      if (!loopUntilComplete && maxLoops > 1) {
        throw FakeLoadingException.invalidConfiguration(
          'maxLoops',
          'maxLoops can only be used when loopUntilComplete is true',
        );
      }
    }

    // Validate progress configuration
    if (showProgress && progressDuration != null && messageDuration != null) {
      // Warn if progress duration is much longer than message duration
      if (progressDuration > messageDuration * 10) {
        throw FakeLoadingException.invalidConfiguration(
          'progressDuration',
          'Progress duration (${progressDuration.inMilliseconds}ms) is much longer than message duration (${messageDuration.inMilliseconds}ms)',
        );
      }
    }
  }

  /// Provides graceful fallback for unsupported features.
  ///
  /// Returns a safe default value and optionally logs a warning.
  static T fallbackValue<T>(
    T requestedValue,
    T fallbackValue,
    String feature, {
    bool logWarning = true,
  }) {
    if (logWarning) {
      // In a real implementation, you might use a proper logging framework
      assert(() {
        debugPrint(
          'Warning: $feature is not fully supported, using fallback value',
        );
        return true;
      }());
    }
    return fallbackValue;
  }

  /// Safely normalizes a list of weights.
  ///
  /// Returns normalized weights or throws [FakeLoadingException] if normalization fails.
  static List<double> normalizeWeights(List<double> weights) {
    if (weights.isEmpty) {
      throw FakeLoadingException.invalidMessages(
        'Cannot normalize empty weight list',
      );
    }

    // Validate individual weights (but allow all-zero case for normalization)
    for (int i = 0; i < weights.length; i++) {
      validateWeight(weights[i], context: 'weight at index $i');
    }

    final totalWeight = weights.fold<double>(
      0.0,
      (sum, weight) => sum + weight,
    );

    // If total weight is 0, assign equal weights
    if (totalWeight == 0.0) {
      final equalWeight = 1.0 / weights.length;
      return List.filled(weights.length, equalWeight);
    }

    // If already normalized (within tolerance), return as-is
    if ((totalWeight - 1.0).abs() < 0.0001) {
      return List.from(weights);
    }

    // Normalize weights to sum to 1.0
    try {
      return weights.map((weight) => weight / totalWeight).toList();
    } catch (e) {
      throw FakeLoadingException.validationFailed(
        'weight normalization',
        'Failed to normalize weights: ${e.toString()}',
      );
    }
  }

  /// Validates that a string parameter is not null or empty.
  ///
  /// Throws [FakeLoadingException] if the string is invalid.
  static String validateNonEmptyString(String? value, String parameterName) {
    if (value == null) {
      throw FakeLoadingException.validationFailed(
        parameterName,
        'Parameter cannot be null',
      );
    }

    if (value.trim().isEmpty) {
      throw FakeLoadingException.validationFailed(
        parameterName,
        'Parameter cannot be empty or whitespace only',
      );
    }

    return value.trim();
  }

  /// Validates a numeric range.
  ///
  /// Throws [FakeLoadingException] if the value is outside the valid range.
  static void validateRange(num value, num min, num max, String parameterName) {
    if (value < min || value > max) {
      throw FakeLoadingException.validationFailed(
        parameterName,
        'Value $value is outside valid range [$min, $max]',
      );
    }
  }
}

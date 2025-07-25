import 'dart:math';
import '../models/fake_message.dart';
import '../exceptions/fake_loading_exception.dart';
import 'validation.dart';

/// Utility class for selecting messages with weighted random selection.
class MessageSelector {
  static final Random _random = Random();

  /// Processes a mixed list of message types and converts them to FakeMessage objects.
  ///
  /// Supports:
  /// - String messages (converted to FakeMessage with weight 1.0)
  /// - FakeMessage objects (used as-is)
  /// - Any object with toString() method (converted to FakeMessage)
  ///
  /// Throws [FakeLoadingException] if the messages are invalid.
  static List<FakeMessage> processMessages(List<dynamic> messages) {
    try {
      return ValidationUtils.validateMessages(messages);
    } catch (e) {
      if (e is FakeLoadingException) {
        rethrow;
      }
      throw FakeLoadingException.invalidMessages(
        'Error processing messages: ${e.toString()}',
      );
    }
  }

  /// Normalizes weights so they sum to 1.0.
  ///
  /// If all weights are 0, assigns equal weights to all messages.
  /// If weights already sum to 1.0 (within tolerance), returns as-is.
  ///
  /// Throws [FakeLoadingException] if normalization fails.
  static List<FakeMessage> normalizeWeights(List<FakeMessage> messages) {
    if (messages.isEmpty) {
      return messages;
    }

    try {
      // Validate individual weights (messages are already validated during construction)
      // Just check for any remaining edge cases

      final totalWeight = messages.fold<double>(
        0.0,
        (sum, msg) => sum + msg.weight,
      );

      // If total weight is 0, assign equal weights
      if (totalWeight == 0.0) {
        final equalWeight = 1.0 / messages.length;
        return messages
            .map(
              (msg) => FakeMessage(
                msg.text,
                duration: msg.duration,
                weight: equalWeight,
                effect: msg.effect,
              ),
            )
            .toList();
      }

      // If already normalized (within small tolerance), return as-is
      if ((totalWeight - 1.0).abs() < 0.0001) {
        return messages;
      }

      // Normalize weights to sum to 1.0
      return messages
          .map(
            (msg) => FakeMessage(
              msg.text,
              duration: msg.duration,
              weight: msg.weight / totalWeight,
              effect: msg.effect,
            ),
          )
          .toList();
    } catch (e) {
      if (e is FakeLoadingException) {
        rethrow;
      }
      throw FakeLoadingException.validationFailed(
        'weight normalization',
        'Failed to normalize message weights: ${e.toString()}',
      );
    }
  }

  /// Selects a random message based on weighted probabilities.
  ///
  /// Uses cumulative probability distribution for selection.
  /// Messages with higher weights are more likely to be selected.
  ///
  /// Throws [FakeLoadingException] if the message list is invalid.
  static FakeMessage selectWeightedRandom(List<FakeMessage> messages) {
    if (messages.isEmpty) {
      throw FakeLoadingException.invalidMessages(
        'Cannot select from empty message list',
      );
    }

    if (messages.length == 1) {
      return messages.first;
    }

    try {
      // Normalize weights first
      final normalizedMessages = normalizeWeights(messages);

      // Generate random value between 0 and 1
      final randomValue = _random.nextDouble();

      // Find message using cumulative probability
      double cumulativeProbability = 0.0;
      for (final message in normalizedMessages) {
        cumulativeProbability += message.weight;
        if (randomValue <= cumulativeProbability) {
          return message;
        }
      }

      // Fallback to last message (should not happen with proper normalization)
      return normalizedMessages.last;
    } catch (e) {
      if (e is FakeLoadingException) {
        rethrow;
      }
      throw FakeLoadingException.validationFailed(
        'weighted selection',
        'Failed to select weighted random message: ${e.toString()}',
      );
    }
  }

  /// Selects messages for display, handling both random and sequential ordering.
  ///
  /// [messages] Mixed list of String, FakeMessage, or other objects
  /// [randomOrder] Whether to randomize the order of messages
  /// [respectWeights] Whether to use weighted selection for random ordering
  static List<FakeMessage> selectMessages(
    List<dynamic> messages, {
    bool randomOrder = false,
    bool respectWeights = true,
  }) {
    final processedMessages = processMessages(messages);

    if (!randomOrder) {
      // Return messages in original order
      return processedMessages;
    }

    if (!respectWeights) {
      // Simple random shuffle without considering weights
      final shuffled = List<FakeMessage>.from(processedMessages);
      shuffled.shuffle(_random);
      return shuffled;
    }

    // Weighted random selection for each position
    final result = <FakeMessage>[];
    final remaining = List<FakeMessage>.from(processedMessages);

    while (remaining.isNotEmpty) {
      final selected = selectWeightedRandom(remaining);
      result.add(selected);
      remaining.remove(selected);
    }

    return result;
  }

  /// Generates a sequence of weighted random selections.
  ///
  /// Useful for testing probability distributions or generating
  /// multiple independent selections.
  static List<FakeMessage> generateWeightedSequence(
    List<dynamic> messages,
    int count,
  ) {
    final processedMessages = processMessages(messages);
    final normalizedMessages = normalizeWeights(processedMessages);

    return List.generate(
      count,
      (_) => selectWeightedRandom(normalizedMessages),
    );
  }

  /// Calculates the expected probability for each message based on weights.
  ///
  /// Returns a map of message text to expected probability (0.0 to 1.0).
  /// Useful for testing and validation.
  static Map<String, double> calculateExpectedProbabilities(
    List<dynamic> messages,
  ) {
    final processedMessages = processMessages(messages);
    final normalizedMessages = normalizeWeights(processedMessages);

    return Map.fromEntries(
      normalizedMessages.map((msg) => MapEntry(msg.text, msg.weight)),
    );
  }
}

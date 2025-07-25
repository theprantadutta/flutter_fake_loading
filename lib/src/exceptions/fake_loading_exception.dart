/// Exception thrown by the flutter_fake_loading package.
///
/// Provides helpful error messages with actionable suggestions to help
/// developers quickly resolve issues.
class FakeLoadingException implements Exception {
  /// The error message describing what went wrong.
  final String message;

  /// Optional suggestion for how to fix the issue.
  final String? suggestion;

  /// The underlying cause of the exception, if any.
  final Object? cause;

  /// Creates a new FakeLoadingException.
  ///
  /// [message] A clear description of what went wrong.
  /// [suggestion] Optional actionable advice for fixing the issue.
  /// [cause] The underlying exception that caused this error, if any.
  const FakeLoadingException(this.message, {this.suggestion, this.cause});

  /// Creates an exception for invalid message lists.
  factory FakeLoadingException.invalidMessages(String details) {
    return FakeLoadingException(
      'Invalid message list: $details',
      suggestion: 'Provide a non-empty list of String or FakeMessage objects.',
    );
  }

  /// Creates an exception for invalid durations.
  factory FakeLoadingException.invalidDuration(
    String parameter,
    Duration? value,
  ) {
    return FakeLoadingException(
      'Invalid duration for $parameter: $value',
      suggestion: 'Duration must be positive (greater than Duration.zero).',
    );
  }

  /// Creates an exception for invalid weights.
  factory FakeLoadingException.invalidWeight(double weight, {String? context}) {
    final contextStr = context != null ? ' in $context' : '';
    return FakeLoadingException(
      'Invalid weight$contextStr: $weight',
      suggestion:
          'Weight must be >= 0. Use 0 to exclude a message, or positive values for probability.',
    );
  }

  /// Creates an exception for unsupported features.
  factory FakeLoadingException.unsupportedFeature(
    String feature,
    String reason,
  ) {
    return FakeLoadingException(
      'Unsupported feature: $feature',
      suggestion: reason,
    );
  }

  /// Creates an exception for validation failures.
  factory FakeLoadingException.validationFailed(String field, String reason) {
    return FakeLoadingException(
      'Validation failed for $field: $reason',
      suggestion:
          'Check the parameter value and ensure it meets the requirements.',
    );
  }

  /// Creates an exception for state errors.
  factory FakeLoadingException.invalidState(String state, String expected) {
    return FakeLoadingException(
      'Invalid state: $state',
      suggestion:
          'Expected state: $expected. Ensure proper initialization and lifecycle management.',
    );
  }

  /// Creates an exception for configuration errors.
  factory FakeLoadingException.invalidConfiguration(
    String parameter,
    String issue,
  ) {
    return FakeLoadingException(
      'Invalid configuration for $parameter: $issue',
      suggestion:
          'Review the parameter documentation and provide a valid value.',
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('FakeLoadingException: $message');

    if (suggestion != null) {
      buffer.write('\nSuggestion: $suggestion');
    }

    if (cause != null) {
      buffer.write('\nCaused by: $cause');
    }

    return buffer.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FakeLoadingException &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          suggestion == other.suggestion &&
          cause == other.cause;

  @override
  int get hashCode => Object.hash(message, suggestion, cause);
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('FakeLoadingException', () {
    test('should create basic exception with message', () {
      const exception = FakeLoadingException('Test error');

      expect(exception.message, equals('Test error'));
      expect(exception.suggestion, isNull);
      expect(exception.cause, isNull);
    });

    test('should create exception with suggestion and cause', () {
      final cause = Exception('Original error');
      final exception = FakeLoadingException(
        'Test error',
        suggestion: 'Try this fix',
        cause: cause,
      );

      expect(exception.message, equals('Test error'));
      expect(exception.suggestion, equals('Try this fix'));
      expect(exception.cause, equals(cause));
    });

    test('should format toString correctly with all fields', () {
      final cause = Exception('Original error');
      final exception = FakeLoadingException(
        'Test error',
        suggestion: 'Try this fix',
        cause: cause,
      );

      final result = exception.toString();
      expect(result, contains('FakeLoadingException: Test error'));
      expect(result, contains('Suggestion: Try this fix'));
      expect(result, contains('Caused by: Exception: Original error'));
    });

    test('should format toString correctly with only message', () {
      const exception = FakeLoadingException('Test error');

      final result = exception.toString();
      expect(result, equals('FakeLoadingException: Test error'));
    });

    test('should implement equality correctly', () {
      const exception1 = FakeLoadingException('Test error');
      const exception2 = FakeLoadingException('Test error');
      const exception3 = FakeLoadingException('Different error');

      expect(exception1, equals(exception2));
      expect(exception1, isNot(equals(exception3)));
    });

    test('should implement hashCode correctly', () {
      const exception1 = FakeLoadingException('Test error');
      const exception2 = FakeLoadingException('Test error');

      expect(exception1.hashCode, equals(exception2.hashCode));
    });

    group('Factory constructors', () {
      test('invalidMessages should create appropriate exception', () {
        final exception = FakeLoadingException.invalidMessages('empty list');

        expect(exception.message, equals('Invalid message list: empty list'));
        expect(
          exception.suggestion,
          equals('Provide a non-empty list of String or FakeMessage objects.'),
        );
      });

      test('invalidDuration should create appropriate exception', () {
        final exception = FakeLoadingException.invalidDuration(
          'testParam',
          Duration(seconds: -1),
        );

        expect(
          exception.message,
          equals('Invalid duration for testParam: -0:00:01.000000'),
        );
        expect(
          exception.suggestion,
          equals('Duration must be positive (greater than Duration.zero).'),
        );
      });

      test('invalidWeight should create appropriate exception', () {
        final exception = FakeLoadingException.invalidWeight(
          -1.0,
          context: 'test context',
        );

        expect(
          exception.message,
          equals('Invalid weight in test context: -1.0'),
        );
        expect(
          exception.suggestion,
          equals(
            'Weight must be >= 0. Use 0 to exclude a message, or positive values for probability.',
          ),
        );
      });

      test(
        'invalidWeight without context should create appropriate exception',
        () {
          final exception = FakeLoadingException.invalidWeight(-1.0);

          expect(exception.message, equals('Invalid weight: -1.0'));
          expect(
            exception.suggestion,
            equals(
              'Weight must be >= 0. Use 0 to exclude a message, or positive values for probability.',
            ),
          );
        },
      );

      test('unsupportedFeature should create appropriate exception', () {
        final exception = FakeLoadingException.unsupportedFeature(
          'feature X',
          'not implemented yet',
        );

        expect(exception.message, equals('Unsupported feature: feature X'));
        expect(exception.suggestion, equals('not implemented yet'));
      });

      test('validationFailed should create appropriate exception', () {
        final exception = FakeLoadingException.validationFailed(
          'fieldName',
          'invalid value',
        );

        expect(
          exception.message,
          equals('Validation failed for fieldName: invalid value'),
        );
        expect(
          exception.suggestion,
          equals(
            'Check the parameter value and ensure it meets the requirements.',
          ),
        );
      });

      test('invalidState should create appropriate exception', () {
        final exception = FakeLoadingException.invalidState(
          'current state',
          'expected state',
        );

        expect(exception.message, equals('Invalid state: current state'));
        expect(
          exception.suggestion,
          equals(
            'Expected state: expected state. Ensure proper initialization and lifecycle management.',
          ),
        );
      });

      test('invalidConfiguration should create appropriate exception', () {
        final exception = FakeLoadingException.invalidConfiguration(
          'paramName',
          'configuration issue',
        );

        expect(
          exception.message,
          equals('Invalid configuration for paramName: configuration issue'),
        );
        expect(
          exception.suggestion,
          equals(
            'Review the parameter documentation and provide a valid value.',
          ),
        );
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('ValidationUtils', () {
    group('validateMessages', () {
      test('should accept valid string messages', () {
        final messages = ValidationUtils.validateMessages(['Hello', 'World']);

        expect(messages, hasLength(2));
        expect(messages[0].text, equals('Hello'));
        expect(messages[1].text, equals('World'));
      });

      test('should accept valid FakeMessage objects', () {
        final fakeMessage = FakeMessage('Test message');
        final messages = ValidationUtils.validateMessages([fakeMessage]);

        expect(messages, hasLength(1));
        expect(messages[0], equals(fakeMessage));
      });

      test('should accept mixed message types', () {
        final fakeMessage = FakeMessage('Fake message');
        final messages = ValidationUtils.validateMessages([
          'String message',
          fakeMessage,
          42, // Should convert to string
        ]);

        expect(messages, hasLength(3));
        expect(messages[0].text, equals('String message'));
        expect(messages[1], equals(fakeMessage));
        expect(messages[2].text, equals('42'));
      });

      test('should throw on null message list', () {
        expect(
          () => ValidationUtils.validateMessages(null),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on empty message list', () {
        expect(
          () => ValidationUtils.validateMessages([]),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on null message in list', () {
        expect(
          () => ValidationUtils.validateMessages(['Valid', null, 'Also valid']),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on empty string message', () {
        expect(
          () => ValidationUtils.validateMessages(['Valid', '', 'Also valid']),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on whitespace-only string message', () {
        expect(
          () =>
              ValidationUtils.validateMessages(['Valid', '   ', 'Also valid']),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on invalid FakeMessage weight', () {
        expect(
          () => ValidationUtils.validateMessages([
            'Valid',
            FakeMessage('Test', weight: -1.0),
          ]),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('validateDuration', () {
      test('should accept positive durations', () {
        expect(
          () => ValidationUtils.validateDuration('test', Duration(seconds: 1)),
          returnsNormally,
        );
      });

      test('should throw on negative duration', () {
        expect(
          () => ValidationUtils.validateDuration('test', Duration(seconds: -1)),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on zero duration', () {
        expect(
          () => ValidationUtils.validateDuration('test', Duration.zero),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on extremely long duration', () {
        expect(
          () => ValidationUtils.validateDuration('test', Duration(hours: 25)),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('validateOptionalDuration', () {
      test('should return null for null input', () {
        final result = ValidationUtils.validateOptionalDuration('test', null);
        expect(result, isNull);
      });

      test('should validate and return valid duration', () {
        final duration = Duration(seconds: 1);
        final result = ValidationUtils.validateOptionalDuration(
          'test',
          duration,
        );
        expect(result, equals(duration));
      });

      test('should throw on invalid duration', () {
        expect(
          () => ValidationUtils.validateOptionalDuration(
            'test',
            Duration(seconds: -1),
          ),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('validateWeight', () {
      test('should accept valid weights', () {
        expect(() => ValidationUtils.validateWeight(0.0), returnsNormally);
        expect(() => ValidationUtils.validateWeight(1.0), returnsNormally);
        expect(() => ValidationUtils.validateWeight(100.0), returnsNormally);
      });

      test('should throw on negative weight', () {
        expect(
          () => ValidationUtils.validateWeight(-1.0),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on NaN weight', () {
        expect(
          () => ValidationUtils.validateWeight(double.nan),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on infinite weight', () {
        expect(
          () => ValidationUtils.validateWeight(double.infinity),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on extremely large weight', () {
        expect(
          () => ValidationUtils.validateWeight(1000001.0),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should include context in error message', () {
        try {
          ValidationUtils.validateWeight(-1.0, context: 'test context');
          fail('Expected exception');
        } catch (e) {
          expect(e.toString(), contains('test context'));
        }
      });
    });

    group('validateWeights', () {
      test('should accept valid weight lists', () {
        expect(
          () => ValidationUtils.validateWeights([1.0, 2.0, 3.0]),
          returnsNormally,
        );
      });

      test('should throw on all-zero weights', () {
        expect(
          () => ValidationUtils.validateWeights([0.0, 0.0, 0.0]),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on invalid weight in list', () {
        expect(
          () => ValidationUtils.validateWeights([1.0, -1.0, 3.0]),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('validateLoopCount', () {
      test('should accept null (unlimited loops)', () {
        expect(() => ValidationUtils.validateLoopCount(null), returnsNormally);
      });

      test('should accept positive loop counts', () {
        expect(() => ValidationUtils.validateLoopCount(1), returnsNormally);
        expect(() => ValidationUtils.validateLoopCount(100), returnsNormally);
      });

      test('should throw on zero or negative loop count', () {
        expect(
          () => ValidationUtils.validateLoopCount(0),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => ValidationUtils.validateLoopCount(-1),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on extremely large loop count', () {
        expect(
          () => ValidationUtils.validateLoopCount(10001),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('validateProgress', () {
      test('should accept valid progress values', () {
        expect(() => ValidationUtils.validateProgress(0.0), returnsNormally);
        expect(() => ValidationUtils.validateProgress(0.5), returnsNormally);
        expect(() => ValidationUtils.validateProgress(1.0), returnsNormally);
      });

      test('should throw on progress outside 0-1 range', () {
        expect(
          () => ValidationUtils.validateProgress(-0.1),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => ValidationUtils.validateProgress(1.1),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on NaN or infinite progress', () {
        expect(
          () => ValidationUtils.validateProgress(double.nan),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => ValidationUtils.validateProgress(double.infinity),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('validateMessageEffect', () {
      test('should accept null effect', () {
        expect(
          () => ValidationUtils.validateMessageEffect(null),
          returnsNormally,
        );
      });

      test('should accept all valid effects', () {
        for (final effect in MessageEffect.values) {
          expect(
            () => ValidationUtils.validateMessageEffect(effect),
            returnsNormally,
          );
        }
      });
    });

    group('validateConfiguration', () {
      test('should accept valid configuration', () {
        expect(
          () => ValidationUtils.validateConfiguration(
            messages: ['Test message'],
            messageDuration: Duration(seconds: 1),
            progressDuration: Duration(seconds: 2),
            showProgress: true,
            loopUntilComplete: true,
            maxLoops: 5,
          ),
          returnsNormally,
        );
      });

      test('should throw on invalid messages', () {
        expect(
          () => ValidationUtils.validateConfiguration(messages: []),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on invalid durations', () {
        expect(
          () => ValidationUtils.validateConfiguration(
            messageDuration: Duration(seconds: -1),
          ),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on maxLoops without loopUntilComplete', () {
        expect(
          () => ValidationUtils.validateConfiguration(
            loopUntilComplete: false,
            maxLoops: 5,
          ),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on mismatched progress and message durations', () {
        expect(
          () => ValidationUtils.validateConfiguration(
            messageDuration: Duration(milliseconds: 100),
            progressDuration: Duration(seconds: 10),
            showProgress: true,
          ),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('normalizeWeights', () {
      test('should normalize weights that sum to different values', () {
        final weights = [2.0, 4.0, 6.0]; // Sum = 12
        final normalized = ValidationUtils.normalizeWeights(weights);

        expect(normalized, hasLength(3));
        expect(normalized[0], closeTo(2.0 / 12.0, 0.0001));
        expect(normalized[1], closeTo(4.0 / 12.0, 0.0001));
        expect(normalized[2], closeTo(6.0 / 12.0, 0.0001));

        final sum = normalized.fold<double>(0.0, (a, b) => a + b);
        expect(sum, closeTo(1.0, 0.0001));
      });

      test('should return equal weights for all-zero input', () {
        final weights = [0.0, 0.0, 0.0];
        final normalized = ValidationUtils.normalizeWeights(weights);

        expect(normalized, hasLength(3));
        expect(normalized[0], closeTo(1.0 / 3.0, 0.0001));
        expect(normalized[1], closeTo(1.0 / 3.0, 0.0001));
        expect(normalized[2], closeTo(1.0 / 3.0, 0.0001));
      });

      test('should return unchanged weights if already normalized', () {
        final weights = [0.2, 0.3, 0.5]; // Sum = 1.0
        final normalized = ValidationUtils.normalizeWeights(weights);

        expect(normalized, equals(weights));
      });

      test('should throw on empty weight list', () {
        expect(
          () => ValidationUtils.normalizeWeights([]),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on invalid weights', () {
        expect(
          () => ValidationUtils.normalizeWeights([1.0, -1.0, 2.0]),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('validateNonEmptyString', () {
      test('should accept valid strings', () {
        final result = ValidationUtils.validateNonEmptyString('test', 'param');
        expect(result, equals('test'));
      });

      test('should trim whitespace', () {
        final result = ValidationUtils.validateNonEmptyString(
          '  test  ',
          'param',
        );
        expect(result, equals('test'));
      });

      test('should throw on null string', () {
        expect(
          () => ValidationUtils.validateNonEmptyString(null, 'param'),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on empty string', () {
        expect(
          () => ValidationUtils.validateNonEmptyString('', 'param'),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on whitespace-only string', () {
        expect(
          () => ValidationUtils.validateNonEmptyString('   ', 'param'),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('validateRange', () {
      test('should accept values within range', () {
        expect(
          () => ValidationUtils.validateRange(5, 0, 10, 'param'),
          returnsNormally,
        );
        expect(
          () => ValidationUtils.validateRange(0, 0, 10, 'param'),
          returnsNormally,
        );
        expect(
          () => ValidationUtils.validateRange(10, 0, 10, 'param'),
          returnsNormally,
        );
      });

      test('should throw on values outside range', () {
        expect(
          () => ValidationUtils.validateRange(-1, 0, 10, 'param'),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => ValidationUtils.validateRange(11, 0, 10, 'param'),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('fallbackValue', () {
      test('should return fallback value', () {
        final result = ValidationUtils.fallbackValue(
          'requested',
          'fallback',
          'test feature',
        );
        expect(result, equals('fallback'));
      });

      test('should return fallback without logging when disabled', () {
        final result = ValidationUtils.fallbackValue(
          'requested',
          'fallback',
          'test feature',
          logWarning: false,
        );
        expect(result, equals('fallback'));
      });
    });
  });
}

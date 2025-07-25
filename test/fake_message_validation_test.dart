import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('FakeMessage Weight and Effect Functionality', () {
    group('Constructor validation', () {
      test('should create valid FakeMessage', () {
        final message = FakeMessage('Test message');

        expect(message.text, equals('Test message'));
        expect(message.weight, equals(1.0));
        expect(message.duration, isNull);
        expect(message.effect, isNull);
      });

      test('should create FakeMessage with all parameters', () {
        final duration = Duration(seconds: 2);
        final message = FakeMessage(
          'Test message',
          duration: duration,
          weight: 2.5,
          effect: MessageEffect.typewriter,
        );

        expect(message.text, equals('Test message'));
        expect(message.weight, equals(2.5));
        expect(message.duration, equals(duration));
        expect(message.effect, equals(MessageEffect.typewriter));
      });

      test('should trim whitespace from text', () {
        final message = FakeMessage('  Test message  ');
        expect(message.text, equals('Test message'));
      });

      test('should throw on null text', () {
        expect(() => FakeMessage(null as dynamic), throwsA(isA<TypeError>()));
      });

      test('should throw on empty text', () {
        expect(() => FakeMessage(''), throwsA(isA<FakeLoadingException>()));
      });

      test('should throw on whitespace-only text', () {
        expect(() => FakeMessage('   '), throwsA(isA<FakeLoadingException>()));
      });

      test('should throw on negative weight', () {
        expect(
          () => FakeMessage('Test', weight: -1.0),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on NaN weight', () {
        expect(
          () => FakeMessage('Test', weight: double.nan),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on infinite weight', () {
        expect(
          () => FakeMessage('Test', weight: double.infinity),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on extremely large weight', () {
        expect(
          () => FakeMessage('Test', weight: 1000001.0),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should accept zero weight', () {
        final message = FakeMessage('Test', weight: 0.0);
        expect(message.weight, equals(0.0));
      });

      test('should throw on negative duration', () {
        expect(
          () => FakeMessage('Test', duration: Duration(seconds: -1)),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on zero duration', () {
        expect(
          () => FakeMessage('Test', duration: Duration.zero),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw on extremely long duration', () {
        expect(
          () => FakeMessage('Test', duration: Duration(hours: 25)),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should accept all valid message effects', () {
        for (final effect in MessageEffect.values) {
          expect(() => FakeMessage('Test', effect: effect), returnsNormally);
        }
      });
    });

    group('Factory constructors', () {
      test('weighted factory should create valid message', () {
        final message = FakeMessage.weighted('Test', 2.5);

        expect(message.text, equals('Test'));
        expect(message.weight, equals(2.5));
        expect(message.duration, isNull);
        expect(message.effect, isNull);
      });

      test('weighted factory should accept all parameters', () {
        final duration = Duration(seconds: 3);
        final message = FakeMessage.weighted(
          'Test',
          2.5,
          duration: duration,
          effect: MessageEffect.fade,
        );

        expect(message.text, equals('Test'));
        expect(message.weight, equals(2.5));
        expect(message.duration, equals(duration));
        expect(message.effect, equals(MessageEffect.fade));
      });

      test('weighted factory should validate weight', () {
        expect(
          () => FakeMessage.weighted('Test', -1.0),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('typewriter factory should create valid message', () {
        final message = FakeMessage.typewriter('Test');

        expect(message.text, equals('Test'));
        expect(message.weight, equals(1.0));
        expect(message.effect, equals(MessageEffect.typewriter));
        expect(message.duration, isNull);
      });

      test('typewriter factory should accept all parameters', () {
        final duration = Duration(seconds: 4);
        final message = FakeMessage.typewriter(
          'Test',
          duration: duration,
          weight: 3.0,
        );

        expect(message.text, equals('Test'));
        expect(message.weight, equals(3.0));
        expect(message.effect, equals(MessageEffect.typewriter));
        expect(message.duration, equals(duration));
      });

      test('typewriter factory should validate parameters', () {
        expect(
          () => FakeMessage.typewriter('', weight: 2.0),
          throwsA(isA<FakeLoadingException>()),
        );

        expect(
          () => FakeMessage.typewriter('Test', weight: -1.0),
          throwsA(isA<FakeLoadingException>()),
        );

        expect(
          () => FakeMessage.typewriter('Test', duration: Duration(seconds: -1)),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('Equality and hashCode', () {
      test('should implement equality correctly', () {
        final message1 = FakeMessage('Test', weight: 2.0);
        final message2 = FakeMessage('Test', weight: 2.0);
        final message3 = FakeMessage('Different', weight: 2.0);

        expect(message1, equals(message2));
        expect(message1, isNot(equals(message3)));
      });

      test('should implement hashCode correctly', () {
        final message1 = FakeMessage('Test', weight: 2.0);
        final message2 = FakeMessage('Test', weight: 2.0);

        expect(message1.hashCode, equals(message2.hashCode));
      });

      test('should consider all fields in equality', () {
        final duration = Duration(seconds: 1);

        final message1 = FakeMessage(
          'Test',
          duration: duration,
          weight: 2.0,
          effect: MessageEffect.fade,
        );

        final message2 = FakeMessage(
          'Test',
          duration: duration,
          weight: 2.0,
          effect: MessageEffect.fade,
        );

        final message3 = FakeMessage(
          'Test',
          duration: duration,
          weight: 2.0,
          effect: MessageEffect.slide,
        );

        expect(message1, equals(message2));
        expect(message1, isNot(equals(message3)));
      });
    });

    group('toString', () {
      test('should provide meaningful string representation', () {
        final message = FakeMessage(
          'Test message',
          duration: Duration(seconds: 2),
          weight: 1.5,
          effect: MessageEffect.typewriter,
        );

        final result = message.toString();
        expect(result, contains('Test message'));
        expect(result, contains('0:00:02.000000'));
        expect(result, contains('1.5'));
        expect(result, contains('typewriter'));
      });
    });

    group('Edge cases', () {
      test('should handle very long text', () {
        final longText = 'A' * 1000;
        final message = FakeMessage(longText);
        expect(message.text, equals(longText));
      });

      test('should handle text with special characters', () {
        const specialText = 'Test with émojis 🚀 and symbols @#\$%';
        final message = FakeMessage(specialText);
        expect(message.text, equals(specialText));
      });

      test('should handle very small positive weights', () {
        final message = FakeMessage('Test', weight: 0.000001);
        expect(message.weight, equals(0.000001));
      });

      test('should handle very short durations', () {
        final message = FakeMessage(
          'Test',
          duration: Duration(microseconds: 1),
        );
        expect(message.duration, equals(Duration(microseconds: 1)));
      });
    });
  });
}

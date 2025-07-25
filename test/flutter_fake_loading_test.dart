import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('FakeMessage', () {
    test('creates message with text only', () {
      final message = FakeMessage('Loading...');
      expect(message.text, 'Loading...');
      expect(message.duration, isNull);
      expect(message.weight, 1.0);
      expect(message.effect, isNull);
    });

    test('creates message with custom duration', () {
      final message = FakeMessage('Loading...', duration: Duration(seconds: 3));
      expect(message.text, 'Loading...');
      expect(message.duration, const Duration(seconds: 3));
      expect(message.weight, 1.0);
      expect(message.effect, isNull);
    });

    test('creates message with custom weight', () {
      final message = FakeMessage('Loading...', weight: 2.5);
      expect(message.text, 'Loading...');
      expect(message.weight, 2.5);
    });

    test('creates message with custom effect', () {
      final message = FakeMessage(
        'Loading...',
        effect: MessageEffect.typewriter,
      );
      expect(message.text, 'Loading...');
      expect(message.effect, MessageEffect.typewriter);
    });

    test('creates message with all parameters', () {
      final message = FakeMessage(
        'Loading...',
        duration: Duration(seconds: 2),
        weight: 3.0,
        effect: MessageEffect.fade,
      );
      expect(message.text, 'Loading...');
      expect(message.duration, const Duration(seconds: 2));
      expect(message.weight, 3.0);
      expect(message.effect, MessageEffect.fade);
    });

    test('weighted factory constructor works correctly', () {
      final message = FakeMessage.weighted('Loading...', 2.5);
      expect(message.text, 'Loading...');
      expect(message.weight, 2.5);
      expect(message.duration, isNull);
      expect(message.effect, isNull);
    });

    test('weighted factory constructor with all parameters', () {
      final message = FakeMessage.weighted(
        'Loading...',
        2.5,
        duration: const Duration(seconds: 3),
        effect: MessageEffect.slide,
      );
      expect(message.text, 'Loading...');
      expect(message.weight, 2.5);
      expect(message.duration, const Duration(seconds: 3));
      expect(message.effect, MessageEffect.slide);
    });

    test('typewriter factory constructor works correctly', () {
      final message = FakeMessage.typewriter('Loading...');
      expect(message.text, 'Loading...');
      expect(message.weight, 1.0);
      expect(message.effect, MessageEffect.typewriter);
      expect(message.duration, isNull);
    });

    test('typewriter factory constructor with all parameters', () {
      final message = FakeMessage.typewriter(
        'Loading...',
        duration: const Duration(seconds: 4),
        weight: 0.5,
      );
      expect(message.text, 'Loading...');
      expect(message.weight, 0.5);
      expect(message.effect, MessageEffect.typewriter);
      expect(message.duration, const Duration(seconds: 4));
    });

    test('validates weight must be >= 0', () {
      expect(
        () => FakeMessage('Loading...', weight: -1.0),
        throwsA(isA<FakeLoadingException>()),
      );
    });

    test('allows weight of 0', () {
      final message = FakeMessage('Loading...', weight: 0.0);
      expect(message.weight, 0.0);
    });

    test('equality works correctly with new properties', () {
      final message1 = FakeMessage(
        'Loading...',
        weight: 2.0,
        effect: MessageEffect.fade,
      );
      final message2 = FakeMessage(
        'Loading...',
        weight: 2.0,
        effect: MessageEffect.fade,
      );
      final message3 = FakeMessage(
        'Loading...',
        weight: 1.0,
        effect: MessageEffect.fade,
      );
      final message4 = FakeMessage(
        'Loading...',
        weight: 2.0,
        effect: MessageEffect.slide,
      );

      expect(message1, equals(message2));
      expect(message1, isNot(equals(message3)));
      expect(message1, isNot(equals(message4)));
    });

    test('hashCode works correctly with new properties', () {
      final message1 = FakeMessage(
        'Loading...',
        weight: 2.0,
        effect: MessageEffect.fade,
      );
      final message2 = FakeMessage(
        'Loading...',
        weight: 2.0,
        effect: MessageEffect.fade,
      );
      final message3 = FakeMessage(
        'Loading...',
        weight: 1.0,
        effect: MessageEffect.fade,
      );

      expect(message1.hashCode, equals(message2.hashCode));
      expect(message1.hashCode, isNot(equals(message3.hashCode)));
    });

    test('toString includes all properties', () {
      final message = FakeMessage(
        'Loading...',
        duration: Duration(seconds: 2),
        weight: 1.5,
        effect: MessageEffect.typewriter,
      );
      final str = message.toString();
      expect(str, contains('Loading...'));
      expect(str, contains('0:00:02.000000'));
      expect(str, contains('1.5'));
      expect(str, contains('typewriter'));
    });
  });

  group('MessageEffect', () {
    test('has all expected values', () {
      expect(MessageEffect.values, hasLength(4));
      expect(MessageEffect.values, contains(MessageEffect.fade));
      expect(MessageEffect.values, contains(MessageEffect.slide));
      expect(MessageEffect.values, contains(MessageEffect.typewriter));
      expect(MessageEffect.values, contains(MessageEffect.scale));
    });
  });

  group('FakeLoaderController', () {
    late FakeLoaderController controller;

    setUp(() {
      controller = FakeLoaderController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state is correct', () {
      expect(controller.isRunning, isFalse);
      expect(controller.isCompleted, isFalse);
      expect(controller.currentMessageIndex, 0);
    });

    test('start() changes state correctly', () {
      controller.start();
      expect(controller.isRunning, isTrue);
      expect(controller.isCompleted, isFalse);
    });

    test('stop() changes state correctly', () {
      controller.start();
      controller.stop();
      expect(controller.isRunning, isFalse);
      expect(controller.isCompleted, isFalse);
    });

    test('skip() completes the loader', () {
      controller.start();
      controller.skip();
      expect(controller.isRunning, isFalse);
      expect(controller.isCompleted, isTrue);
    });

    test('reset() returns to initial state', () {
      controller.start();
      controller.skip();
      controller.reset();
      expect(controller.isRunning, isFalse);
      expect(controller.isCompleted, isFalse);
      expect(controller.currentMessageIndex, 0);
    });
  });
}

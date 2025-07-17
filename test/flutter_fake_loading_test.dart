import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('FakeMessage', () {
    test('creates message with text only', () {
      const message = FakeMessage('Loading...');
      expect(message.text, 'Loading...');
      expect(message.duration, isNull);
    });

    test('creates message with custom duration', () {
      const message = FakeMessage('Loading...', duration: Duration(seconds: 3));
      expect(message.text, 'Loading...');
      expect(message.duration, const Duration(seconds: 3));
    });

    test('equality works correctly', () {
      const message1 = FakeMessage('Loading...');
      const message2 = FakeMessage('Loading...');
      const message3 = FakeMessage('Different');

      expect(message1, equals(message2));
      expect(message1, isNot(equals(message3)));
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

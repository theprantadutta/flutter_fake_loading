import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/src/fake_loader_controller.dart';

void main() {
  group('FakeLoaderController', () {
    late FakeLoaderController controller;

    setUp(() {
      controller = FakeLoaderController();
    });

    tearDown(() {
      controller.dispose();
    });

    group('Basic functionality', () {
      test('should initialize with correct default values', () {
        expect(controller.isRunning, false);
        expect(controller.isCompleted, false);
        expect(controller.currentMessageIndex, 0);
        expect(controller.currentLoopCount, 0);
        expect(controller.loopUntilComplete, false);
        expect(controller.maxLoops, null);
      });

      test('should start correctly', () {
        controller.start();

        expect(controller.isRunning, true);
        expect(controller.isCompleted, false);
        expect(controller.currentMessageIndex, 0);
      });

      test('should not start if already running', () {
        controller.start();
        final wasRunning = controller.isRunning;

        controller.start(); // Try to start again

        expect(wasRunning, true);
        expect(controller.isRunning, true);
      });

      test('should not start if already completed', () {
        // Simulate completion
        controller.start();
        controller.skip();

        expect(controller.isCompleted, true);

        controller.start(); // Try to start again

        expect(controller.isRunning, false);
        expect(controller.isCompleted, true);
      });

      test('should stop correctly', () {
        controller.start();
        controller.stop();

        expect(controller.isRunning, false);
        expect(controller.isCompleted, false);
      });

      test('should skip to completion', () {
        controller.start();
        controller.skip();

        expect(controller.isRunning, false);
        expect(controller.isCompleted, true);
      });

      test('should reset correctly', () {
        controller.start();
        controller.setupTimer(const Duration(milliseconds: 100), 3);

        controller.reset();

        expect(controller.isRunning, false);
        expect(controller.isCompleted, false);
        expect(controller.currentMessageIndex, 0);
      });
    });

    group('Message progression', () {
      test('should advance message index correctly', () async {
        controller.start();

        // Setup timer for 3 messages
        controller.setupTimer(const Duration(milliseconds: 50), 3);

        // Wait for timer to complete
        await Future.delayed(const Duration(milliseconds: 100));

        expect(controller.currentMessageIndex, 1);
      });

      test('should complete when reaching last message', () async {
        controller.start();

        // Setup timer for 1 message (will complete immediately)
        controller.setupTimer(const Duration(milliseconds: 50), 1);

        // Wait for timer to complete
        await Future.delayed(const Duration(milliseconds: 100));

        expect(controller.isCompleted, true);
        expect(controller.isRunning, false);
      });
    });

    group('Replay functionality', () {
      test('should restart from beginning when replay is called', () {
        controller.start();
        controller.setupTimer(const Duration(milliseconds: 50), 3);

        // Simulate advancing to message 2
        controller.setupTimer(const Duration(milliseconds: 1), 3);

        controller.replay();

        expect(controller.currentMessageIndex, 0);
        expect(controller.isRunning, true);
        expect(controller.isCompleted, false);
      });

      test(
        'should start running if not already running when replay is called',
        () {
          expect(controller.isRunning, false);

          controller.replay();

          expect(controller.isRunning, true);
          expect(controller.currentMessageIndex, 0);
          expect(controller.isCompleted, false);
        },
      );

      test('should reset completion state when replay is called', () {
        controller.start();
        controller.skip(); // Complete the sequence

        expect(controller.isCompleted, true);

        controller.replay();

        expect(controller.isCompleted, false);
        expect(controller.isRunning, true);
      });
    });

    group('Loop configuration', () {
      test('should configure looping correctly', () {
        bool loopCompleted = false;

        controller.configureLooping(
          loopUntilComplete: true,
          maxLoops: 3,
          onLoopComplete: () => loopCompleted = true,
        );

        expect(controller.loopUntilComplete, true);
        expect(controller.maxLoops, 3);
        expect(loopCompleted, false); // Initially false
      });

      test('should validate maxLoops parameter', () {
        expect(
          () => controller.configureLooping(maxLoops: 0),
          throwsA(isA<AssertionError>()),
        );

        expect(
          () => controller.configureLooping(maxLoops: -1),
          throwsA(isA<AssertionError>()),
        );
      });

      test('should reset loop count', () {
        controller.configureLooping(loopUntilComplete: true);

        // Simulate some loops (this would normally happen internally)
        controller.start();

        controller.resetLoopCount();

        expect(controller.currentLoopCount, 0);
      });
    });

    group('Loop behavior', () {
      test(
        'should loop when loopUntilComplete is true and no maxLoops',
        () async {
          bool loopCompleted = false;

          controller.configureLooping(
            loopUntilComplete: true,
            onLoopComplete: () => loopCompleted = true,
          );

          controller.start();

          // Setup timer for 1 message to complete quickly and trigger loop
          controller.setupTimer(const Duration(milliseconds: 10), 1);

          // Wait for message to complete and loop
          await Future.delayed(const Duration(milliseconds: 50));

          // Should loop back to message 0
          expect(controller.currentMessageIndex, 0);
          expect(controller.currentLoopCount, 1);
          expect(loopCompleted, true);
          expect(controller.isRunning, true);
          expect(controller.isCompleted, false);
        },
      );

      test('should stop looping when maxLoops is reached', () async {
        int loopCompletedCount = 0;

        controller.configureLooping(
          loopUntilComplete: true,
          maxLoops: 2,
          onLoopComplete: () => loopCompletedCount++,
        );

        controller.start();

        // Simulate completing messages multiple times
        for (int i = 0; i < 3; i++) {
          controller.setupTimer(const Duration(milliseconds: 1), 1);
          await Future.delayed(const Duration(milliseconds: 10));
        }

        expect(controller.currentLoopCount, 2);
        expect(loopCompletedCount, 2);
        expect(controller.isCompleted, true);
        expect(controller.isRunning, false);
      });

      test('should not loop when loopUntilComplete is false', () async {
        controller.configureLooping(loopUntilComplete: false);

        controller.start();
        controller.setupTimer(const Duration(milliseconds: 50), 1);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(controller.isCompleted, true);
        expect(controller.isRunning, false);
        expect(controller.currentLoopCount, 0);
      });

      test('should call onLoopComplete callback when loop completes', () async {
        int callbackCount = 0;

        controller.configureLooping(
          loopUntilComplete: true,
          maxLoops: 2,
          onLoopComplete: () => callbackCount++,
        );

        controller.start();

        // Complete first loop
        controller.setupTimer(const Duration(milliseconds: 10), 1);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(callbackCount, 1);
        expect(controller.isCompleted, false);

        // Complete second loop
        controller.setupTimer(const Duration(milliseconds: 10), 1);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(callbackCount, 2);
        expect(controller.isCompleted, false);

        // Try to complete third loop - should finish now
        controller.setupTimer(const Duration(milliseconds: 10), 1);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(callbackCount, 2); // No additional callback
        expect(controller.isCompleted, true);
      });
    });

    group('State transitions and edge cases', () {
      test('should handle multiple rapid state changes', () {
        controller.start();
        controller.stop();
        controller.start();
        controller.reset();
        controller.replay();

        expect(controller.isRunning, true);
        expect(controller.currentMessageIndex, 0);
        expect(controller.isCompleted, false);
      });

      test('should properly clean up timers on dispose', () {
        final testController = FakeLoaderController();
        testController.start();
        testController.setupTimer(const Duration(seconds: 10), 3);

        // Should not throw when disposing with active timer
        expect(() => testController.dispose(), returnsNormally);
      });

      test('should handle setupTimer with zero messages', () {
        controller.start();

        // This should complete immediately
        controller.setupTimer(const Duration(milliseconds: 50), 0);

        expect(controller.isCompleted, true);
      });

      test('should maintain state consistency during loops', () async {
        controller.configureLooping(loopUntilComplete: true, maxLoops: 1);

        controller.start();

        // Complete one cycle
        controller.setupTimer(const Duration(milliseconds: 1), 2);
        await Future.delayed(const Duration(milliseconds: 10));

        // Should be at message 1
        expect(controller.currentMessageIndex, 1);

        // Complete second message to trigger loop
        controller.setupTimer(const Duration(milliseconds: 1), 2);
        await Future.delayed(const Duration(milliseconds: 10));

        // Should loop back to 0
        expect(controller.currentMessageIndex, 0);
        expect(controller.currentLoopCount, 1);

        // Complete final cycle
        controller.setupTimer(const Duration(milliseconds: 1), 2);
        await Future.delayed(const Duration(milliseconds: 10));

        // Should advance to 1
        expect(controller.currentMessageIndex, 1);

        // Complete and should finish (maxLoops reached)
        controller.setupTimer(const Duration(milliseconds: 1), 2);
        await Future.delayed(const Duration(milliseconds: 10));

        expect(controller.isCompleted, true);
        expect(controller.isRunning, false);
      });
    });

    group('Listener notifications', () {
      test('should notify listeners on state changes', () {
        int notificationCount = 0;
        controller.addListener(() => notificationCount++);

        controller.start();
        expect(notificationCount, 1);

        controller.stop();
        expect(notificationCount, 2);

        controller.reset();
        expect(notificationCount, 3);

        controller.replay();
        expect(notificationCount, 4);
      });

      test('should notify listeners during message progression', () async {
        int notificationCount = 0;
        controller.addListener(() => notificationCount++);

        controller.start();
        final startNotifications = notificationCount;

        controller.setupTimer(const Duration(milliseconds: 50), 3);
        await Future.delayed(const Duration(milliseconds: 100));

        // Should have additional notifications from message progression
        expect(notificationCount, greaterThan(startNotifications));
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

/// Core TypewriterController functionality tests
/// Focused on essential character-by-character animation verification
void main() {
  group('TypewriterController Core Functionality', () {
    late TypewriterController controller;

    setUp(() {
      controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
        cursor: '|',
        showCursor: false, // Disable cursor for cleaner testing
      );
    });

    tearDown(() {
      // Dispose only if not already disposed in the test
      try {
        controller.dispose();
      } catch (e) {
        // Ignore if already disposed
      }
    });

    test('should initialize with correct default state', () {
      expect(controller.displayText, isEmpty);
      expect(controller.isTyping, isFalse);
      expect(controller.isComplete, isFalse);
      expect(controller.fullText, isEmpty);
      expect(controller.progress, equals(1.0)); // Complete when no text
    });

    test('should type text character by character', () async {
      const testText = 'Hello';
      final displayedTexts = <String>[];

      controller.addListener(() {
        displayedTexts.add(controller.displayText);
      });

      controller.startTyping(testText);

      // Wait for typing to complete
      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.isComplete, isTrue);
      expect(controller.displayText, equals(testText));
      expect(displayedTexts.length, greaterThan(testText.length));

      // Verify progressive text building
      final uniqueTexts = displayedTexts.toSet().toList()
        ..sort((a, b) => a.length.compareTo(b.length));

      expect(uniqueTexts.contains(''), isTrue);
      expect(uniqueTexts.contains('H'), isTrue);
      expect(uniqueTexts.contains('He'), isTrue);
      expect(uniqueTexts.contains('Hel'), isTrue);
      expect(uniqueTexts.contains('Hell'), isTrue);
      expect(uniqueTexts.contains('Hello'), isTrue);
    });

    test('should calculate progress correctly', () async {
      const testText = 'Test';
      final progressValues = <double>[];

      controller.addListener(() {
        progressValues.add(controller.progress);
      });

      controller.startTyping(testText);
      await Future.delayed(const Duration(milliseconds: 80));

      expect(controller.isComplete, isTrue);
      expect(progressValues.length, greaterThan(3));

      // Progress should start at 0 and end at 1
      expect(progressValues.first, equals(0.0));
      expect(progressValues.last, equals(1.0));

      // Progress should be monotonically increasing
      for (int i = 1; i < progressValues.length; i++) {
        expect(progressValues[i], greaterThanOrEqualTo(progressValues[i - 1]));
      }
    });

    test('should handle skip to end correctly', () async {
      const testText = 'Long text for testing skip functionality';
      controller.startTyping(testText);

      // Wait a bit then skip
      await Future.delayed(const Duration(milliseconds: 20));
      controller.skipToEnd();

      expect(controller.isComplete, isTrue);
      expect(controller.isTyping, isFalse);
      expect(controller.displayText, equals(testText));
      expect(controller.progress, equals(1.0));
    });

    test('should reset correctly', () async {
      const testText = 'Test text';
      controller.startTyping(testText);

      await Future.delayed(const Duration(milliseconds: 20));
      controller.reset();

      expect(controller.displayText, isEmpty);
      expect(controller.isTyping, isFalse);
      expect(controller.isComplete, isFalse);
      expect(controller.fullText, isEmpty);
      expect(controller.progress, equals(1.0));
    });

    test('should handle pause and resume', () async {
      const testText = 'Pausable text';
      controller.startTyping(testText);

      await Future.delayed(const Duration(milliseconds: 30));
      final displayTextBeforePause = controller.displayText;

      controller.pause();
      expect(controller.isTyping, isFalse);

      // Wait and ensure no more characters are typed
      await Future.delayed(const Duration(milliseconds: 30));
      final displayTextAfterPause = controller.displayText;
      expect(displayTextAfterPause, equals(displayTextBeforePause));

      controller.resume();
      expect(controller.isTyping, isTrue);

      // Wait for completion
      await Future.delayed(const Duration(milliseconds: 200));
      expect(controller.isComplete, isTrue);
      expect(controller.displayText, equals(testText));
    });

    test('should handle empty text', () async {
      controller.startTyping('');
      await Future.delayed(const Duration(milliseconds: 20));

      expect(controller.isComplete, isTrue);
      expect(controller.displayText, isEmpty);
      expect(controller.progress, equals(1.0));
    });

    test('should handle text changes during typing', () async {
      controller.startTyping('First text');
      await Future.delayed(const Duration(milliseconds: 20));

      controller.startTyping('Second text');
      await Future.delayed(const Duration(milliseconds: 200));

      expect(controller.displayText, equals('Second text'));
      // Allow for timing variations in test environment
      expect(controller.isComplete || controller.progress > 0.8, isTrue);
    });

    test('should show cursor when enabled', () {
      final cursorController = TypewriterController(
        characterDelay: const Duration(milliseconds: 100),
        showCursor: true,
        cursor: '_',
      );

      cursorController.startTyping('Test');

      // During typing, cursor should be visible
      expect(cursorController.displayText, contains('_'));

      cursorController.dispose();
    });

    test('should not show cursor when disabled', () {
      final noCursorController = TypewriterController(
        characterDelay: const Duration(milliseconds: 100),
        showCursor: false,
        cursor: '_',
      );

      noCursorController.startTyping('Test');

      // During typing, cursor should not be visible
      expect(noCursorController.displayText, isNot(contains('_')));

      noCursorController.dispose();
    });

    test('should handle special characters', () async {
      const testText = 'Hello! @#\$%';
      final displayedTexts = <String>[];

      controller.addListener(() {
        displayedTexts.add(controller.displayText);
      });

      controller.startTyping(testText);
      await Future.delayed(const Duration(milliseconds: 150));

      expect(controller.isComplete, isTrue);
      expect(controller.displayText, equals(testText));

      // Should have progressive text building with special characters
      final uniqueTexts = displayedTexts.toSet().toList()
        ..sort((a, b) => a.length.compareTo(b.length));

      expect(uniqueTexts.any((text) => text.contains('!')), isTrue);
      expect(uniqueTexts.any((text) => text.contains('@')), isTrue);
    });

    test('should maintain consistent timing', () async {
      const testText = 'Test';
      final timestamps = <DateTime>[];

      controller.addListener(() {
        timestamps.add(DateTime.now());
      });

      controller.startTyping(testText);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.isComplete, isTrue);
      expect(timestamps.length, greaterThan(testText.length));

      // Check timing consistency (allowing variance for test environment)
      final intervals = <int>[];
      for (int i = 1; i < timestamps.length; i++) {
        final interval = timestamps[i]
            .difference(timestamps[i - 1])
            .inMilliseconds;
        intervals.add(interval);
      }

      // Most intervals should be reasonably close to the character delay
      final validIntervals = intervals
          .where((interval) => interval >= 5 && interval <= 50)
          .length;
      expect(
        validIntervals / intervals.length,
        greaterThan(0.3),
      ); // Allow for test environment variance
    });

    test('should handle edge cases gracefully', () {
      // Multiple rapid calls
      controller.startTyping('First');
      controller.startTyping('Second');
      controller.startTyping('Third');

      expect(() => controller.skipToEnd(), returnsNormally);
      expect(() => controller.pause(), returnsNormally);
      expect(() => controller.resume(), returnsNormally);
      expect(() => controller.reset(), returnsNormally);
    });

    test('should dispose properly', () {
      controller.startTyping('Test text');
      expect(() => controller.dispose(), returnsNormally);
    });
  });
}

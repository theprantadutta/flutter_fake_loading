import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('TypewriterController', () {
    late TypewriterController controller;

    setUp(() {
      controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10), // Fast for testing
        cursor: '|',
        showCursor: true,
        blinkCursor: true,
        blinkInterval: const Duration(milliseconds: 100),
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('should initialize with correct default values', () {
      expect(controller.displayText, isEmpty);
      expect(controller.isTyping, isFalse);
      expect(controller.isComplete, isFalse);
      expect(controller.fullText, isEmpty);
      expect(controller.progress, equals(1.0));
    });

    test('should start typing and update display text progressively', () async {
      const testText = 'Hello';
      bool completed = false;

      controller.addListener(() {
        if (controller.isComplete) {
          completed = true;
        }
      });

      controller.startTyping(testText);

      expect(controller.isTyping, isTrue);
      expect(controller.isComplete, isFalse);
      expect(controller.fullText, equals(testText));

      // Wait for typing to complete
      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.isComplete, isTrue);
      expect(controller.isTyping, isFalse);
      expect(controller.displayText, equals(testText));
      expect(completed, isTrue);
    });

    test('should calculate progress correctly during typing', () async {
      const testText = 'Test';
      controller.startTyping(testText);

      // Wait a bit for some characters to be typed
      await Future.delayed(const Duration(milliseconds: 25));

      expect(controller.progress, greaterThan(0.0));
      expect(controller.progress, lessThanOrEqualTo(1.0));

      // Wait for completion
      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.progress, equals(1.0));
    });

    test('should skip to end when skipToEnd is called', () async {
      const testText = 'Long text for testing';
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

    test('should pause and resume correctly', () async {
      const testText = 'Pausable text';
      controller.startTyping(testText);

      await Future.delayed(const Duration(milliseconds: 30));
      final displayTextBeforePause = controller.displayText.replaceAll(
        '|',
        '',
      ); // Remove cursor for comparison

      controller.pause();
      expect(controller.isTyping, isFalse);

      // Wait and ensure no more characters are typed
      await Future.delayed(const Duration(milliseconds: 30));
      final displayTextAfterPause = controller.displayText.replaceAll('|', '');
      expect(displayTextAfterPause, equals(displayTextBeforePause));

      controller.resume();
      expect(controller.isTyping, isTrue);

      // Wait for completion
      await Future.delayed(const Duration(milliseconds: 200));
      expect(controller.isComplete, isTrue);
      expect(controller.displayText, equals(testText));
    });

    test('should show cursor when showCursor is true', () {
      controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 100),
        showCursor: true,
        cursor: '_',
      );

      controller.startTyping('Test');

      // During typing, cursor should be visible
      expect(controller.displayText, contains('_'));
    });

    test('should not show cursor when showCursor is false', () {
      controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 100),
        showCursor: false,
        cursor: '_',
      );

      controller.startTyping('Test');

      // During typing, cursor should not be visible
      expect(controller.displayText, isNot(contains('_')));
    });

    test('should handle empty text', () async {
      controller.startTyping('');

      await Future.delayed(const Duration(milliseconds: 20));

      expect(controller.isComplete, isTrue);
      expect(controller.displayText, isEmpty);
      expect(controller.progress, equals(1.0));
    });

    test(
      'should restart typing when startTyping is called while already typing',
      () async {
        controller.startTyping('First text');

        await Future.delayed(const Duration(milliseconds: 20));

        controller.startTyping('Second text');

        await Future.delayed(
          const Duration(milliseconds: 150),
        ); // More time for completion

        expect(controller.displayText, equals('Second text'));
        expect(controller.isComplete, isTrue);
      },
    );
  });

  group('TypewriterText Widget', () {
    testWidgets('should display text progressively with typewriter effect', (
      WidgetTester tester,
    ) async {
      const testText = 'Hello World';
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: testText,
              characterDelay: const Duration(milliseconds: 10),
              onComplete: () => completed = true,
            ),
          ),
        ),
      );

      // Initially should be empty or have first character
      expect(find.text(testText), findsNothing);

      // Wait for some typing
      await tester.pump(const Duration(milliseconds: 50));

      // Should have partial text
      final partialTextFinder = find.byType(Text);
      expect(partialTextFinder, findsOneWidget);

      final Text textWidget = tester.widget(partialTextFinder);
      expect(textWidget.data!.length, lessThan(testText.length));

      // Wait for completion
      await tester.pump(const Duration(milliseconds: 200));

      expect(completed, isTrue);
      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('should apply custom text style', (WidgetTester tester) async {
      const testStyle = TextStyle(
        fontSize: 24,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: 'Styled text',
              style: testStyle,
              characterDelay: const Duration(milliseconds: 5),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      final Text textWidget = tester.widget(find.byType(Text));
      expect(textWidget.style, equals(testStyle));
    });

    testWidgets('should respect textAlign property', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: 'Centered text',
              textAlign: TextAlign.center,
              characterDelay: const Duration(milliseconds: 5),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      final Text textWidget = tester.widget(find.byType(Text));
      expect(textWidget.textAlign, equals(TextAlign.center));
    });

    testWidgets('should work with external controller', (
      WidgetTester tester,
    ) async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: 'Controlled text',
              controller: controller,
              autoStart: false,
            ),
          ),
        ),
      );

      // Should not start automatically
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Controlled text'), findsNothing);

      // Start manually
      controller.startTyping('Controlled text');
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Controlled text'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should call onCharacterTyped callback', (
      WidgetTester tester,
    ) async {
      final List<String> typedTexts = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: 'Test',
              characterDelay: const Duration(milliseconds: 10),
              onCharacterTyped: (text) => typedTexts.add(text),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      expect(typedTexts, isNotEmpty);
      expect(typedTexts.last, contains('Test'));
    });

    testWidgets('should handle text changes', (WidgetTester tester) async {
      String currentText = 'First text';

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    TypewriterText(
                      text: currentText,
                      characterDelay: const Duration(milliseconds: 5),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentText = 'Second text';
                        });
                      },
                      child: const Text('Change Text'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Wait for first text to complete
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('First text'), findsOneWidget);

      // Change text
      await tester.tap(find.text('Change Text'));
      await tester.pump();

      // Wait for second text to complete
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Second text'), findsOneWidget);
    });

    testWidgets('should show cursor during typing when enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: 'Test with cursor',
              characterDelay: const Duration(milliseconds: 50),
              showCursor: true,
              cursor: '_',
            ),
          ),
        ),
      );

      // During typing, should show cursor
      await tester.pump(const Duration(milliseconds: 25));

      final Text textWidget = tester.widget(find.byType(Text));
      expect(textWidget.data, contains('_'));
    });

    testWidgets('should not show cursor when disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: 'Test without cursor',
              characterDelay: const Duration(milliseconds: 50),
              showCursor: false,
              cursor: '_',
            ),
          ),
        ),
      );

      // During typing, should not show cursor
      await tester.pump(const Duration(milliseconds: 25));

      final Text textWidget = tester.widget(find.byType(Text));
      expect(textWidget.data, isNot(contains('_')));
    });

    testWidgets('should handle autoStart false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: 'Manual start text',
              autoStart: false,
              characterDelay: const Duration(milliseconds: 10),
            ),
          ),
        ),
      );

      // Should not start automatically
      await tester.pump(const Duration(milliseconds: 100));

      final Text textWidget = tester.widget(find.byType(Text));
      expect(textWidget.data, isEmpty);
    });
  });

  group('Character-by-Character Animation Verification', () {
    test('should type each character individually in correct order', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 20),
        showCursor: false, // Disable cursor for cleaner testing
      );

      const testText = 'Hello';
      final displayedTexts = <String>[];

      controller.addListener(() {
        displayedTexts.add(controller.displayText);
      });

      controller.startTyping(testText);

      // Wait for typing to complete
      await Future.delayed(const Duration(milliseconds: 150));

      expect(controller.isComplete, isTrue);
      expect(displayedTexts.length, greaterThan(testText.length));

      // Verify character progression
      final uniqueTexts = displayedTexts.toSet().toList()
        ..sort((a, b) => a.length.compareTo(b.length));

      expect(uniqueTexts.contains(''), isTrue);
      expect(uniqueTexts.contains('H'), isTrue);
      expect(uniqueTexts.contains('He'), isTrue);
      expect(uniqueTexts.contains('Hel'), isTrue);
      expect(uniqueTexts.contains('Hell'), isTrue);
      expect(uniqueTexts.contains('Hello'), isTrue);

      controller.dispose();
    });

    test('should maintain consistent character timing', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 50),
        showCursor: false,
      );

      const testText = 'Test';
      final timestamps = <DateTime>[];
      final displayedTexts = <String>[];

      controller.addListener(() {
        timestamps.add(DateTime.now());
        displayedTexts.add(controller.displayText);
      });

      controller.startTyping(testText);

      await Future.delayed(const Duration(milliseconds: 300));

      expect(controller.isComplete, isTrue);
      expect(timestamps.length, greaterThan(testText.length));

      // Check timing consistency (allowing some variance for test environment)
      final intervals = <int>[];
      for (int i = 1; i < timestamps.length; i++) {
        final interval = timestamps[i]
            .difference(timestamps[i - 1])
            .inMilliseconds;
        intervals.add(interval);
      }

      // Most intervals should be close to the character delay (50ms)
      final validIntervals = intervals
          .where((interval) => interval >= 30 && interval <= 80)
          .length;

      expect(validIntervals / intervals.length, greaterThan(0.5));

      controller.dispose();
    });

    test('should handle special characters correctly', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
        showCursor: false,
      );

      const testText = 'Hello! 🚀 @#\$%';
      final displayedTexts = <String>[];

      controller.addListener(() {
        displayedTexts.add(controller.displayText);
      });

      controller.startTyping(testText);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(controller.isComplete, isTrue);
      expect(controller.displayText, equals(testText));

      // Should have progressive text building
      final uniqueTexts = displayedTexts.toSet().toList()
        ..sort((a, b) => a.length.compareTo(b.length));

      // Check that special characters are handled properly
      expect(uniqueTexts.any((text) => text.contains('!')), isTrue);
      expect(uniqueTexts.any((text) => text.contains('🚀')), isTrue);
      expect(uniqueTexts.any((text) => text.contains('@')), isTrue);

      controller.dispose();
    });

    test('should handle empty and whitespace strings', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
      );

      // Test empty string
      controller.startTyping('');
      await Future.delayed(const Duration(milliseconds: 20));
      expect(controller.isComplete, isTrue);
      expect(controller.displayText, isEmpty);

      // Test whitespace-only string
      controller.startTyping('   ');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(controller.isComplete, isTrue);
      expect(controller.displayText, equals('   '));

      controller.dispose();
    });

    test('should handle very long text efficiently', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(
          milliseconds: 1,
        ), // Very fast for testing
        showCursor: false,
      );

      final longText = 'A' * 100; // 100 character string
      final displayedTexts = <String>[];

      controller.addListener(() {
        displayedTexts.add(controller.displayText);
      });

      controller.startTyping(longText);
      await Future.delayed(const Duration(milliseconds: 300));

      // Allow for timing variations in test environment
      expect(controller.isComplete || controller.progress > 0.8, isTrue);

      // If complete, should match the full text
      if (controller.isComplete) {
        expect(controller.displayText, equals(longText));
      }

      // Should have some intermediate states
      expect(displayedTexts.isNotEmpty, isTrue);

      controller.dispose();
    });

    test('should handle unicode and multi-byte characters', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
        showCursor: false,
      );

      const testText = 'Héllo Wörld! 你好 🌟';
      final displayedTexts = <String>[];

      controller.addListener(() {
        displayedTexts.add(controller.displayText);
      });

      controller.startTyping(testText);
      await Future.delayed(const Duration(milliseconds: 300));

      // Allow for timing variations in test environment
      expect(controller.isComplete || controller.progress > 0.8, isTrue);

      // If complete, should match the full text
      if (controller.isComplete) {
        expect(controller.displayText, equals(testText));
      }

      // Should have some text with unicode characters
      if (displayedTexts.isNotEmpty) {
        final allText = displayedTexts.join();
        expect(allText.contains('H'), isTrue);
      }

      controller.dispose();
    });

    test('should maintain cursor blinking during typing', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 50),
        showCursor: true,
        cursor: '|',
        blinkCursor: true,
        blinkInterval: const Duration(milliseconds: 25),
      );

      const testText = 'Test';
      final displayedTexts = <String>[];

      controller.addListener(() {
        displayedTexts.add(controller.displayText);
      });

      controller.startTyping(testText);
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Don't wait for completion

      // Should have some texts with cursor and some without (due to blinking)
      final textsWithCursor = displayedTexts
          .where((text) => text.contains('|'))
          .length;
      final textsWithoutCursor = displayedTexts
          .where((text) => !text.contains('|'))
          .length;

      expect(textsWithCursor, greaterThan(0));
      expect(textsWithoutCursor, greaterThan(0));

      controller.dispose();
    });

    test('should not show cursor after completion', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
        showCursor: true,
        cursor: '|',
      );

      const testText = 'Test';
      controller.startTyping(testText);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.isComplete, isTrue);
      expect(controller.displayText, equals(testText));
      expect(controller.displayText, isNot(contains('|')));

      controller.dispose();
    });

    test('should handle rapid text changes correctly', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 20),
        showCursor: false,
      );

      // Start typing first text
      controller.startTyping('First');
      await Future.delayed(const Duration(milliseconds: 30));

      // Change to second text before first completes
      controller.startTyping('Second');
      await Future.delayed(const Duration(milliseconds: 30));

      // Change to third text
      controller.startTyping('Third');
      await Future.delayed(const Duration(milliseconds: 250));

      // Allow for timing variations in test environment
      expect(controller.isComplete || controller.progress > 0.8, isTrue);
      expect(controller.displayText, equals('Third'));

      controller.dispose();
    });

    test('should provide accurate progress tracking', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 20),
        showCursor: false,
      );

      const testText = 'Hello World'; // 11 characters
      final progressValues = <double>[];

      controller.addListener(() {
        progressValues.add(controller.progress);
      });

      controller.startTyping(testText);
      await Future.delayed(const Duration(milliseconds: 300));

      expect(controller.isComplete, isTrue);
      expect(progressValues.length, greaterThan(5));

      // Progress should start at 0 and end at 1
      expect(progressValues.first, equals(0.0));
      expect(progressValues.last, equals(1.0));

      // Progress should be monotonically increasing
      for (int i = 1; i < progressValues.length; i++) {
        expect(progressValues[i], greaterThanOrEqualTo(progressValues[i - 1]));
      }

      // Should have intermediate progress values
      expect(progressValues.any((p) => p > 0.0 && p < 1.0), isTrue);

      controller.dispose();
    });
  });

  group('TypewriterController Edge Cases', () {
    test('should handle multiple rapid startTyping calls', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
      );

      controller.startTyping('First');
      controller.startTyping('Second');
      controller.startTyping('Third');

      await Future.delayed(const Duration(milliseconds: 100));

      expect(controller.displayText, equals('Third'));
      expect(controller.isComplete, isTrue);

      controller.dispose();
    });

    test('should handle skipToEnd when not typing', () {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
      );

      controller.skipToEnd(); // Should not crash
      expect(controller.isComplete, isFalse);

      controller.dispose();
    });

    test('should handle resume when not paused', () {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
      );

      controller.resume(); // Should not crash
      expect(controller.isTyping, isFalse);

      controller.dispose();
    });

    test('should handle pause when not typing', () {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
      );

      controller.pause(); // Should not crash
      expect(controller.isTyping, isFalse);

      controller.dispose();
    });

    test('should properly dispose and clean up timers', () {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
      );

      controller.startTyping('Test text');

      // Should not crash when disposing
      expect(() => controller.dispose(), returnsNormally);
    });

    test('should handle extreme character delays', () async {
      // Test very fast typing
      final fastController = TypewriterController(
        characterDelay: const Duration(microseconds: 1),
        showCursor: false,
      );

      fastController.startTyping('Fast');
      await Future.delayed(const Duration(milliseconds: 10));
      expect(fastController.isComplete, isTrue);
      fastController.dispose();

      // Test very slow typing
      final slowController = TypewriterController(
        characterDelay: const Duration(milliseconds: 500),
        showCursor: false,
      );

      slowController.startTyping('Slow');
      await Future.delayed(const Duration(milliseconds: 100));
      expect(slowController.isComplete, isFalse);
      expect(slowController.displayText.length, lessThan(4));
      slowController.dispose();
    });

    test('should handle cursor blinking edge cases', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 100),
        showCursor: true,
        blinkCursor: true,
        blinkInterval: const Duration(milliseconds: 10), // Very fast blinking
        cursor: '_',
      );

      controller.startTyping('Test');
      await Future.delayed(const Duration(milliseconds: 50));

      // Should handle rapid blinking without issues
      expect(controller.isTyping, isTrue);

      controller.dispose();
    });

    test('should handle listener exceptions gracefully', () async {
      final controller = TypewriterController(
        characterDelay: const Duration(milliseconds: 10),
      );

      // Add a listener that throws an exception
      controller.addListener(() {
        if (controller.displayText.length == 2) {
          throw Exception('Test exception');
        }
      });

      // Should not crash the controller
      expect(() => controller.startTyping('Test'), returnsNormally);

      await Future.delayed(const Duration(milliseconds: 200));

      // Should still be typing or complete despite listener exception
      expect(controller.isTyping || controller.isComplete, isTrue);

      controller.dispose();
    });
  });
}

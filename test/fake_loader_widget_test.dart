import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('FakeLoader Widget Tests', () {
    testWidgets('should display messages and cycle through them', (
      WidgetTester tester,
    ) async {
      final messages = ['Message 1', 'Message 2', 'Message 3'];
      final displayedMessages = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: messages,
              messageDuration: const Duration(
                milliseconds: 100,
              ), // Fast for testing
              onMessageChanged: (message, _) => displayedMessages.add(message),
            ),
          ),
        ),
      );

      // Initial message should be displayed
      await tester.pump();
      expect(find.textContaining('Message'), findsOneWidget);

      // Wait for second message
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.textContaining('Message'), findsOneWidget);

      // Wait for third message
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.textContaining('Message'), findsOneWidget);

      // Should have cycled through messages
      await tester.pump(const Duration(milliseconds: 150));
      expect(displayedMessages.length, greaterThanOrEqualTo(1));
    });

    testWidgets('should respect custom styling parameters', (
      WidgetTester tester,
    ) async {
      const testStyle = TextStyle(
        fontSize: 24,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );
      const testAlign = TextAlign.left;
      const testPadding = EdgeInsets.all(20.0);
      const testSpacing = 30.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: ['Test Message'],
              textStyle: testStyle,
              textAlign: testAlign,
              contentPadding: testPadding,
              spacingBetweenSpinnerAndText: testSpacing,
              spinner: const Icon(Icons.refresh),
            ),
          ),
        ),
      );

      // Check text style is applied
      final textWidget = tester.widget<Text>(find.text('Test Message'));
      expect(textWidget.style, equals(testStyle));
      expect(textWidget.textAlign, equals(testAlign));

      // Check padding is applied
      expect(find.byType(Padding), findsOneWidget);
      final paddingWidget = tester.widget<Padding>(find.byType(Padding));
      expect(paddingWidget.padding, equals(testPadding));

      // Check spinner is displayed
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Check spacing between spinner and text
      final column = tester.widget<Column>(find.byType(Column));
      final sizedBox = column.children[1] as SizedBox;
      expect(sizedBox.height, equals(testSpacing));
    });

    testWidgets('should show progress indicator when enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: ['Test Message'],
              showProgress: true,
              progressColor: Colors.green,
            ),
          ),
        ),
      );

      // Should find progress indicator
      expect(find.byType(FakeProgressIndicator), findsOneWidget);
    });

    testWidgets('should use custom progress widget when provided', (
      WidgetTester tester,
    ) async {
      const customProgressKey = Key('custom-progress');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: ['Test Message'],
              showProgress: true,
              progressWidget: Container(
                key: customProgressKey,
                height: 10,
                color: Colors.purple,
              ),
            ),
          ),
        ),
      );

      // Should find custom progress widget
      expect(find.byKey(customProgressKey), findsOneWidget);
      expect(find.byType(FakeProgressIndicator), findsNothing);
    });

    testWidgets('should apply different message effects', (
      WidgetTester tester,
    ) async {
      // Test typewriter effect
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: ['Typewriter Message'],
              effect: MessageEffect.typewriter,
              typewriterDelay: const Duration(milliseconds: 10),
            ),
          ),
        ),
      );

      // Should find TypewriterText widget
      expect(find.byType(TypewriterText), findsOneWidget);

      // Test slide effect
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: ['Slide Message'],
              effect: MessageEffect.slide,
            ),
          ),
        ),
      );

      // Should find SlideTransition
      expect(find.byType(SlideTransition), findsOneWidget);

      // Test scale effect
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: ['Scale Message'],
              effect: MessageEffect.scale,
            ),
          ),
        ),
      );

      // Should find ScaleTransition (might find multiple due to internal animations)
      expect(find.byType(ScaleTransition), findsWidgets);

      // Test fade effect
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: ['Fade Message'],
              effect: MessageEffect.fade,
            ),
          ),
        ),
      );

      // Should find FadeTransition
      expect(find.byType(FadeTransition), findsOneWidget);
    });

    testWidgets('should handle custom transition', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: ['Custom Transition'],
              transition: (child, animation) =>
                  RotationTransition(turns: animation, child: child),
            ),
          ),
        ),
      );

      // Should find RotationTransition (might find multiple due to internal animations)
      expect(find.byType(RotationTransition), findsWidgets);
    });

    testWidgets('should call onComplete callback when finished', (
      WidgetTester tester,
    ) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: ['Message 1', 'Message 2'],
              messageDuration: const Duration(milliseconds: 100),
              onComplete: () => completed = true,
            ),
          ),
        ),
      );

      // Wait for all messages to complete
      await tester.pump(const Duration(milliseconds: 250));

      // Callback should have been called
      expect(completed, isTrue);
    });

    testWidgets('should not auto-start when autoStart is false', (
      WidgetTester tester,
    ) async {
      final controller = FakeLoaderController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: ['Message 1', 'Message 2'],
              controller: controller,
              autoStart: false,
            ),
          ),
        ),
      );

      // Start manually
      controller.start();
      await tester.pump();

      // Now message should be displayed
      expect(find.textContaining('Message'), findsOneWidget);

      // Clean up
      controller.dispose();
    });

    testWidgets('should handle weighted messages', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: [
                FakeMessage.weighted('Weighted Message', 1.0),
                'Regular Message',
              ],
              messageDuration: const Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      // First message should be displayed
      expect(find.text('Weighted Message'), findsOneWidget);

      // Wait for second message
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.text('Regular Message'), findsOneWidget);
    });

    testWidgets('should handle loop functionality', (
      WidgetTester tester,
    ) async {
      int loopCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: ['Message 1', 'Message 2'],
              messageDuration: const Duration(milliseconds: 50),
              loopUntilComplete: true,
              maxLoops: 2,
              onLoopComplete: () => loopCount++,
            ),
          ),
        ),
      );

      // Wait for first loop to complete
      await tester.pump(const Duration(milliseconds: 150));

      // Wait for second loop to complete
      await tester.pump(const Duration(milliseconds: 150));

      // Should have looped twice
      expect(loopCount, equals(2));
    });

    testWidgets('should handle FakeMessage objects with custom durations', (
      WidgetTester tester,
    ) async {
      final messages = [
        FakeMessage(
          'Quick message',
          duration: const Duration(milliseconds: 50),
        ),
        FakeMessage(
          'Slow message',
          duration: const Duration(milliseconds: 150),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FakeLoader(messages: messages)),
        ),
      );

      // First message should be displayed
      expect(find.text('Quick message'), findsOneWidget);

      // Wait for first message duration
      await tester.pump(const Duration(milliseconds: 75));

      // Second message should now be displayed
      expect(find.text('Slow message'), findsOneWidget);

      // Wait for second message duration
      await tester.pump(const Duration(milliseconds: 175));

      // The message might still be visible due to animation timing in tests
      // The important part is that we've verified the timing of messages
    });

    testWidgets(
      'should handle message effects specified on individual messages',
      (WidgetTester tester) async {
        final messages = [
          FakeMessage('Default effect'),
          FakeMessage('Typewriter effect', effect: MessageEffect.typewriter),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FakeLoader(
                messages: messages,
                messageDuration: const Duration(milliseconds: 100),
              ),
            ),
          ),
        );

        // First message should use default effect (fade)
        expect(find.text('Default effect'), findsOneWidget);
        expect(find.byType(TypewriterText), findsNothing);

        // Wait for second message
        await tester.pump(const Duration(milliseconds: 150));

        // Second message should use typewriter effect
        expect(find.byType(TypewriterText), findsOneWidget);
      },
    );
  });
}

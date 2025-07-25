import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('Enhanced FakeLoader', () {
    testWidgets('creates with new parameters', (WidgetTester tester) async {
      const messages = ['Loading...', 'Please wait...'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: messages,
              showProgress: true,
              progressColor: Colors.blue,
              effect: MessageEffect.fade,
              textAlign: TextAlign.left,
              spacingBetweenSpinnerAndText: 20.0,
              contentPadding: const EdgeInsets.all(16.0),
              loopUntilComplete: false,
              maxLoops: 3,
            ),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('shows progress indicator when enabled', (
      WidgetTester tester,
    ) async {
      const messages = ['Loading...'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: messages,
              showProgress: true,
              progressColor: Colors.red,
            ),
          ),
        ),
      );

      expect(find.byType(FakeProgressIndicator), findsOneWidget);
    });

    testWidgets('does not show progress indicator when disabled', (
      WidgetTester tester,
    ) async {
      const messages = ['Loading...'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(messages: messages, showProgress: false),
          ),
        ),
      );

      expect(find.byType(FakeProgressIndicator), findsNothing);
    });

    testWidgets('uses custom progress widget when provided', (
      WidgetTester tester,
    ) async {
      const messages = ['Loading...'];
      const customProgress = LinearProgressIndicator();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(
              messages: messages,
              showProgress: true,
              progressWidget: customProgress,
            ),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byType(FakeProgressIndicator), findsNothing);
    });

    testWidgets('applies content padding correctly', (
      WidgetTester tester,
    ) async {
      const messages = ['Loading...'];
      const padding = EdgeInsets.all(24.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(messages: messages, contentPadding: padding),
          ),
        ),
      );

      final paddingWidget = find.byType(Padding);
      expect(paddingWidget, findsOneWidget);

      final paddingWidgetInstance = tester.widget<Padding>(paddingWidget);
      expect(paddingWidgetInstance.padding, equals(padding));
    });

    testWidgets('uses typewriter effect for typewriter messages', (
      WidgetTester tester,
    ) async {
      final messages = [FakeMessage.typewriter('Typing message...')];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FakeLoader(messages: messages)),
        ),
      );

      expect(find.byType(TypewriterText), findsOneWidget);
    });

    testWidgets('validates assertions correctly', (WidgetTester tester) async {
      expect(
        () => FakeLoader(messages: const []),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => FakeLoader(messages: const ['Loading...'], maxLoops: 0),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => FakeLoader(
          messages: const ['Loading...'],
          spacingBetweenSpinnerAndText: -1.0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('handles weighted messages correctly', (
      WidgetTester tester,
    ) async {
      final messages = [
        FakeMessage.weighted('Common message', 0.9),
        FakeMessage.weighted('Rare message', 0.1),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeLoader(messages: messages, randomOrder: true),
          ),
        ),
      );

      // Should display one of the messages
      expect(find.textContaining('message'), findsOneWidget);
    });

    test('validates constructor parameters', () {
      expect(
        () => FakeLoader(messages: const ['Loading...'], maxLoops: -1),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => FakeLoader(
          messages: const ['Loading...'],
          spacingBetweenSpinnerAndText: -5.0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('FakeLoadingScreen Simple Widget Tests', () {
    testWidgets('should display full-screen layout with correct styling', (
      WidgetTester tester,
    ) async {
      const testBackgroundColor = Colors.black;
      const testTextColor = Colors.green;

      await tester.pumpWidget(
        MaterialApp(
          home: FakeLoadingScreen(
            messages: ['Test Message'],
            backgroundColor: testBackgroundColor,
            textColor: testTextColor,
            autoStart: false,
          ),
        ),
      );

      // Should find Scaffold with correct background color
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(testBackgroundColor));

      // Should find FakeLoader
      expect(find.byType(FakeLoader), findsOneWidget);

      // Should find text with correct color
      final text = tester.widget<Text>(find.text('Test Message'));
      expect(text.style?.color, equals(testTextColor));
    });

    testWidgets('should fill entire screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FakeLoadingScreen(
            messages: ['Full Screen Test'],
            autoStart: false,
          ),
        ),
      );

      // Should find Container with full width and height
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(SafeArea),
          matching: find.byType(Container),
        ),
      );
      expect(container.constraints?.maxWidth, equals(double.infinity));
      expect(container.constraints?.maxHeight, equals(double.infinity));
    });

    testWidgets('should apply custom padding', (WidgetTester tester) async {
      const testPadding = EdgeInsets.all(32.0);

      await tester.pumpWidget(
        MaterialApp(
          home: FakeLoadingScreen(
            messages: ['Padding Test'],
            padding: testPadding,
            autoStart: false,
          ),
        ),
      );

      // Should find Container with correct padding
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(SafeArea),
          matching: find.byType(Container),
        ),
      );
      expect(container.padding, equals(testPadding));
    });

    testWidgets('should show progress indicator when enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FakeLoadingScreen(
            messages: ['Progress Test'],
            showProgress: true,
            autoStart: false,
          ),
        ),
      );

      // Should find progress indicator
      expect(find.byType(FakeProgressIndicator), findsOneWidget);
    });

    testWidgets('should use custom spinner when provided', (
      WidgetTester tester,
    ) async {
      const customSpinnerKey = Key('custom-spinner');

      await tester.pumpWidget(
        MaterialApp(
          home: FakeLoadingScreen(
            messages: ['Spinner Test'],
            spinner: const CircularProgressIndicator(key: customSpinnerKey),
            autoStart: false,
          ),
        ),
      );

      // Should find custom spinner
      expect(find.byKey(customSpinnerKey), findsOneWidget);
    });

    testWidgets('should handle typewriter effect', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FakeLoadingScreen(
            messages: ['Typewriter Text'],
            effect: MessageEffect.typewriter,
            typewriterDelay: const Duration(milliseconds: 10),
            autoStart: false,
          ),
        ),
      );

      // Should find TypewriterText within the screen
      expect(
        find.descendant(
          of: find.byType(FakeLoadingScreen),
          matching: find.byType(TypewriterText),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should apply custom text alignment', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FakeLoadingScreen(
            messages: ['Aligned Text'],
            textAlign: TextAlign.left,
            autoStart: false,
          ),
        ),
      );

      // Find FakeLoader and check textAlign is passed through
      final fakeLoader = tester.widget<FakeLoader>(find.byType(FakeLoader));
      expect(fakeLoader.textAlign, equals(TextAlign.left));
    });

    testWidgets('should use custom progress widget when provided', (
      WidgetTester tester,
    ) async {
      const customProgressKey = Key('custom-progress');

      await tester.pumpWidget(
        MaterialApp(
          home: FakeLoadingScreen(
            messages: ['Progress Test'],
            showProgress: true,
            progressWidget: Container(
              key: customProgressKey,
              height: 10,
              color: Colors.purple,
            ),
            autoStart: false,
          ),
        ),
      );

      // Should find custom progress widget
      expect(find.byKey(customProgressKey), findsOneWidget);
    });

    testWidgets('should handle theme-based styling when colors not specified', (
      WidgetTester tester,
    ) async {
      final theme = ThemeData(
        scaffoldBackgroundColor: Colors.purple,
        textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.orange)),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: FakeLoadingScreen(messages: ['Theme Test'], autoStart: false),
        ),
      );

      // Should use theme's scaffold background color
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(Colors.purple));
    });

    testWidgets('should handle custom animation curve', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FakeLoadingScreen(
            messages: ['Animation Test'],
            animationCurve: Curves.bounceIn,
            autoStart: false,
          ),
        ),
      );

      // Find FakeLoader and check animationCurve is passed through
      final fakeLoader = tester.widget<FakeLoader>(find.byType(FakeLoader));
      expect(fakeLoader.animationCurve, equals(Curves.bounceIn));
    });

    testWidgets('should handle basic message display', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FakeLoadingScreen(
            messages: ['Simple Message'],
            autoStart: false,
          ),
        ),
      );

      // Should find the message
      expect(find.text('Simple Message'), findsOneWidget);
    });

    testWidgets('should handle multiple messages without auto-start', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FakeLoadingScreen(
            messages: ['Message 1', 'Message 2', 'Message 3'],
            autoStart: false,
          ),
        ),
      );

      // Should find the first message
      expect(find.text('Message 1'), findsOneWidget);
    });
  });
}

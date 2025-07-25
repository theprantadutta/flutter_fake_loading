import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('FakeProgressIndicator Visual Tests', () {
    testWidgets('should render with default styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      // Should find progress indicator
      expect(find.byType(FakeProgressIndicator), findsOneWidget);

      // Should find container for progress bar
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should animate progress visually', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      // Initial state
      await tester.pump();

      // Find progress container at start
      final initialContainers = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(FakeProgressIndicator),
              matching: find.byType(Container),
            ),
          )
          .toList();

      // Get initial width constraints
      double? initialWidth;
      for (final container in initialContainers) {
        if (container.constraints?.maxWidth != double.infinity) {
          initialWidth = container.constraints?.maxWidth;
          break;
        }
      }

      // Wait for animation to progress
      await tester.pump(const Duration(milliseconds: 100));

      // Find progress container at midpoint
      final midpointContainers = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(FakeProgressIndicator),
              matching: find.byType(Container),
            ),
          )
          .toList();

      // Get midpoint width constraints
      double? midpointWidth;
      for (final container in midpointContainers) {
        if (container.constraints?.maxWidth != double.infinity) {
          midpointWidth = container.constraints?.maxWidth;
          break;
        }
      }

      // Width should have increased
      if (initialWidth != null && midpointWidth != null) {
        expect(midpointWidth, greaterThan(initialWidth));
      }

      // Wait for animation to complete
      await tester.pump(const Duration(milliseconds: 150));
    });

    testWidgets('should apply custom styling', (WidgetTester tester) async {
      const testColor = Colors.red;
      const testHeight = 8.0;
      const testBorderRadius = BorderRadius.all(Radius.circular(4.0));
      const testBackgroundColor = Colors.grey;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(milliseconds: 100),
              color: testColor,
              height: testHeight,
              borderRadius: testBorderRadius,
              backgroundColor: testBackgroundColor,
            ),
          ),
        ),
      );

      // Find containers
      final containers = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(FakeProgressIndicator),
              matching: find.byType(Container),
            ),
          )
          .toList();

      // Check styling is applied
      bool foundStyledContainer = false;
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration?.color == testColor ||
            decoration?.color == testBackgroundColor ||
            container.constraints?.maxHeight == testHeight) {
          foundStyledContainer = true;
          break;
        }
      }

      expect(foundStyledContainer, isTrue);
    });

    testWidgets('should use custom builder when provided', (
      WidgetTester tester,
    ) async {
      const customKey = Key('custom-progress');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(milliseconds: 100),
              builder: (context, state) {
                return Container(
                  key: customKey,
                  height: 20,
                  width: 200 * state.progress,
                  color: Colors.purple,
                  child: Text('${(state.progress * 100).toInt()}%'),
                );
              },
            ),
          ),
        ),
      );

      // Should find custom widget
      expect(find.byKey(customKey), findsOneWidget);

      // Should find percentage text
      expect(find.textContaining('%'), findsOneWidget);

      // Wait for progress
      await tester.pump(const Duration(milliseconds: 50));

      // Should still find custom widget
      expect(find.byKey(customKey), findsOneWidget);

      // Should still find percentage text
      expect(find.textContaining('%'), findsOneWidget);
    });

    testWidgets('should call onComplete when finished', (
      WidgetTester tester,
    ) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(milliseconds: 100),
              onComplete: () => completed = true,
            ),
          ),
        ),
      );

      // Wait for animation to complete
      await tester.pump(const Duration(milliseconds: 150));

      // Callback should have been called
      expect(completed, isTrue);
    });

    testWidgets('should provide progress updates', (WidgetTester tester) async {
      final progressValues = <double>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(milliseconds: 100),
              onProgressChanged: (state) => progressValues.add(state.progress),
            ),
          ),
        ),
      );

      // Wait for animation to progress
      await tester.pump(const Duration(milliseconds: 25));
      await tester.pump(const Duration(milliseconds: 25));
      await tester.pump(const Duration(milliseconds: 25));
      await tester.pump(const Duration(milliseconds: 50));

      // Should have collected progress values
      expect(progressValues.length, greaterThan(2));

      // Progress should increase over time
      expect(progressValues.first, lessThan(progressValues.last));
      expect(progressValues.last, equals(1.0));
    });

    testWidgets('should respect animation curve', (WidgetTester tester) async {
      final progressValues = <double>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              onProgressChanged: (state) => progressValues.add(state.progress),
            ),
          ),
        ),
      );

      // Sample progress at regular intervals
      await tester.pump(const Duration(milliseconds: 25));
      await tester.pump(const Duration(milliseconds: 25));
      await tester.pump(const Duration(milliseconds: 25));
      await tester.pump(const Duration(milliseconds: 25));

      // Should have collected progress values
      expect(progressValues.length, greaterThan(2));

      // Progress should be monotonically increasing
      for (int i = 1; i < progressValues.length; i++) {
        expect(progressValues[i], greaterThanOrEqualTo(progressValues[i - 1]));
      }
    });

    testWidgets('should not auto-start when autoStart is false', (
      WidgetTester tester,
    ) async {
      double? progress;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(milliseconds: 100),
              autoStart: false,
              onProgressChanged: (state) => progress = state.progress,
            ),
          ),
        ),
      );

      // Wait some time
      await tester.pump(const Duration(milliseconds: 50));

      // Progress should still be at 0
      expect(progress ?? 0.0, equals(0.0));
    });

    testWidgets('should handle zero duration gracefully', (
      WidgetTester tester,
    ) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: Duration.zero,
              onComplete: () => completed = true,
            ),
          ),
        ),
      );

      // Should complete immediately
      await tester.pump();
      expect(completed, isTrue);
    });

    testWidgets('should handle very long durations', (
      WidgetTester tester,
    ) async {
      double? progress;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(seconds: 10),
              onProgressChanged: (state) => progress = state.progress,
            ),
          ),
        ),
      );

      // After a short time, progress should be minimal
      await tester.pump(const Duration(milliseconds: 100));
      expect(progress ?? 0.0, lessThan(0.1));
    });

    testWidgets('should track elapsed time correctly', (
      WidgetTester tester,
    ) async {
      ProgressState? state;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(milliseconds: 200),
              onProgressChanged: (s) => state = s,
            ),
          ),
        ),
      );

      // After 100ms, elapsed should be around 100ms
      await tester.pump(const Duration(milliseconds: 100));

      final currentState = state;
      if (currentState != null) {
        final elapsedMs = currentState.elapsed.inMilliseconds;
        expect(elapsedMs, greaterThan(50));
        expect(elapsedMs, lessThan(150));
      }
    });

    testWidgets('should calculate estimated remaining time', (
      WidgetTester tester,
    ) async {
      ProgressState? state;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(milliseconds: 200),
              onProgressChanged: (s) => state = s,
            ),
          ),
        ),
      );

      // At 50% progress, remaining time should be around 50% of total
      await tester.pump(const Duration(milliseconds: 100));

      final currentState = state;
      if (currentState != null &&
          currentState.progress > 0.3 &&
          currentState.progress < 0.7) {
        final remainingMs =
            currentState.estimatedRemaining?.inMilliseconds ?? 0;
        expect(remainingMs, greaterThan(50));
        expect(remainingMs, lessThan(150));
      }
    });

    testWidgets('should dispose resources properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: const Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      // Start animation
      await tester.pump(const Duration(milliseconds: 50));

      // Remove widget
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox())),
      );

      // Should not crash when disposed
      await tester.pump();

      // Additional pump to ensure no exceptions
      await tester.pump(const Duration(milliseconds: 50));
    });
  });
}

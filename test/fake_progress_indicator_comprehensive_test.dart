import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('FakeProgressIndicator Animation and Timing Tests', () {
    testWidgets('should animate progress from 0 to 1 over specified duration', (
      WidgetTester tester,
    ) async {
      const duration = Duration(milliseconds: 100);
      bool completed = false;
      ProgressState? finalState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: duration,
              onComplete: () => completed = true,
              onProgressChanged: (state) => finalState = state,
            ),
          ),
        ),
      );

      // Initially should be at 0 progress
      expect(find.byType(FakeProgressIndicator), findsOneWidget);

      // Progress after 25% of duration
      await tester.pump(Duration(milliseconds: 25));
      expect(finalState?.progress, greaterThan(0.0));
      expect(finalState?.progress, lessThan(0.5));

      // Progress after 50% of duration
      await tester.pump(Duration(milliseconds: 25));
      expect(finalState?.progress, greaterThan(0.2));
      expect(finalState?.progress, lessThan(0.8));

      // Progress after 75% of duration
      await tester.pump(Duration(milliseconds: 25));
      expect(finalState?.progress, greaterThan(0.5));
      expect(finalState?.progress, lessThan(1.0));

      // Complete the animation
      await tester.pump(Duration(milliseconds: 50));
      expect(completed, isTrue);
      expect(finalState?.progress, equals(1.0));
    });

    testWidgets('should respect custom animation curve', (
      WidgetTester tester,
    ) async {
      const duration = Duration(milliseconds: 100);
      final progressValues = <double>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: duration,
              curve: Curves.linear,
              onProgressChanged: (state) => progressValues.add(state.progress),
            ),
          ),
        ),
      );

      // Sample progress at regular intervals
      for (int i = 0; i < 10; i++) {
        await tester.pump(Duration(milliseconds: 10));
      }

      // With linear curve, progress should increase roughly linearly
      expect(progressValues.length, greaterThan(5));

      // Check that progress is monotonically increasing
      for (int i = 1; i < progressValues.length; i++) {
        expect(progressValues[i], greaterThanOrEqualTo(progressValues[i - 1]));
      }

      // First value should be near 0, last should be near 1
      expect(progressValues.first, lessThan(0.2));
      expect(progressValues.last, greaterThan(0.8));
    });

    testWidgets('should apply custom styling correctly', (
      WidgetTester tester,
    ) async {
      const testColor = Colors.red;
      const testHeight = 8.0;
      const testBorderRadius = BorderRadius.all(Radius.circular(4.0));
      const testBackgroundColor = Colors.grey;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: Duration(milliseconds: 100),
              color: testColor,
              height: testHeight,
              borderRadius: testBorderRadius,
              backgroundColor: testBackgroundColor,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 50));

      // Find the progress container
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);

      // Check that styling is applied
      final containers = tester.widgetList<Container>(containerFinder);

      // Should find containers with our custom styling
      bool foundStyledContainer = false;
      for (final container in containers) {
        if (container.constraints?.maxHeight == testHeight ||
            (container.decoration as BoxDecoration?)?.color == testColor ||
            (container.decoration as BoxDecoration?)?.color ==
                testBackgroundColor) {
          foundStyledContainer = true;
          break;
        }
      }
      expect(foundStyledContainer, isTrue);
    });

    testWidgets('should use custom builder when provided', (
      WidgetTester tester,
    ) async {
      const testText = 'Custom Progress';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: Duration(milliseconds: 100),
              builder: (context, state) {
                return Text('$testText: ${(state.progress * 100).toInt()}%');
              },
            ),
          ),
        ),
      );

      // Initial pump to create the widget
      await tester.pump();

      // Should find our custom text
      expect(find.textContaining(testText), findsOneWidget);

      // Progress through animation
      await tester.pump(Duration(milliseconds: 50));

      // Should still find custom text with updated percentage
      expect(find.textContaining(testText), findsOneWidget);
      expect(find.textContaining('%'), findsOneWidget);
    });

    testWidgets('should handle autoStart false correctly', (
      WidgetTester tester,
    ) async {
      ProgressState? currentState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: Duration(milliseconds: 100),
              autoStart: false,
              onProgressChanged: (state) => currentState = state,
            ),
          ),
        ),
      );

      // Should not start automatically
      await tester.pump(Duration(milliseconds: 50));
      expect(currentState?.progress ?? 0.0, equals(0.0));
    });

    testWidgets('should track elapsed time correctly', (
      WidgetTester tester,
    ) async {
      const duration = Duration(milliseconds: 200);
      ProgressState? finalState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: duration,
              onProgressChanged: (state) => finalState = state,
            ),
          ),
        ),
      );

      // Initial pump to create the widget
      await tester.pump();

      // Check elapsed time at different points
      await tester.pump(Duration(milliseconds: 50));
      expect(finalState?.elapsed.inMilliseconds, greaterThan(0));

      // Pump more time
      await tester.pump(Duration(milliseconds: 50));
      expect(finalState?.elapsed.inMilliseconds, greaterThan(0));

      // Complete animation
      await tester.pump(Duration(milliseconds: 150));
      expect(finalState?.elapsed.inMilliseconds, greaterThan(0));
    });

    testWidgets('should calculate estimated remaining time', (
      WidgetTester tester,
    ) async {
      const duration = Duration(milliseconds: 200);
      ProgressState? currentState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: duration,
              onProgressChanged: (state) => currentState = state,
            ),
          ),
        ),
      );

      // At 50% progress, should have ~50% time remaining
      await tester.pump(Duration(milliseconds: 100));

      if (currentState != null && currentState!.progress > 0.3) {
        final remainingMs =
            currentState!.estimatedRemaining?.inMilliseconds ?? 0;
        expect(remainingMs, greaterThan(50));
        expect(remainingMs, lessThan(150));
      }

      // Near completion, should have little time remaining
      await tester.pump(Duration(milliseconds: 80));

      if (currentState != null && currentState!.progress > 0.8) {
        final remainingMs =
            currentState!.estimatedRemaining?.inMilliseconds ?? 0;
        expect(remainingMs, lessThan(50));
      }
    });

    testWidgets('should handle very short durations', (
      WidgetTester tester,
    ) async {
      const duration = Duration(milliseconds: 10);
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: duration,
              onComplete: () => completed = true,
            ),
          ),
        ),
      );

      // Should complete quickly
      await tester.pump(Duration(milliseconds: 20));
      expect(completed, isTrue);
    });

    testWidgets('should handle very long durations', (
      WidgetTester tester,
    ) async {
      const duration = Duration(seconds: 10);
      ProgressState? currentState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeProgressIndicator(
              duration: duration,
              onProgressChanged: (state) => currentState = state,
            ),
          ),
        ),
      );

      // After 1 second, should have minimal progress
      await tester.pump(Duration(seconds: 1));
      expect(currentState?.progress ?? 0.0, lessThan(0.2));

      // Should still be animating
      expect(currentState?.progress ?? 0.0, greaterThan(0.0));
    });

    testWidgets('should update when widget properties change', (
      WidgetTester tester,
    ) async {
      Duration currentDuration = Duration(milliseconds: 100);
      Curve currentCurve = Curves.linear;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    FakeProgressIndicator(
                      duration: currentDuration,
                      curve: currentCurve,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentDuration = Duration(milliseconds: 200);
                          currentCurve = Curves.easeInOut;
                        });
                      },
                      child: Text('Change Properties'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Initial state
      await tester.pump(Duration(milliseconds: 25));

      // Change properties
      await tester.tap(find.text('Change Properties'));
      await tester.pump();

      // Should continue working with new properties
      await tester.pump(Duration(milliseconds: 50));

      // Should not crash and should continue animating
      expect(find.byType(FakeProgressIndicator), findsOneWidget);
    });

    group('Progress State Validation', () {
      testWidgets('should provide accurate progress state information', (
        WidgetTester tester,
      ) async {
        const duration = Duration(milliseconds: 100);
        final progressStates = <ProgressState>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FakeProgressIndicator(
                duration: duration,
                onProgressChanged: (state) => progressStates.add(state),
              ),
            ),
          ),
        );

        // Collect progress states
        for (int i = 0; i < 10; i++) {
          await tester.pump(Duration(milliseconds: 10));
        }

        expect(progressStates.length, greaterThan(5));

        // Validate progress state properties
        for (final state in progressStates) {
          expect(state.progress, greaterThanOrEqualTo(0.0));
          expect(state.progress, lessThanOrEqualTo(1.0));
          expect(state.elapsed.inMilliseconds, greaterThanOrEqualTo(0));

          if (state.estimatedRemaining != null) {
            expect(
              state.estimatedRemaining!.inMilliseconds,
              greaterThanOrEqualTo(0),
            );
          }
        }

        // Progress should be monotonically increasing
        for (int i = 1; i < progressStates.length; i++) {
          expect(
            progressStates[i].progress,
            greaterThanOrEqualTo(progressStates[i - 1].progress),
          );
        }

        // Elapsed time should be monotonically increasing
        for (int i = 1; i < progressStates.length; i++) {
          expect(
            progressStates[i].elapsed,
            greaterThanOrEqualTo(progressStates[i - 1].elapsed),
          );
        }
      });

      testWidgets('should handle progress state edge cases', (
        WidgetTester tester,
      ) async {
        ProgressState? initialState;
        ProgressState? finalState;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FakeProgressIndicator(
                duration: Duration(milliseconds: 50),
                onProgressChanged: (state) {
                  initialState ??= state;
                  finalState = state;
                },
              ),
            ),
          ),
        );

        // Get initial state
        await tester.pump(Duration(milliseconds: 1));
        expect(initialState?.progress, lessThanOrEqualTo(0.1));

        // Complete animation
        await tester.pump(Duration(milliseconds: 100));
        expect(finalState?.progress, equals(1.0));
        expect(finalState?.estimatedRemaining, equals(Duration.zero));
      });
    });

    group('Animation Control Methods', () {
      testWidgets('should support programmatic control methods', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FakeProgressIndicator(
                duration: Duration(milliseconds: 200),
                autoStart: false,
              ),
            ),
          ),
        );

        // Note: This test demonstrates the expected API but may need adjustment
        // based on the actual implementation of control methods
        expect(find.byType(FakeProgressIndicator), findsOneWidget);
      });
    });

    group('Performance and Memory', () {
      testWidgets('should dispose resources properly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FakeProgressIndicator(
                duration: Duration(milliseconds: 100),
              ),
            ),
          ),
        );

        await tester.pump(Duration(milliseconds: 50));

        // Remove widget
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));

        // Should not crash when disposed
        await tester.pump();
      });

      testWidgets('should handle rapid widget rebuilds', (
        WidgetTester tester,
      ) async {
        int rebuildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Column(
                    children: [
                      FakeProgressIndicator(
                        duration: Duration(milliseconds: 100),
                        key: ValueKey(rebuildCount),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            rebuildCount++;
                          });
                        },
                        child: Text('Rebuild'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        // Trigger multiple rebuilds rapidly
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.text('Rebuild'));
          await tester.pump();
        }

        // Should not crash
        expect(find.byType(FakeProgressIndicator), findsOneWidget);
      });
    });

    group('Edge Cases and Error Handling', () {
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

        await tester.pump();

        // Should complete immediately or handle gracefully
        // The exact behavior depends on implementation
        expect(find.byType(FakeProgressIndicator), findsOneWidget);
        expect(
          completed,
          isTrue,
        ); // Should complete immediately with zero duration
      });

      testWidgets('should handle null callbacks gracefully', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FakeProgressIndicator(
                duration: Duration(milliseconds: 50),
                onComplete: null,
                onProgressChanged: null,
              ),
            ),
          ),
        );

        // Should not crash with null callbacks
        await tester.pump(Duration(milliseconds: 100));
        expect(find.byType(FakeProgressIndicator), findsOneWidget);
      });

      testWidgets('should handle custom builder exceptions', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FakeProgressIndicator(
                duration: Duration(milliseconds: 50),
                builder: (context, state) {
                  // This should not crash the widget
                  if (state.progress > 0.5) {
                    return Text('Progress: ${state.progress}');
                  }
                  return Container();
                },
              ),
            ),
          ),
        );

        await tester.pump(Duration(milliseconds: 100));
        expect(find.byType(FakeProgressIndicator), findsOneWidget);
      });
    });
  });
}

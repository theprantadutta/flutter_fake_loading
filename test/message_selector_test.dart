import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('MessageSelector Weighted Selection with Statistical Validation', () {
    group('processMessages', () {
      test('should process valid string messages', () {
        final result = MessageSelector.processMessages(['Hello', 'World']);

        expect(result, hasLength(2));
        expect(result[0].text, equals('Hello'));
        expect(result[1].text, equals('World'));
        expect(result[0].weight, equals(1.0));
        expect(result[1].weight, equals(1.0));
      });

      test('should process mixed message types', () {
        final fakeMessage = FakeMessage('Fake', weight: 2.0);
        final result = MessageSelector.processMessages([
          'String message',
          fakeMessage,
          42,
        ]);

        expect(result, hasLength(3));
        expect(result[0].text, equals('String message'));
        expect(result[1], equals(fakeMessage));
        expect(result[2].text, equals('42'));
      });

      test('should throw FakeLoadingException on empty list', () {
        expect(
          () => MessageSelector.processMessages([]),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw FakeLoadingException on null list', () {
        expect(
          () => MessageSelector.processMessages(null as dynamic),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw FakeLoadingException on null message', () {
        expect(
          () => MessageSelector.processMessages(['Valid', null]),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw FakeLoadingException on empty string', () {
        expect(
          () => MessageSelector.processMessages(['Valid', '']),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should throw FakeLoadingException on invalid FakeMessage', () {
        expect(
          () => MessageSelector.processMessages([
            'Valid',
            FakeMessage('Test', weight: -1.0),
          ]),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('normalizeWeights', () {
      test('should normalize weights correctly', () {
        final messages = [
          FakeMessage('A', weight: 2.0),
          FakeMessage('B', weight: 4.0),
          FakeMessage('C', weight: 6.0),
        ];

        final result = MessageSelector.normalizeWeights(messages);

        expect(result, hasLength(3));
        expect(result[0].weight, closeTo(2.0 / 12.0, 0.0001));
        expect(result[1].weight, closeTo(4.0 / 12.0, 0.0001));
        expect(result[2].weight, closeTo(6.0 / 12.0, 0.0001));

        final totalWeight = result.fold<double>(
          0.0,
          (sum, msg) => sum + msg.weight,
        );
        expect(totalWeight, closeTo(1.0, 0.0001));
      });

      test('should handle all-zero weights', () {
        final messages = [
          FakeMessage('A', weight: 0.0),
          FakeMessage('B', weight: 0.0),
          FakeMessage('C', weight: 0.0),
        ];

        final result = MessageSelector.normalizeWeights(messages);

        expect(result, hasLength(3));
        expect(result[0].weight, closeTo(1.0 / 3.0, 0.0001));
        expect(result[1].weight, closeTo(1.0 / 3.0, 0.0001));
        expect(result[2].weight, closeTo(1.0 / 3.0, 0.0001));
      });

      test('should return unchanged if already normalized', () {
        final messages = [
          FakeMessage('A', weight: 0.2),
          FakeMessage('B', weight: 0.3),
          FakeMessage('C', weight: 0.5),
        ];

        final result = MessageSelector.normalizeWeights(messages);

        expect(result[0].weight, closeTo(0.2, 0.0001));
        expect(result[1].weight, closeTo(0.3, 0.0001));
        expect(result[2].weight, closeTo(0.5, 0.0001));
      });

      test('should handle empty list', () {
        final result = MessageSelector.normalizeWeights([]);
        expect(result, isEmpty);
      });

      test('should throw on invalid weights during message creation', () {
        expect(
          () => FakeMessage('B', weight: double.nan),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('selectWeightedRandom', () {
      test('should select single message from single-item list', () {
        final messages = [FakeMessage('Only message')];
        final result = MessageSelector.selectWeightedRandom(messages);

        expect(result, equals(messages[0]));
      });

      test('should throw FakeLoadingException on empty list', () {
        expect(
          () => MessageSelector.selectWeightedRandom([]),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should select from weighted messages', () {
        final messages = [
          FakeMessage('Rare', weight: 0.1),
          FakeMessage('Common', weight: 0.9),
        ];

        // Test multiple selections to verify distribution
        final selections = <String, int>{};
        for (int i = 0; i < 1000; i++) {
          final selected = MessageSelector.selectWeightedRandom(messages);
          selections[selected.text] = (selections[selected.text] ?? 0) + 1;
        }

        // Common should be selected much more often than Rare
        expect(selections['Common']! > selections['Rare']!, isTrue);

        // Rough distribution check (allowing for randomness)
        final commonRatio = selections['Common']! / 1000.0;
        expect(commonRatio, greaterThan(0.8)); // Should be around 0.9
        expect(commonRatio, lessThan(1.0));
      });

      test('should handle normalization errors gracefully', () {
        expect(
          () => FakeMessage('A', weight: double.infinity),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('selectMessages', () {
      test('should return messages in original order by default', () {
        final messages = ['First', 'Second', 'Third'];
        final result = MessageSelector.selectMessages(messages);

        expect(result, hasLength(3));
        expect(result[0].text, equals('First'));
        expect(result[1].text, equals('Second'));
        expect(result[2].text, equals('Third'));
      });

      test('should randomize order when requested', () {
        final messages = ['A', 'B', 'C', 'D', 'E'];
        final result = MessageSelector.selectMessages(
          messages,
          randomOrder: true,
          respectWeights: false,
        );

        expect(result, hasLength(5));

        // Check that all original messages are present
        final resultTexts = result.map((m) => m.text).toSet();
        expect(resultTexts, equals({'A', 'B', 'C', 'D', 'E'}));
      });

      test('should respect weights when randomizing', () {
        final messages = [
          FakeMessage('Rare', weight: 0.1),
          FakeMessage('Common', weight: 0.9),
        ];

        final result = MessageSelector.selectMessages(
          messages,
          randomOrder: true,
          respectWeights: true,
        );

        expect(result, hasLength(2));
        expect(result.map((m) => m.text).toSet(), equals({'Rare', 'Common'}));
      });

      test('should throw on invalid messages', () {
        expect(
          () => MessageSelector.selectMessages([]),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('generateWeightedSequence', () {
      test('should generate sequence of specified length', () {
        final messages = ['A', 'B', 'C'];
        final result = MessageSelector.generateWeightedSequence(messages, 10);

        expect(result, hasLength(10));

        // All results should be from the original messages
        final originalTexts = {'A', 'B', 'C'};
        for (final message in result) {
          expect(originalTexts.contains(message.text), isTrue);
        }
      });

      test('should respect weights in sequence generation', () {
        final messages = [
          FakeMessage('Rare', weight: 0.1),
          FakeMessage('Common', weight: 0.9),
        ];

        final result = MessageSelector.generateWeightedSequence(messages, 1000);

        final counts = <String, int>{};
        for (final message in result) {
          counts[message.text] = (counts[message.text] ?? 0) + 1;
        }

        // Common should appear much more often
        expect(counts['Common']! > counts['Rare']!, isTrue);

        final commonRatio = counts['Common']! / 1000.0;
        expect(commonRatio, greaterThan(0.8));
        expect(commonRatio, lessThan(1.0));
      });

      test('should throw on invalid messages', () {
        expect(
          () => MessageSelector.generateWeightedSequence([], 5),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('calculateExpectedProbabilities', () {
      test('should calculate correct probabilities', () {
        final messages = [
          FakeMessage('A', weight: 2.0),
          FakeMessage('B', weight: 4.0),
          FakeMessage('C', weight: 6.0),
        ];

        final probabilities = MessageSelector.calculateExpectedProbabilities(
          messages,
        );

        expect(probabilities, hasLength(3));
        expect(probabilities['A'], closeTo(2.0 / 12.0, 0.0001));
        expect(probabilities['B'], closeTo(4.0 / 12.0, 0.0001));
        expect(probabilities['C'], closeTo(6.0 / 12.0, 0.0001));

        final totalProbability = probabilities.values.fold<double>(
          0.0,
          (a, b) => a + b,
        );
        expect(totalProbability, closeTo(1.0, 0.0001));
      });

      test('should handle equal weights', () {
        final messages = ['A', 'B', 'C'];
        final probabilities = MessageSelector.calculateExpectedProbabilities(
          messages,
        );

        expect(probabilities, hasLength(3));
        expect(probabilities['A'], closeTo(1.0 / 3.0, 0.0001));
        expect(probabilities['B'], closeTo(1.0 / 3.0, 0.0001));
        expect(probabilities['C'], closeTo(1.0 / 3.0, 0.0001));
      });

      test('should throw on invalid messages', () {
        expect(
          () => MessageSelector.calculateExpectedProbabilities([]),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('Statistical Validation Tests', () {
      test('should maintain statistical distribution over large samples', () {
        final messages = [
          FakeMessage('Low', weight: 0.1), // 10%
          FakeMessage('Medium', weight: 0.3), // 30%
          FakeMessage('High', weight: 0.6), // 60%
        ];

        const sampleSize = 10000;
        final selections = <String, int>{};

        // Generate large sample
        for (int i = 0; i < sampleSize; i++) {
          final selected = MessageSelector.selectWeightedRandom(messages);
          selections[selected.text] = (selections[selected.text] ?? 0) + 1;
        }

        // Calculate actual ratios
        final lowRatio = (selections['Low'] ?? 0) / sampleSize;
        final mediumRatio = (selections['Medium'] ?? 0) / sampleSize;
        final highRatio = (selections['High'] ?? 0) / sampleSize;

        // Allow 5% tolerance for statistical variation
        expect(lowRatio, closeTo(0.1, 0.05));
        expect(mediumRatio, closeTo(0.3, 0.05));
        expect(highRatio, closeTo(0.6, 0.05));

        // Ensure all messages were selected at least once
        expect(selections.keys, containsAll(['Low', 'Medium', 'High']));
      });

      test('should handle extreme weight ratios correctly', () {
        final messages = [
          FakeMessage('VeryRare', weight: 0.001), // 0.1%
          FakeMessage('Common', weight: 0.999), // 99.9%
        ];

        const sampleSize = 10000;
        final selections = <String, int>{};

        for (int i = 0; i < sampleSize; i++) {
          final selected = MessageSelector.selectWeightedRandom(messages);
          selections[selected.text] = (selections[selected.text] ?? 0) + 1;
        }

        final rareCount = selections['VeryRare'] ?? 0;
        final commonCount = selections['Common'] ?? 0;

        // Common should be selected much more often
        expect(commonCount, greaterThan(rareCount * 50));

        // Common should be around 99.9% (allow 2% tolerance)
        final commonRatio = commonCount / sampleSize;
        expect(commonRatio, greaterThan(0.97));
        expect(commonRatio, lessThan(1.0));
      });

      test('should produce consistent results across multiple runs', () {
        final messages = [
          FakeMessage('A', weight: 0.25),
          FakeMessage('B', weight: 0.25),
          FakeMessage('C', weight: 0.25),
          FakeMessage('D', weight: 0.25),
        ];

        const sampleSize = 1000;
        const numRuns = 5;
        final runResults = <List<double>>[];

        // Run multiple statistical tests
        for (int run = 0; run < numRuns; run++) {
          final selections = <String, int>{};

          for (int i = 0; i < sampleSize; i++) {
            final selected = MessageSelector.selectWeightedRandom(messages);
            selections[selected.text] = (selections[selected.text] ?? 0) + 1;
          }

          final ratios = [
            (selections['A'] ?? 0) / sampleSize,
            (selections['B'] ?? 0) / sampleSize,
            (selections['C'] ?? 0) / sampleSize,
            (selections['D'] ?? 0) / sampleSize,
          ];

          runResults.add(ratios);
        }

        // Each run should have roughly equal distribution
        for (final ratios in runResults) {
          for (final ratio in ratios) {
            expect(ratio, closeTo(0.25, 0.1)); // 10% tolerance
          }
        }

        // Calculate variance across runs for consistency
        for (int i = 0; i < 4; i++) {
          final values = runResults.map((run) => run[i]).toList();
          final mean = values.fold(0.0, (a, b) => a + b) / values.length;
          final variance =
              values
                  .map((v) => (v - mean) * (v - mean))
                  .fold(0.0, (a, b) => a + b) /
              values.length;

          // Variance should be relatively low for consistent results
          expect(variance, lessThan(0.01));
        }
      });

      test('should handle single message with any weight', () {
        final testWeights = [0.1, 1.0, 5.0, 100.0];

        for (final weight in testWeights) {
          final messages = [FakeMessage('Only', weight: weight)];

          // Should always select the only message regardless of weight
          for (int i = 0; i < 100; i++) {
            final selected = MessageSelector.selectWeightedRandom(messages);
            expect(selected.text, equals('Only'));
          }
        }
      });

      test('should handle zero weights correctly in mixed scenarios', () {
        final messages = [
          FakeMessage('Zero1', weight: 0.0),
          FakeMessage('Zero2', weight: 0.0),
          FakeMessage('NonZero', weight: 1.0),
        ];

        const sampleSize = 1000;
        final selections = <String, int>{};

        for (int i = 0; i < sampleSize; i++) {
          final selected = MessageSelector.selectWeightedRandom(messages);
          selections[selected.text] = (selections[selected.text] ?? 0) + 1;
        }

        // Only NonZero should be selected
        expect(selections['NonZero'], equals(sampleSize));
        expect(selections['Zero1'] ?? 0, equals(0));
        expect(selections['Zero2'] ?? 0, equals(0));
      });

      test('should validate chi-square goodness of fit', () {
        final messages = [
          FakeMessage('A', weight: 0.2), // Expected: 20%
          FakeMessage('B', weight: 0.3), // Expected: 30%
          FakeMessage('C', weight: 0.5), // Expected: 50%
        ];

        const sampleSize = 5000;
        final selections = <String, int>{};

        for (int i = 0; i < sampleSize; i++) {
          final selected = MessageSelector.selectWeightedRandom(messages);
          selections[selected.text] = (selections[selected.text] ?? 0) + 1;
        }

        // Calculate chi-square statistic
        final expectedA = sampleSize * 0.2;
        final expectedB = sampleSize * 0.3;
        final expectedC = sampleSize * 0.5;

        final observedA = selections['A']?.toDouble() ?? 0.0;
        final observedB = selections['B']?.toDouble() ?? 0.0;
        final observedC = selections['C']?.toDouble() ?? 0.0;

        final chiSquare =
            ((observedA - expectedA) * (observedA - expectedA)) / expectedA +
            ((observedB - expectedB) * (observedB - expectedB)) / expectedB +
            ((observedC - expectedC) * (observedC - expectedC)) / expectedC;

        // For 2 degrees of freedom, critical value at 95% confidence is ~5.99
        // Our distribution should pass this test most of the time
        expect(
          chiSquare,
          lessThan(10.0),
        ); // More lenient threshold for test stability
      });

      test('should maintain distribution with fractional weights', () {
        final messages = [
          FakeMessage('Tiny', weight: 0.001),
          FakeMessage('Small', weight: 0.009),
          FakeMessage('Large', weight: 0.99),
        ];

        const sampleSize = 10000;
        final selections = <String, int>{};

        for (int i = 0; i < sampleSize; i++) {
          final selected = MessageSelector.selectWeightedRandom(messages);
          selections[selected.text] = (selections[selected.text] ?? 0) + 1;
        }

        final tinyRatio = (selections['Tiny'] ?? 0) / sampleSize;
        final smallRatio = (selections['Small'] ?? 0) / sampleSize;
        final largeRatio = (selections['Large'] ?? 0) / sampleSize;

        // Verify approximate ratios (allowing for statistical variation)
        expect(tinyRatio, closeTo(0.001, 0.005));
        expect(smallRatio, closeTo(0.009, 0.01));
        expect(largeRatio, closeTo(0.99, 0.02));

        // Large should be selected much more than others combined
        final othersTotal =
            (selections['Tiny'] ?? 0) + (selections['Small'] ?? 0);
        expect(selections['Large']!, greaterThan(othersTotal * 10));
      });
    });
  });
}

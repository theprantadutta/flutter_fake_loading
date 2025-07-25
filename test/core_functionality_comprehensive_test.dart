import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

/// Comprehensive unit tests for core functionality
/// This file consolidates and verifies all core functionality tests
/// as required by task 11
void main() {
  group('Core Functionality Comprehensive Tests', () {
    group('FakeMessage Weight and Effect Functionality', () {
      test('should create FakeMessage with weight and effect', () {
        final message = FakeMessage(
          'Test message',
          weight: 2.5,
          effect: MessageEffect.typewriter,
          duration: Duration(seconds: 1),
        );

        expect(message.text, equals('Test message'));
        expect(message.weight, equals(2.5));
        expect(message.effect, equals(MessageEffect.typewriter));
        expect(message.duration, equals(Duration(seconds: 1)));
      });

      test('should validate weight constraints', () {
        expect(
          () => FakeMessage('Test', weight: -1.0),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => FakeMessage('Test', weight: double.nan),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => FakeMessage('Test', weight: double.infinity),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(() => FakeMessage('Test', weight: 0.0), returnsNormally);
        expect(() => FakeMessage('Test', weight: 1.0), returnsNormally);
      });

      test('should support all message effects', () {
        for (final effect in MessageEffect.values) {
          expect(() => FakeMessage('Test', effect: effect), returnsNormally);
        }
      });

      test('should implement equality correctly with all fields', () {
        final message1 = FakeMessage(
          'Test',
          weight: 2.0,
          effect: MessageEffect.fade,
          duration: Duration(seconds: 1),
        );
        final message2 = FakeMessage(
          'Test',
          weight: 2.0,
          effect: MessageEffect.fade,
          duration: Duration(seconds: 1),
        );
        final message3 = FakeMessage(
          'Test',
          weight: 2.0,
          effect: MessageEffect.slide,
          duration: Duration(seconds: 1),
        );

        expect(message1, equals(message2));
        expect(message1, isNot(equals(message3)));
        expect(message1.hashCode, equals(message2.hashCode));
      });

      test('factory constructors should work correctly', () {
        final weighted = FakeMessage.weighted('Test', 2.5);
        expect(weighted.weight, equals(2.5));
        expect(weighted.text, equals('Test'));

        final typewriter = FakeMessage.typewriter('Test');
        expect(typewriter.effect, equals(MessageEffect.typewriter));
        expect(typewriter.text, equals('Test'));
      });
    });

    group('MessageSelector Weighted Selection', () {
      test('should process mixed message types correctly', () {
        final messages = [
          'String message',
          FakeMessage('Fake message', weight: 2.0),
          42, // Should be converted to string
        ];

        final processed = MessageSelector.processMessages(messages);

        expect(processed, hasLength(3));
        expect(processed[0].text, equals('String message'));
        expect(processed[0].weight, equals(1.0));
        expect(processed[1].text, equals('Fake message'));
        expect(processed[1].weight, equals(2.0));
        expect(processed[2].text, equals('42'));
        expect(processed[2].weight, equals(1.0));
      });

      test('should normalize weights correctly', () {
        final messages = [
          FakeMessage('A', weight: 2.0),
          FakeMessage('B', weight: 4.0),
          FakeMessage('C', weight: 6.0),
        ];

        final normalized = MessageSelector.normalizeWeights(messages);
        final totalWeight = normalized.fold<double>(
          0.0,
          (sum, msg) => sum + msg.weight,
        );

        expect(totalWeight, closeTo(1.0, 0.0001));
        expect(normalized[0].weight, closeTo(2.0 / 12.0, 0.0001));
        expect(normalized[1].weight, closeTo(4.0 / 12.0, 0.0001));
        expect(normalized[2].weight, closeTo(6.0 / 12.0, 0.0001));
      });

      test('should handle all-zero weights', () {
        final messages = [
          FakeMessage('A', weight: 0.0),
          FakeMessage('B', weight: 0.0),
        ];

        final normalized = MessageSelector.normalizeWeights(messages);

        expect(normalized[0].weight, closeTo(0.5, 0.0001));
        expect(normalized[1].weight, closeTo(0.5, 0.0001));
      });

      test('should perform weighted random selection', () {
        final messages = [
          FakeMessage('Rare', weight: 0.1),
          FakeMessage('Common', weight: 0.9),
        ];

        final selections = <String, int>{};
        for (int i = 0; i < 1000; i++) {
          final selected = MessageSelector.selectWeightedRandom(messages);
          selections[selected.text] = (selections[selected.text] ?? 0) + 1;
        }

        // Common should be selected much more often than Rare
        expect(selections['Common']! > selections['Rare']!, isTrue);
        final commonRatio = selections['Common']! / 1000.0;
        expect(commonRatio, greaterThan(0.8)); // Should be around 0.9
      });

      test('should calculate expected probabilities correctly', () {
        final messages = [
          FakeMessage('A', weight: 1.0),
          FakeMessage('B', weight: 2.0),
          FakeMessage('C', weight: 3.0),
        ];

        final probabilities = MessageSelector.calculateExpectedProbabilities(
          messages,
        );

        expect(probabilities['A'], closeTo(1.0 / 6.0, 0.0001));
        expect(probabilities['B'], closeTo(2.0 / 6.0, 0.0001));
        expect(probabilities['C'], closeTo(3.0 / 6.0, 0.0001));

        final totalProbability = probabilities.values.fold<double>(
          0.0,
          (a, b) => a + b,
        );
        expect(totalProbability, closeTo(1.0, 0.0001));
      });

      test('should validate input correctly', () {
        expect(
          () => MessageSelector.processMessages([]),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => MessageSelector.processMessages(['Valid', null]),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => MessageSelector.processMessages(['Valid', '']),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => MessageSelector.selectWeightedRandom([]),
          throwsA(isA<FakeLoadingException>()),
        );
      });
    });

    group('MessagePack Collections', () {
      test('should provide all predefined message packs', () {
        expect(FakeMessagePack.techStartup, isNotEmpty);
        expect(FakeMessagePack.gaming, isNotEmpty);
        expect(FakeMessagePack.casual, isNotEmpty);
        expect(FakeMessagePack.professional, isNotEmpty);

        // Each pack should have a reasonable number of messages
        expect(FakeMessagePack.techStartup.length, greaterThan(10));
        expect(FakeMessagePack.gaming.length, greaterThan(10));
        expect(FakeMessagePack.casual.length, greaterThan(10));
        expect(FakeMessagePack.professional.length, greaterThan(10));
      });

      test('should have unique messages within each pack', () {
        final packs = [
          FakeMessagePack.techStartup,
          FakeMessagePack.gaming,
          FakeMessagePack.casual,
          FakeMessagePack.professional,
        ];

        for (final pack in packs) {
          final uniqueMessages = pack.toSet();
          expect(uniqueMessages.length, equals(pack.length));
        }
      });

      test('should have different content between packs', () {
        final allPacks = [
          FakeMessagePack.techStartup,
          FakeMessagePack.gaming,
          FakeMessagePack.casual,
          FakeMessagePack.professional,
        ];

        for (int i = 0; i < allPacks.length; i++) {
          for (int j = i + 1; j < allPacks.length; j++) {
            final pack1 = allPacks[i].toSet();
            final pack2 = allPacks[j].toSet();
            final intersection = pack1.intersection(pack2);
            expect(intersection.isEmpty, isTrue);
          }
        }
      });

      test('should contain thematically appropriate content', () {
        // Tech startup should contain tech terms
        final techContent = FakeMessagePack.techStartup.join(' ').toLowerCase();
        final techKeywords = ['quantum', 'neural', 'algorithm', 'cloud', 'ai'];
        expect(
          techKeywords.any((keyword) => techContent.contains(keyword)),
          isTrue,
        );

        // Gaming should contain gaming terms
        final gamingContent = FakeMessagePack.gaming.join(' ').toLowerCase();
        final gamingKeywords = ['epic', 'legendary', 'power', 'boss', 'player'];
        expect(
          gamingKeywords.any((keyword) => gamingContent.contains(keyword)),
          isTrue,
        );

        // Casual should contain fun terms
        final casualContent = FakeMessagePack.casual.join(' ').toLowerCase();
        final casualKeywords = ['cats', 'flux capacitor', 'sheep', 'unicorns'];
        expect(
          casualKeywords.any((keyword) => casualContent.contains(keyword)),
          isTrue,
        );

        // Professional should contain business terms
        final professionalContent = FakeMessagePack.professional
            .join(' ')
            .toLowerCase();
        final professionalKeywords = [
          'processing',
          'validating',
          'establishing',
          'authenticating',
        ];
        expect(
          professionalKeywords.any(
            (keyword) => professionalContent.contains(keyword),
          ),
          isTrue,
        );
      });
    });

    group('CustomMessagePack Functionality', () {
      test('should create custom message pack correctly', () {
        final pack = CustomMessagePack(
          name: 'Test Pack',
          messages: ['Message 1', 'Message 2', 'Message 3'],
          description: 'A test pack',
        );

        expect(pack.name, equals('Test Pack'));
        expect(pack.messages, equals(['Message 1', 'Message 2', 'Message 3']));
        expect(pack.description, equals('A test pack'));
      });

      test('should validate empty messages list', () {
        expect(
          () => CustomMessagePack(name: 'Empty', messages: []),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should support copyWith functionality', () {
        final original = CustomMessagePack(
          name: 'Original',
          messages: ['Message 1'],
          description: 'Original description',
        );

        final copied = original.copyWith(
          name: 'Updated',
          messages: ['Message 1', 'Message 2'],
        );

        expect(copied.name, equals('Updated'));
        expect(copied.messages, equals(['Message 1', 'Message 2']));
        expect(copied.description, equals('Original description'));
      });

      test('should implement equality correctly', () {
        final pack1 = CustomMessagePack(
          name: 'Test',
          messages: ['A', 'B'],
          description: 'Test pack',
        );
        final pack2 = CustomMessagePack(
          name: 'Test',
          messages: ['A', 'B'],
          description: 'Test pack',
        );
        final pack3 = CustomMessagePack(
          name: 'Different',
          messages: ['A', 'B'],
          description: 'Test pack',
        );

        expect(pack1, equals(pack2));
        expect(pack1, isNot(equals(pack3)));
        expect(pack1.hashCode, equals(pack2.hashCode));
      });

      test('should provide meaningful toString', () {
        final pack = CustomMessagePack(
          name: 'Test Pack',
          messages: ['A', 'B', 'C'],
          description: 'Test description',
        );

        final result = pack.toString();
        expect(result, contains('Test Pack'));
        expect(result, contains('3 items'));
        expect(result, contains('Test description'));
      });
    });

    // Integration tests removed as requested - keeping only unit tests

    group('Error Handling and Validation', () {
      test('should provide meaningful error messages', () {
        try {
          MessageSelector.processMessages([]);
        } catch (e) {
          expect(e, isA<FakeLoadingException>());
          expect(e.toString(), contains('empty'));
        }

        try {
          FakeMessage('', weight: 1.0);
        } catch (e) {
          expect(e, isA<FakeLoadingException>());
          expect(e.toString(), contains('empty'));
        }

        try {
          FakeMessage('Test', weight: -1.0);
        } catch (e) {
          expect(e, isA<FakeLoadingException>());
          expect(e.toString(), contains('weight'));
        }
      });

      test('should handle null and invalid inputs', () {
        expect(
          () => MessageSelector.processMessages(['Valid', null]),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => MessageSelector.processMessages(['Valid', '']),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => FakeMessage('Test', weight: double.nan),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => FakeMessage('Test', weight: double.infinity),
          throwsA(isA<FakeLoadingException>()),
        );
      });

      test('should validate duration constraints', () {
        expect(
          () => FakeMessage('Test', duration: Duration(seconds: -1)),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => FakeMessage('Test', duration: Duration.zero),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => FakeMessage('Test', duration: Duration(hours: 25)),
          throwsA(isA<FakeLoadingException>()),
        );
        expect(
          () => FakeMessage('Test', duration: Duration(seconds: 1)),
          returnsNormally,
        );
      });
    });
  });
}

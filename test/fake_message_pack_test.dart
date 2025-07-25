import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('FakeMessagePack', () {
    group('techStartup pack', () {
      test('should contain valid messages', () {
        expect(FakeMessagePack.techStartup, isNotEmpty);
        expect(FakeMessagePack.techStartup.length, greaterThan(10));

        // Verify all messages are non-empty strings
        for (final message in FakeMessagePack.techStartup) {
          expect(message, isA<String>());
          expect(message.trim(), isNotEmpty);
        }
      });

      test('should contain tech-themed content', () {
        final messages = FakeMessagePack.techStartup.join(' ').toLowerCase();

        // Should contain tech-related keywords
        final techKeywords = [
          'quantum',
          'neural',
          'algorithm',
          'cloud',
          'machine learning',
          'microservices',
          'production',
          'infrastructure',
          'ai',
          'blockchain',
          'api',
          'devops',
        ];

        bool containsTechContent = false;
        for (final keyword in techKeywords) {
          if (messages.contains(keyword)) {
            containsTechContent = true;
            break;
          }
        }
        expect(
          containsTechContent,
          isTrue,
          reason: 'Tech startup pack should contain tech-related keywords',
        );
      });

      test('should have unique messages', () {
        final uniqueMessages = FakeMessagePack.techStartup.toSet();
        expect(
          uniqueMessages.length,
          equals(FakeMessagePack.techStartup.length),
          reason: 'All messages should be unique',
        );
      });
    });

    group('gaming pack', () {
      test('should contain valid messages', () {
        expect(FakeMessagePack.gaming, isNotEmpty);
        expect(FakeMessagePack.gaming.length, greaterThan(10));

        // Verify all messages are non-empty strings
        for (final message in FakeMessagePack.gaming) {
          expect(message, isA<String>());
          expect(message.trim(), isNotEmpty);
        }
      });

      test('should contain gaming-themed content', () {
        final messages = FakeMessagePack.gaming.join(' ').toLowerCase();

        // Should contain gaming-related keywords
        final gamingKeywords = [
          'epic',
          'legendary',
          'power',
          'dungeon',
          'boss',
          'monster',
          'weapon',
          'save',
          'player',
          'multiplayer',
          'character',
          'stats',
        ];

        bool containsGamingContent = false;
        for (final keyword in gamingKeywords) {
          if (messages.contains(keyword)) {
            containsGamingContent = true;
            break;
          }
        }
        expect(
          containsGamingContent,
          isTrue,
          reason: 'Gaming pack should contain gaming-related keywords',
        );
      });

      test('should have unique messages', () {
        final uniqueMessages = FakeMessagePack.gaming.toSet();
        expect(
          uniqueMessages.length,
          equals(FakeMessagePack.gaming.length),
          reason: 'All messages should be unique',
        );
      });
    });

    group('casual pack', () {
      test('should contain valid messages', () {
        expect(FakeMessagePack.casual, isNotEmpty);
        expect(FakeMessagePack.casual.length, greaterThan(10));

        // Verify all messages are non-empty strings
        for (final message in FakeMessagePack.casual) {
          expect(message, isA<String>());
          expect(message.trim(), isNotEmpty);
        }
      });

      test('should contain fun and casual content', () {
        final messages = FakeMessagePack.casual.join(' ').toLowerCase();

        // Should contain casual/fun keywords
        final casualKeywords = [
          'cats',
          'flux capacitor',
          'sheep',
          'coffee',
          'unicorns',
          'pixels',
          'headphones',
          'socks',
          'robots',
          'hamsters',
          'chaos',
        ];

        bool containsCasualContent = false;
        for (final keyword in casualKeywords) {
          if (messages.contains(keyword)) {
            containsCasualContent = true;
            break;
          }
        }
        expect(
          containsCasualContent,
          isTrue,
          reason: 'Casual pack should contain fun/casual keywords',
        );
      });

      test('should have unique messages', () {
        final uniqueMessages = FakeMessagePack.casual.toSet();
        expect(
          uniqueMessages.length,
          equals(FakeMessagePack.casual.length),
          reason: 'All messages should be unique',
        );
      });
    });

    group('professional pack', () {
      test('should contain valid messages', () {
        expect(FakeMessagePack.professional, isNotEmpty);
        expect(FakeMessagePack.professional.length, greaterThan(10));

        // Verify all messages are non-empty strings
        for (final message in FakeMessagePack.professional) {
          expect(message, isA<String>());
          expect(message.trim(), isNotEmpty);
        }
      });

      test('should contain professional content', () {
        final messages = FakeMessagePack.professional.join(' ').toLowerCase();

        // Should contain professional keywords
        final professionalKeywords = [
          'processing',
          'validating',
          'establishing',
          'authenticating',
          'synchronizing',
          'generating',
          'optimizing',
          'backing up',
          'verifying',
          'initializing',
          'connecting',
          'preparing',
        ];

        bool containsProfessionalContent = false;
        for (final keyword in professionalKeywords) {
          if (messages.contains(keyword)) {
            containsProfessionalContent = true;
            break;
          }
        }
        expect(
          containsProfessionalContent,
          isTrue,
          reason:
              'Professional pack should contain business-appropriate keywords',
        );
      });

      test('should have unique messages', () {
        final uniqueMessages = FakeMessagePack.professional.toSet();
        expect(
          uniqueMessages.length,
          equals(FakeMessagePack.professional.length),
          reason: 'All messages should be unique',
        );
      });
    });

    test('all packs should have different content', () {
      // Verify that each pack has distinct messages
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

          expect(
            intersection.isEmpty,
            isTrue,
            reason: 'Message packs should not share identical messages',
          );
        }
      }
    });
  });

  group('CustomMessagePack', () {
    test('should create with required parameters', () {
      final pack = CustomMessagePack(
        name: 'Test Pack',
        messages: ['Message 1', 'Message 2'],
      );

      expect(pack.name, equals('Test Pack'));
      expect(pack.messages, equals(['Message 1', 'Message 2']));
      expect(pack.description, isNull);
    });

    test('should create with optional description', () {
      final pack = CustomMessagePack(
        name: 'Test Pack',
        messages: ['Message 1'],
        description: 'A test message pack',
      );

      expect(pack.name, equals('Test Pack'));
      expect(pack.messages, equals(['Message 1']));
      expect(pack.description, equals('A test message pack'));
    });

    test('should throw ArgumentError for empty messages list', () {
      expect(
        () => CustomMessagePack(name: 'Empty Pack', messages: []),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should support copyWith method', () {
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

    test('should support copyWith with null values', () {
      final original = CustomMessagePack(
        name: 'Original',
        messages: ['Message 1'],
        description: 'Original description',
      );

      final copied = original.copyWith();

      expect(copied.name, equals(original.name));
      expect(copied.messages, equals(original.messages));
      expect(copied.description, equals(original.description));
    });

    test('should implement toString correctly', () {
      final pack1 = CustomMessagePack(
        name: 'Test Pack',
        messages: ['Message 1', 'Message 2'],
      );

      final pack2 = CustomMessagePack(
        name: 'Test Pack',
        messages: ['Message 1'],
        description: 'Test description',
      );

      expect(
        pack1.toString(),
        equals('CustomMessagePack(name: Test Pack, messages: 2 items)'),
      );
      expect(
        pack2.toString(),
        equals(
          'CustomMessagePack(name: Test Pack, messages: 1 items, description: Test description)',
        ),
      );
    });

    test('should implement equality correctly', () {
      final pack1 = CustomMessagePack(
        name: 'Test',
        messages: ['Message 1', 'Message 2'],
        description: 'Description',
      );

      final pack2 = CustomMessagePack(
        name: 'Test',
        messages: ['Message 1', 'Message 2'],
        description: 'Description',
      );

      final pack3 = CustomMessagePack(
        name: 'Different',
        messages: ['Message 1', 'Message 2'],
        description: 'Description',
      );

      expect(pack1, equals(pack2));
      expect(pack1, isNot(equals(pack3)));
      expect(pack1.hashCode, equals(pack2.hashCode));
    });

    test('should handle different message orders in equality', () {
      final pack1 = CustomMessagePack(
        name: 'Test',
        messages: ['Message 1', 'Message 2'],
      );

      final pack2 = CustomMessagePack(
        name: 'Test',
        messages: ['Message 2', 'Message 1'],
      );

      expect(
        pack1,
        isNot(equals(pack2)),
        reason: 'Message order should matter for equality',
      );
    });

    test('should handle null descriptions in equality', () {
      final pack1 = CustomMessagePack(name: 'Test', messages: ['Message 1']);

      final pack2 = CustomMessagePack(
        name: 'Test',
        messages: ['Message 1'],
        description: 'Description',
      );

      expect(pack1, isNot(equals(pack2)));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('FakeProgressIndicator Widget Tests', () {
    test('should create FakeProgressIndicator instance', () {
      const progressIndicator = FakeProgressIndicator(
        duration: Duration(seconds: 2),
        height: 6.0,
        autoStart: false,
      );

      expect(progressIndicator.duration, equals(const Duration(seconds: 2)));
      expect(progressIndicator.height, equals(6.0));
      expect(progressIndicator.autoStart, equals(false));
    });

    test('should create FakeProgressIndicator with custom builder', () {
      final progressIndicator = FakeProgressIndicator(
        duration: const Duration(seconds: 1),
        builder: (context, state) {
          return Text('Custom progress: ${state.progressPercentage}%');
        },
      );

      expect(progressIndicator.builder, isNotNull);
      expect(progressIndicator.duration, equals(const Duration(seconds: 1)));
    });
  });
}

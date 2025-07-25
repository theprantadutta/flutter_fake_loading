import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

void main() {
  group('ProgressState', () {
    test('should create valid progress state', () {
      const state = ProgressState(
        progress: 0.5,
        currentMessageIndex: 1,
        totalMessages: 3,
        elapsed: Duration(seconds: 1),
        estimatedRemaining: Duration(seconds: 1),
      );

      expect(state.progress, equals(0.5));
      expect(state.progressPercentage, equals(50.0));
      expect(state.currentMessageIndex, equals(1));
      expect(state.totalMessages, equals(3));
      expect(state.isComplete, isFalse);
    });

    test('should detect completion when progress is 1.0', () {
      const state = ProgressState(
        progress: 1.0,
        currentMessageIndex: 2,
        totalMessages: 3,
        elapsed: Duration(seconds: 2),
      );

      expect(state.isComplete, isTrue);
      expect(state.progressPercentage, equals(100.0));
    });
  });
}

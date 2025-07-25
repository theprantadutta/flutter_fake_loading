import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'sample_messages.dart';
import 'demo_constants.dart';
import '../utils/code_generator.dart';

/// Utility functions for demo operations and data manipulation
class DemoHelpers {
  // Private constructor to prevent instantiation
  DemoHelpers._();

  static final _random = math.Random();

  /// Generate random demo properties for a component type
  static Map<String, dynamic> generateRandomProperties(
    ComponentType componentType,
  ) {
    switch (componentType) {
      case ComponentType.fakeLoader:
        return {
          'messages': _getRandomMessages(),
          'duration': _getRandomDuration(),
          'randomOrder': _random.nextBool(),
          'loop': _random.nextBool(),
          'maxLoops': _random.nextInt(5) + 1,
        };
      case ComponentType.fakeLoadingScreen:
        return {
          'messages': _getRandomMessages(),
          'duration': _getRandomDuration(),
          'backgroundColor': _getRandomColor(),
          'textColor': _getRandomColor(),
          'progressColor': _getRandomColor(),
          'showProgress': _random.nextBool(),
        };
      case ComponentType.typewriterText:
        return {
          'text': _getRandomText(),
          'duration': _getRandomDuration(),
          'showCursor': _random.nextBool(),
          'cursorColor': _getRandomColor(),
        };
      case ComponentType.fakeProgressIndicator:
        return {
          'duration': _getRandomDuration(),
          'color': _getRandomColor(),
          'backgroundColor': _getRandomColor(),
          'strokeWidth': _getRandomStrokeWidth(),
        };
      case ComponentType.fakeLoadingOverlay:
        return {
          'messages': _getRandomMessages(),
          'duration': _getRandomDuration(),
          'backgroundColor': _getRandomColor().withValues(alpha: 0.7),
          'textColor': _getRandomColor(),
        };
    }
  }

  /// Get random messages from available packs
  static List<String> _getRandomMessages() {
    return SampleMessages.getRandomMessagePack();
  }

  /// Static getters for commonly used message collections
  static List<String> get basicMessages => SampleMessages.basicMessages;
  static List<String> get techStartupMessages =>
      SampleMessages.techStartupMessages;
  static List<String> get gamingMessages => SampleMessages.gamingMessages;
  static List<String> get creativeMessages => SampleMessages.funMessages;

  /// Get random duration within reasonable bounds
  static Duration _getRandomDuration() {
    final milliseconds = _random.nextInt(4500) + 500; // 500ms to 5000ms
    return Duration(milliseconds: milliseconds);
  }

  /// Get random color from demo colors
  static Color _getRandomColor() {
    return DemoConstants.demoColors[_random.nextInt(
      DemoConstants.demoColors.length,
    )];
  }

  /// Get random stroke width
  static double _getRandomStrokeWidth() {
    return (_random.nextDouble() * 8) + 2; // 2.0 to 10.0
  }

  /// Get random text for typewriter
  static String _getRandomText() {
    final texts = [
      'Hello, World!',
      'Welcome to the future of loading screens!',
      'This is a typewriter effect demonstration.',
      'Loading... but make it fun!',
      'Bringing personality to your apps.',
      'Because loading shouldn\'t be boring.',
    ];
    return texts[_random.nextInt(texts.length)];
  }

  /// Format duration for display
  static String formatDuration(Duration duration) {
    if (duration.inSeconds > 0) {
      final seconds = duration.inMilliseconds / 1000;
      return '${seconds.toStringAsFixed(1)}s';
    } else {
      return '${duration.inMilliseconds}ms';
    }
  }

  /// Format color for display
  static String formatColor(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.green) return 'Green';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.teal) return 'Teal';
    if (color == Colors.amber) return 'Amber';
    if (color == Colors.indigo) return 'Indigo';
    if (color == Colors.black) return 'Black';
    if (color == Colors.white) return 'White';

    // For custom colors, show hex value
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  /// Get contrasting color for text
  static Color getContrastingColor(Color backgroundColor) {
    // Calculate luminance using the new color component accessors
    final luminance =
        (0.299 * (backgroundColor.r * 255.0).round() +
            0.587 * (backgroundColor.g * 255.0).round() +
            0.114 * (backgroundColor.b * 255.0).round()) /
        255;

    // Return black for light backgrounds, white for dark backgrounds
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Validate property value against constraints
  static bool isValidValue(String propertyName, dynamic value) {
    switch (propertyName) {
      case 'duration':
        if (value is! Duration) return false;
        return value.inMilliseconds >= DemoConstants.minDuration &&
            value.inMilliseconds <= DemoConstants.maxDuration;
      case 'strokeWidth':
        if (value is! double) return false;
        return value >= DemoConstants.minStrokeWidth &&
            value <= DemoConstants.maxStrokeWidth;
      case 'maxLoops':
        if (value is! int) return false;
        return value >= DemoConstants.minLoops &&
            value <= DemoConstants.maxLoops;
      case 'messages':
        if (value is! List<String>) return false;
        return value.isNotEmpty;
      case 'text':
        if (value is! String) return false;
        return value.isNotEmpty;
      default:
        return true; // No specific validation for other properties
    }
  }

  /// Clamp value to valid range
  static dynamic clampValue(String propertyName, dynamic value) {
    switch (propertyName) {
      case 'duration':
        if (value is Duration) {
          final ms = value.inMilliseconds.clamp(
            DemoConstants.minDuration.toInt(),
            DemoConstants.maxDuration.toInt(),
          );
          return Duration(milliseconds: ms);
        }
        break;
      case 'strokeWidth':
        if (value is double) {
          return value.clamp(
            DemoConstants.minStrokeWidth,
            DemoConstants.maxStrokeWidth,
          );
        }
        break;
      case 'maxLoops':
        if (value is int) {
          return value.clamp(DemoConstants.minLoops, DemoConstants.maxLoops);
        }
        break;
    }
    return value;
  }

  /// Get property display name
  static String getPropertyDisplayName(String propertyName) {
    switch (propertyName) {
      case 'backgroundColor':
        return 'Background Color';
      case 'textColor':
        return 'Text Color';
      case 'progressColor':
        return 'Progress Color';
      case 'cursorColor':
        return 'Cursor Color';
      case 'strokeWidth':
        return 'Stroke Width';
      case 'showProgress':
        return 'Show Progress';
      case 'showCursor':
        return 'Show Cursor';
      case 'randomOrder':
        return 'Random Order';
      case 'maxLoops':
        return 'Max Loops';
      case 'onComplete':
        return 'On Complete';
      default:
        // Convert camelCase to Title Case
        return propertyName
            .replaceAllMapped(
              RegExp(r'([A-Z])'),
              (match) => ' ${match.group(1)}',
            )
            .trim()
            .split(' ')
            .map(
              (word) => word[0].toUpperCase() + word.substring(1).toLowerCase(),
            )
            .join(' ');
    }
  }

  /// Get property description
  static String? getPropertyDescription(String propertyName) {
    switch (propertyName) {
      case 'messages':
        return 'List of messages to display during loading';
      case 'duration':
        return 'How long each message is displayed';
      case 'randomOrder':
        return 'Display messages in random order';
      case 'loop':
        return 'Continuously loop through messages';
      case 'maxLoops':
        return 'Maximum number of loops (if looping is enabled)';
      case 'showProgress':
        return 'Display a progress indicator';
      case 'showCursor':
        return 'Show blinking cursor during typing';
      case 'strokeWidth':
        return 'Thickness of the progress indicator';
      case 'text':
        return 'Text to display with typewriter effect';
      default:
        return null;
    }
  }

  /// Generate sample code snippet for documentation
  static String generateSampleCode(ComponentType componentType) {
    final sampleProperties = generateRandomProperties(componentType);
    return CodeGenerator.generateCompleteExample(
      componentType,
      sampleProperties,
      title: componentType.name,
    );
  }

  /// Get component icon
  static IconData getComponentIcon(ComponentType componentType) {
    switch (componentType) {
      case ComponentType.fakeLoader:
        return Icons.refresh;
      case ComponentType.fakeLoadingScreen:
        return Icons.fullscreen;
      case ComponentType.typewriterText:
        return Icons.keyboard;
      case ComponentType.fakeProgressIndicator:
        return Icons.donut_large;
      case ComponentType.fakeLoadingOverlay:
        return Icons.layers;
    }
  }

  /// Get component description
  static String getComponentDescription(ComponentType componentType) {
    switch (componentType) {
      case ComponentType.fakeLoader:
        return 'Core loading widget with customizable messages and effects';
      case ComponentType.fakeLoadingScreen:
        return 'Full-screen loading experience with progress indicators';
      case ComponentType.typewriterText:
        return 'Character-by-character text animation effect';
      case ComponentType.fakeProgressIndicator:
        return 'Standalone progress simulation widget';
      case ComponentType.fakeLoadingOverlay:
        return 'Overlay loading for async operations';
    }
  }
}

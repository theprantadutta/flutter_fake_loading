import 'package:flutter/material.dart';
import 'sample_messages.dart';
import 'demo_constants.dart';

/// Pre-configured demo setups for different components
class DemoConfiguration {
  final String name;
  final String description;
  final Map<String, dynamic> properties;
  final List<String> tags;

  const DemoConfiguration({
    required this.name,
    required this.description,
    required this.properties,
    this.tags = const [],
  });
}

/// Collection of demo configurations for the showcase app
class DemoConfigurations {
  // Private constructor to prevent instantiation
  DemoConfigurations._();

  /// FakeLoader demo configurations
  static final List<DemoConfiguration> fakeLoaderConfigs = [
    DemoConfiguration(
      name: 'Basic Loader',
      description: 'Simple loading messages with default settings',
      properties: {
        'messages': SampleMessages.basicMessages,
        'duration': DemoConstants.mediumDuration,
      },
      tags: ['Basic', 'Simple'],
    ),
    DemoConfiguration(
      name: 'Fun Loader',
      description: 'Quirky and entertaining loading messages',
      properties: {
        'messages': SampleMessages.funMessages,
        'duration': DemoConstants.longDuration,
        'randomOrder': true,
      },
      tags: ['Fun', 'Random'],
    ),
    DemoConfiguration(
      name: 'Looping Loader',
      description: 'Continuously looping loading messages',
      properties: {
        'messages': SampleMessages.techStartupMessages,
        'duration': DemoConstants.shortDuration,
        'loop': true,
        'maxLoops': 3,
      },
      tags: ['Loop', 'Tech'],
    ),
    DemoConfiguration(
      name: 'Styled Loader',
      description: 'Custom styled loading text',
      properties: {
        'messages': SampleMessages.gamingMessages,
        'duration': DemoConstants.mediumDuration,
        'textStyle': DemoConstants.largeTextStyle,
      },
      tags: ['Styled', 'Gaming'],
    ),
  ];

  /// FakeLoadingScreen demo configurations
  static final List<DemoConfiguration> fakeLoadingScreenConfigs = [
    DemoConfiguration(
      name: 'Default Screen',
      description: 'Full-screen loading with progress indicator',
      properties: {
        'messages': SampleMessages.basicMessages,
        'duration': DemoConstants.mediumDuration,
        'showProgress': true,
      },
      tags: ['Fullscreen', 'Progress'],
    ),
    DemoConfiguration(
      name: 'Dark Theme Screen',
      description: 'Dark themed loading screen',
      properties: {
        'messages': SampleMessages.sciFiMessages,
        'duration': DemoConstants.longDuration,
        'backgroundColor': Colors.black,
        'textColor': Colors.green,
        'progressColor': Colors.green,
        'showProgress': true,
      },
      tags: ['Dark', 'Themed', 'Sci-Fi'],
    ),
    DemoConfiguration(
      name: 'Colorful Screen',
      description: 'Bright and colorful loading screen',
      properties: {
        'messages': SampleMessages.funMessages,
        'duration': DemoConstants.mediumDuration,
        'backgroundColor': Colors.purple.shade100,
        'textColor': Colors.purple.shade800,
        'progressColor': Colors.orange,
        'showProgress': true,
      },
      tags: ['Colorful', 'Fun'],
    ),
  ];

  /// TypewriterText demo configurations
  static final List<DemoConfiguration> typewriterTextConfigs = [
    DemoConfiguration(
      name: 'Basic Typewriter',
      description: 'Simple typewriter effect',
      properties: {
        'text': 'Hello, World! This is a typewriter effect.',
        'duration': DemoConstants.mediumDuration,
        'showCursor': true,
      },
      tags: ['Basic', 'Cursor'],
    ),
    DemoConfiguration(
      name: 'Fast Typewriter',
      description: 'Quick typing animation',
      properties: {
        'text': 'Fast typing effect for quick reveals!',
        'duration': DemoConstants.shortDuration,
        'showCursor': false,
      },
      tags: ['Fast', 'No Cursor'],
    ),
    DemoConfiguration(
      name: 'Styled Typewriter',
      description: 'Typewriter with custom styling',
      properties: {
        'text': 'Styled typewriter text with custom appearance.',
        'duration': DemoConstants.longDuration,
        'style': DemoConstants.largeTextStyle,
        'showCursor': true,
        'cursorColor': Colors.red,
      },
      tags: ['Styled', 'Custom Cursor'],
    ),
  ];

  /// FakeProgressIndicator demo configurations
  static final List<DemoConfiguration> fakeProgressIndicatorConfigs = [
    DemoConfiguration(
      name: 'Default Progress',
      description: 'Standard circular progress indicator',
      properties: {'duration': DemoConstants.mediumDuration},
      tags: ['Basic', 'Circular'],
    ),
    DemoConfiguration(
      name: 'Thick Progress',
      description: 'Progress indicator with thick stroke',
      properties: {
        'duration': DemoConstants.longDuration,
        'strokeWidth': 8.0,
        'color': Colors.blue,
      },
      tags: ['Thick', 'Blue'],
    ),
    DemoConfiguration(
      name: 'Colorful Progress',
      description: 'Multi-colored progress indicator',
      properties: {
        'duration': DemoConstants.shortDuration,
        'color': Colors.orange,
        'backgroundColor': Colors.orange.shade100,
        'strokeWidth': 6.0,
      },
      tags: ['Colorful', 'Background'],
    ),
  ];

  /// FakeLoadingOverlay demo configurations
  static final List<DemoConfiguration> fakeLoadingOverlayConfigs = [
    DemoConfiguration(
      name: 'Basic Overlay',
      description: 'Simple loading overlay',
      properties: {
        'messages': SampleMessages.basicMessages,
        'duration': DemoConstants.mediumDuration,
      },
      tags: ['Basic', 'Overlay'],
    ),
    DemoConfiguration(
      name: 'Themed Overlay',
      description: 'Custom themed loading overlay',
      properties: {
        'messages': SampleMessages.cookingMessages,
        'duration': DemoConstants.longDuration,
        'backgroundColor': Colors.black54,
        'textColor': Colors.white,
      },
      tags: ['Themed', 'Cooking'],
    ),
  ];

  /// Get all configurations by component type
  static Map<String, List<DemoConfiguration>> getAllConfigurations() {
    return {
      'FakeLoader': fakeLoaderConfigs,
      'FakeLoadingScreen': fakeLoadingScreenConfigs,
      'TypewriterText': typewriterTextConfigs,
      'FakeProgressIndicator': fakeProgressIndicatorConfigs,
      'FakeLoadingOverlay': fakeLoadingOverlayConfigs,
    };
  }

  /// Get configurations for a specific component
  static List<DemoConfiguration> getConfigurationsForComponent(
    String component,
  ) {
    final allConfigs = getAllConfigurations();
    return allConfigs[component] ?? [];
  }

  /// Get a random configuration for a component
  static DemoConfiguration? getRandomConfiguration(String component) {
    final configs = getConfigurationsForComponent(component);
    if (configs.isEmpty) return null;
    configs.shuffle();
    return configs.first;
  }

  /// Get configurations by tag
  static List<DemoConfiguration> getConfigurationsByTag(String tag) {
    final allConfigs = getAllConfigurations();
    final result = <DemoConfiguration>[];

    for (final configs in allConfigs.values) {
      result.addAll(configs.where((config) => config.tags.contains(tag)));
    }

    return result;
  }

  /// Get all available tags
  static List<String> getAllTags() {
    final allConfigs = getAllConfigurations();
    final tags = <String>{};

    for (final configs in allConfigs.values) {
      for (final config in configs) {
        tags.addAll(config.tags);
      }
    }

    return tags.toList()..sort();
  }
}

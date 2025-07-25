import 'package:flutter/material.dart';
import '../utils/code_generator.dart';
import 'demo_constants.dart';
import 'sample_messages.dart';

/// Model for playground state management
class PlaygroundState {
  final ComponentType componentType;
  final Map<String, dynamic> properties;
  final String generatedCode;
  final bool isPlaying;

  const PlaygroundState({
    required this.componentType,
    required this.properties,
    required this.generatedCode,
    this.isPlaying = false,
  });

  PlaygroundState copyWith({
    ComponentType? componentType,
    Map<String, dynamic>? properties,
    String? generatedCode,
    bool? isPlaying,
  }) {
    return PlaygroundState(
      componentType: componentType ?? this.componentType,
      properties: properties ?? this.properties,
      generatedCode: generatedCode ?? this.generatedCode,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  /// Update a single property and regenerate code
  PlaygroundState updateProperty(String key, dynamic value) {
    final newProperties = Map<String, dynamic>.from(properties);
    newProperties[key] = value;

    final newCode = CodeGenerator.generateCode(componentType, newProperties);

    return copyWith(properties: newProperties, generatedCode: newCode);
  }

  /// Reset to default state for the component type
  PlaygroundState resetToDefaults() {
    final defaultProperties = _getDefaultPropertiesForComponent(componentType);
    final newCode = CodeGenerator.generateCode(
      componentType,
      defaultProperties,
    );

    return copyWith(
      properties: defaultProperties,
      generatedCode: newCode,
      isPlaying: false,
    );
  }

  /// Get default properties for a component type
  static Map<String, dynamic> _getDefaultPropertiesForComponent(
    ComponentType type,
  ) {
    switch (type) {
      case ComponentType.fakeLoader:
        return {
          'messages': SampleMessages.basicMessages,
          'duration': DemoConstants.mediumDuration,
          'randomOrder': false,
          'loopUntilComplete': false,
          'maxLoops': 1,
          'textAlign': 'center',
        };
      case ComponentType.fakeLoadingScreen:
        return {
          'messages': SampleMessages.basicMessages,
          'duration': DemoConstants.mediumDuration,
          'showProgress': true,
          'backgroundColor': Colors.white,
          'textColor': Colors.black,
          'progressColor': Colors.blue,
        };
      case ComponentType.typewriterText:
        return {
          'text': 'Hello, World!',
          'characterDelay': const Duration(milliseconds: 50),
          'showCursor': true,
          'cursorColor': Colors.black,
        };
      case ComponentType.fakeProgressIndicator:
        return {
          'duration': DemoConstants.mediumDuration,
          'color': Colors.blue,
          'backgroundColor': Colors.grey.shade300,
          'height': DemoConstants.defaultStrokeWidth,
        };
      case ComponentType.fakeLoadingOverlay:
        return {
          'messages': SampleMessages.basicMessages,
          'duration': DemoConstants.mediumDuration,
          'backgroundColor': Colors.black54,
          'textColor': Colors.white,
        };
    }
  }

  /// Create initial state for a component type
  static PlaygroundState createInitialState(ComponentType componentType) {
    final properties = _getDefaultPropertiesForComponent(componentType);
    final code = CodeGenerator.generateCode(componentType, properties);

    return PlaygroundState(
      componentType: componentType,
      properties: properties,
      generatedCode: code,
    );
  }
}

/// Model for demo configuration state
class DemoConfigurationState {
  final String name;
  final String description;
  final Map<String, dynamic> properties;
  final List<String> tags;
  final bool isFavorite;
  final DateTime lastUsed;

  const DemoConfigurationState({
    required this.name,
    required this.description,
    required this.properties,
    this.tags = const [],
    this.isFavorite = false,
    required this.lastUsed,
  });

  DemoConfigurationState copyWith({
    String? name,
    String? description,
    Map<String, dynamic>? properties,
    List<String>? tags,
    bool? isFavorite,
    DateTime? lastUsed,
  }) {
    return DemoConfigurationState(
      name: name ?? this.name,
      description: description ?? this.description,
      properties: properties ?? this.properties,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  /// Toggle favorite status
  DemoConfigurationState toggleFavorite() {
    return copyWith(isFavorite: !isFavorite);
  }

  /// Update last used timestamp
  DemoConfigurationState markAsUsed() {
    return copyWith(lastUsed: DateTime.now());
  }
}

/// Helper functions for playground state management
class PlaygroundStateHelpers {
  // Private constructor to prevent instantiation
  PlaygroundStateHelpers._();

  /// Validate property value for a given type
  static bool isValidPropertyValue(
    String propertyName,
    dynamic value,
    ComponentType componentType,
  ) {
    final mappings = CodeGenerator.getPropertyMappings(componentType);
    final mapping = mappings[propertyName];

    if (mapping == null) return false;

    switch (mapping.type) {
      case PropertyType.string:
        return value is String;
      case PropertyType.stringList:
        return value is List<String>;
      case PropertyType.duration:
        return value is Duration;
      case PropertyType.color:
        return value is Color;
      case PropertyType.boolean:
        return value is bool;
      case PropertyType.number:
        return value is num;
      case PropertyType.enumValue:
        return value is String; // Enum values are stored as strings
      case PropertyType.textStyle:
        return value is TextStyle;
      case PropertyType.callback:
        return value is Function;
      case PropertyType.widget:
        return value is Widget;
      case PropertyType.borderRadius:
        return value is BorderRadius || value is String;
      case PropertyType.curve:
        return value is Curve || value is String;
    }
  }

  /// Get property constraints for validation
  static Map<String, dynamic>? getPropertyConstraints(
    String propertyName,
    ComponentType componentType,
  ) {
    switch (propertyName) {
      case 'duration':
        return {
          'min': DemoConstants.minDuration,
          'max': DemoConstants.maxDuration,
        };
      case 'height':
        return {
          'min': DemoConstants.minStrokeWidth,
          'max': DemoConstants.maxStrokeWidth,
        };
      case 'maxLoops':
        return {'min': DemoConstants.minLoops, 'max': DemoConstants.maxLoops};
      default:
        return null;
    }
  }

  /// Generate property control options for UI
  static Map<String, dynamic>? getPropertyControlOptions(
    String propertyName,
    ComponentType componentType,
  ) {
    switch (propertyName) {
      case 'messages':
        return {
          'items': SampleMessages.getAvailableCategories(),
          'itemLabels': SampleMessages.getAvailableCategories(),
        };
      case 'duration':
        return {
          'min': DemoConstants.minDuration,
          'max': DemoConstants.maxDuration,
          'divisions': 100,
        };
      case 'height':
        return {
          'min': DemoConstants.minStrokeWidth,
          'max': DemoConstants.maxStrokeWidth,
          'step': 0.5,
        };
      case 'maxLoops':
        return {
          'min': DemoConstants.minLoops,
          'max': DemoConstants.maxLoops,
          'step': 1,
        };
      case 'backgroundColor':
      case 'textColor':
      case 'progressColor':
      case 'cursorColor':
      case 'color':
        return {'colors': DemoConstants.demoColors};
      default:
        return null;
    }
  }
}

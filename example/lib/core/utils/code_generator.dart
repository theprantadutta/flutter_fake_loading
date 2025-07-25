import 'package:flutter/material.dart';
import '../services/performance_service.dart';

/// Enum for different component types
enum ComponentType {
  fakeLoader,
  fakeLoadingScreen,
  fakeLoadingOverlay,
  fakeProgressIndicator,
  typewriterText,
}

/// Template configuration for code generation
class CodeTemplate {
  final String widgetName;
  final List<String> requiredImports;
  final Map<String, PropertyMapping> propertyMappings;
  final String? customWrapper;

  const CodeTemplate({
    required this.widgetName,
    required this.requiredImports,
    required this.propertyMappings,
    this.customWrapper,
  });
}

/// Property mapping configuration
class PropertyMapping {
  final String dartPropertyName;
  final PropertyType type;
  final dynamic defaultValue;
  final String? enumType;
  final bool isRequired;

  const PropertyMapping({
    required this.dartPropertyName,
    required this.type,
    this.defaultValue,
    this.enumType,
    this.isRequired = false,
  });
}

/// Types of properties for code generation
enum PropertyType {
  string,
  stringList,
  duration,
  color,
  textStyle,
  enumValue,
  callback,
  boolean,
  number,
  widget,
  borderRadius,
  curve,
}

/// Utility class for generating dynamic code examples
class CodeGenerator {
  static const String _baseImport =
      "import 'package:flutter_fake_loading/flutter_fake_loading.dart';";
  static const String _flutterImport =
      "import 'package:flutter/material.dart';";

  /// Template configurations for different component types
  static final Map<ComponentType, CodeTemplate> _templates = {
    ComponentType.fakeLoader: CodeTemplate(
      widgetName: 'FakeLoader',
      requiredImports: [_flutterImport, _baseImport],
      propertyMappings: {
        'messages': PropertyMapping(
          dartPropertyName: 'messages',
          type: PropertyType.stringList,
          isRequired: true,
        ),
        'duration': PropertyMapping(
          dartPropertyName: 'duration',
          type: PropertyType.duration,
          defaultValue: Duration(milliseconds: 2000),
        ),
        'randomOrder': PropertyMapping(
          dartPropertyName: 'randomOrder',
          type: PropertyType.boolean,
          defaultValue: false,
        ),
        'loopUntilComplete': PropertyMapping(
          dartPropertyName: 'loopUntilComplete',
          type: PropertyType.boolean,
          defaultValue: false,
        ),
        'maxLoops': PropertyMapping(
          dartPropertyName: 'maxLoops',
          type: PropertyType.number,
        ),
        'effect': PropertyMapping(
          dartPropertyName: 'effect',
          type: PropertyType.enumValue,
          enumType: 'MessageEffect',
          defaultValue: 'fade',
        ),
        'textStyle': PropertyMapping(
          dartPropertyName: 'textStyle',
          type: PropertyType.textStyle,
        ),
        'textAlign': PropertyMapping(
          dartPropertyName: 'textAlign',
          type: PropertyType.enumValue,
          enumType: 'TextAlign',
          defaultValue: 'center',
        ),
      },
    ),
    ComponentType.fakeLoadingScreen: CodeTemplate(
      widgetName: 'FakeLoadingScreen',
      requiredImports: [_flutterImport, _baseImport],
      propertyMappings: {
        'messages': PropertyMapping(
          dartPropertyName: 'messages',
          type: PropertyType.stringList,
          isRequired: true,
        ),
        'duration': PropertyMapping(
          dartPropertyName: 'duration',
          type: PropertyType.duration,
          defaultValue: Duration(milliseconds: 2000),
        ),
        'backgroundColor': PropertyMapping(
          dartPropertyName: 'backgroundColor',
          type: PropertyType.color,
        ),
        'textColor': PropertyMapping(
          dartPropertyName: 'textColor',
          type: PropertyType.color,
        ),
        'showProgress': PropertyMapping(
          dartPropertyName: 'showProgress',
          type: PropertyType.boolean,
          defaultValue: true,
        ),
        'progressColor': PropertyMapping(
          dartPropertyName: 'progressColor',
          type: PropertyType.color,
        ),
        'onComplete': PropertyMapping(
          dartPropertyName: 'onComplete',
          type: PropertyType.callback,
        ),
      },
    ),
    ComponentType.fakeLoadingOverlay: CodeTemplate(
      widgetName: 'FakeLoadingOverlay',
      requiredImports: [_flutterImport, _baseImport],
      propertyMappings: {
        'messages': PropertyMapping(
          dartPropertyName: 'messages',
          type: PropertyType.stringList,
          isRequired: true,
        ),
        'duration': PropertyMapping(
          dartPropertyName: 'duration',
          type: PropertyType.duration,
          defaultValue: Duration(milliseconds: 2000),
        ),
        'backgroundColor': PropertyMapping(
          dartPropertyName: 'backgroundColor',
          type: PropertyType.color,
        ),
        'textColor': PropertyMapping(
          dartPropertyName: 'textColor',
          type: PropertyType.color,
        ),
      },
      customWrapper: 'await FakeLoadingOverlay.show(\n  context,',
    ),
    ComponentType.typewriterText: CodeTemplate(
      widgetName: 'TypewriterText',
      requiredImports: [_flutterImport, _baseImport],
      propertyMappings: {
        'text': PropertyMapping(
          dartPropertyName: 'text',
          type: PropertyType.string,
          isRequired: true,
        ),
        'characterDelay': PropertyMapping(
          dartPropertyName: 'characterDelay',
          type: PropertyType.duration,
          defaultValue: Duration(milliseconds: 50),
        ),
        'style': PropertyMapping(
          dartPropertyName: 'style',
          type: PropertyType.textStyle,
        ),
        'showCursor': PropertyMapping(
          dartPropertyName: 'showCursor',
          type: PropertyType.boolean,
          defaultValue: true,
        ),
        'cursorColor': PropertyMapping(
          dartPropertyName: 'cursorColor',
          type: PropertyType.color,
        ),
        'onComplete': PropertyMapping(
          dartPropertyName: 'onComplete',
          type: PropertyType.callback,
        ),
      },
    ),
    ComponentType.fakeProgressIndicator: CodeTemplate(
      widgetName: 'FakeProgressIndicator',
      requiredImports: [_flutterImport, _baseImport],
      propertyMappings: {
        'duration': PropertyMapping(
          dartPropertyName: 'duration',
          type: PropertyType.duration,
          defaultValue: Duration(milliseconds: 2000),
        ),
        'color': PropertyMapping(
          dartPropertyName: 'color',
          type: PropertyType.color,
        ),
        'backgroundColor': PropertyMapping(
          dartPropertyName: 'backgroundColor',
          type: PropertyType.color,
        ),
        'height': PropertyMapping(
          dartPropertyName: 'height',
          type: PropertyType.number,
          defaultValue: 4.0,
        ),
        'borderRadius': PropertyMapping(
          dartPropertyName: 'borderRadius',
          type: PropertyType.borderRadius,
        ),
        'curve': PropertyMapping(
          dartPropertyName: 'curve',
          type: PropertyType.curve,
          defaultValue: 'Curves.easeInOut',
        ),
        'autoStart': PropertyMapping(
          dartPropertyName: 'autoStart',
          type: PropertyType.boolean,
          defaultValue: true,
        ),
        'onProgressChanged': PropertyMapping(
          dartPropertyName: 'onProgressChanged',
          type: PropertyType.callback,
        ),
        'onComplete': PropertyMapping(
          dartPropertyName: 'onComplete',
          type: PropertyType.callback,
        ),
      },
    ),
  };

  /// Generate code using template system with caching
  static String generateCode(
    ComponentType componentType,
    Map<String, dynamic> properties, {
    bool includeImports = true,
    bool includeWrapper = false,
    String? customTitle,
  }) {
    // Generate cache key
    final cacheKey = OptimizedCodeGenerator.generateCacheKey(
      '${componentType.name}_${includeImports}_${includeWrapper}_$customTitle',
      properties,
    );

    // Try to get from cache first
    return OptimizedCodeGenerator.generateWithCache(cacheKey, () {
      return _generateCodeInternal(
        componentType,
        properties,
        includeImports: includeImports,
        includeWrapper: includeWrapper,
        customTitle: customTitle,
      );
    });
  }

  /// Internal code generation without caching
  static String _generateCodeInternal(
    ComponentType componentType,
    Map<String, dynamic> properties, {
    bool includeImports = true,
    bool includeWrapper = false,
    String? customTitle,
  }) {
    final template = _templates[componentType];
    if (template == null) {
      throw ArgumentError(
        'No template found for component type: $componentType',
      );
    }

    final buffer = StringBuffer();

    // Add imports
    if (includeImports) {
      for (final import in template.requiredImports) {
        buffer.writeln(import);
      }
      buffer.writeln();
    }

    // Add wrapper if requested
    if (includeWrapper) {
      buffer.writeln(
        'class ${customTitle ?? template.widgetName}Example extends StatelessWidget {',
      );
      buffer.writeln(
        '  const ${customTitle ?? template.widgetName}Example({super.key});',
      );
      buffer.writeln();
      buffer.writeln('  @override');
      buffer.writeln('  Widget build(BuildContext context) {');
      buffer.writeln('    return Scaffold(');
      buffer.writeln(
        '      appBar: AppBar(title: Text(\'${customTitle ?? template.widgetName} Example\')),',
      );
      buffer.writeln('      body: Center(');
      buffer.writeln('        child: ');
    }

    // Start widget with custom wrapper or default
    if (template.customWrapper != null) {
      buffer.writeln(template.customWrapper);
    } else {
      buffer.writeln('${template.widgetName}(');
    }

    // Add properties using template mappings
    _addPropertiesFromTemplate(buffer, template, properties);

    // Handle special cases for overlay
    if (componentType == ComponentType.fakeLoadingOverlay) {
      buffer.writeln('  future: () async {');
      buffer.writeln('    // Your async operation here');
      buffer.writeln('    await Future.delayed(Duration(seconds: 2));');
      buffer.writeln('    return "Operation completed";');
      buffer.writeln('  }(),');
    }

    // Close widget
    buffer.writeln(template.customWrapper != null ? ');' : ')');

    // Close wrapper if added
    if (includeWrapper) {
      buffer.writeln('      ),');
      buffer.writeln('    );');
      buffer.writeln('  }');
      buffer.writeln('}');
    }

    return buffer.toString();
  }

  /// Generate code for FakeLoader widget (legacy method for backward compatibility)
  static String generateFakeLoaderCode(Map<String, dynamic> properties) {
    return generateCode(ComponentType.fakeLoader, properties);
  }

  /// Generate code for FakeLoadingScreen widget (legacy method for backward compatibility)
  static String generateFakeLoadingScreenCode({
    List<String>? messages,
    Duration? duration,
    Color? backgroundColor,
    Color? textColor,
    Color? progressColor,
    bool? showProgress,
    VoidCallback? onComplete,
  }) {
    final properties = <String, dynamic>{};

    if (messages != null) properties['messages'] = messages;
    if (duration != null) properties['duration'] = duration;
    if (backgroundColor != null) {
      properties['backgroundColor'] = backgroundColor;
    }
    if (textColor != null) properties['textColor'] = textColor;
    if (progressColor != null) properties['progressColor'] = progressColor;
    if (showProgress != null) properties['showProgress'] = showProgress;
    if (onComplete != null) properties['onComplete'] = onComplete;

    return generateCode(ComponentType.fakeLoadingScreen, properties);
  }

  /// Generate code for TypewriterText widget (legacy method for backward compatibility)
  static String generateTypewriterTextCode(Map<String, dynamic> properties) {
    return generateCode(ComponentType.typewriterText, properties);
  }

  /// Generate code for TypewriterText widget with specific parameters
  static String generateTypewriterText({
    required String text,
    Duration? characterDelay,
    String? cursor,
    bool? showCursor,
    bool? blinkCursor,
    Duration? blinkInterval,
    bool? autoStart,
    TextAlign? textAlign,
    VoidCallback? onComplete,
    ValueChanged<String>? onCharacterTyped,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('TypewriterText(');
    buffer.writeln("  text: '$text',");

    if (characterDelay != null &&
        characterDelay != const Duration(milliseconds: 50)) {
      if (characterDelay.inMilliseconds % 1000 == 0) {
        buffer.writeln(
          '  characterDelay: Duration(seconds: ${characterDelay.inSeconds}),',
        );
      } else {
        buffer.writeln(
          '  characterDelay: Duration(milliseconds: ${characterDelay.inMilliseconds}),',
        );
      }
    }

    if (cursor != null && cursor != '|') {
      buffer.writeln("  cursor: '$cursor',");
    }

    if (showCursor != null && showCursor != true) {
      buffer.writeln('  showCursor: $showCursor,');
    }

    if (blinkCursor != null && blinkCursor != true) {
      buffer.writeln('  blinkCursor: $blinkCursor,');
    }

    if (blinkInterval != null &&
        blinkInterval != const Duration(milliseconds: 500)) {
      if (blinkInterval.inMilliseconds % 1000 == 0) {
        buffer.writeln(
          '  blinkInterval: Duration(seconds: ${blinkInterval.inSeconds}),',
        );
      } else {
        buffer.writeln(
          '  blinkInterval: Duration(milliseconds: ${blinkInterval.inMilliseconds}),',
        );
      }
    }

    if (autoStart != null && autoStart != true) {
      buffer.writeln('  autoStart: $autoStart,');
    }

    if (textAlign != null && textAlign != TextAlign.start) {
      buffer.writeln('  textAlign: TextAlign.${textAlign.name},');
    }

    if (onComplete != null) {
      buffer.writeln('  onComplete: () {');
      buffer.writeln('    // Called when typing completes');
      buffer.writeln('  },');
    }

    if (onCharacterTyped != null) {
      buffer.writeln('  onCharacterTyped: (text) {');
      buffer.writeln('    // Called for each character typed');
      buffer.writeln('    print("Current text: \$text");');
      buffer.writeln('  },');
    }

    buffer.writeln(')');

    return buffer.toString();
  }

  /// Generate code for FakeProgressIndicator widget (legacy method for backward compatibility)
  static String generateFakeProgressIndicatorCode(
    Map<String, dynamic> properties,
  ) {
    return generateCode(ComponentType.fakeProgressIndicator, properties);
  }

  /// Generate code for FakeLoadingOverlay usage (legacy method for backward compatibility)
  static String generateFakeLoadingOverlayCode({
    String? futureType,
    String? future,
    String? messages,
    String? backgroundColor,
    String? textColor,
    String? onComplete,
    String? onError,
    String? errorBuilder,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('FakeLoadingOverlay<${futureType ?? 'String'}>(');

    if (future != null) {
      buffer.writeln('  future: $future,');
    } else {
      buffer.writeln('  future: yourAsyncOperation(),');
    }

    if (messages != null) {
      buffer.writeln('  messages: $messages,');
    } else {
      buffer.writeln('  messages: [\'Loading...\', \'Please wait...\'],');
    }

    if (backgroundColor != null) {
      buffer.writeln('  backgroundColor: $backgroundColor,');
    }

    if (textColor != null) {
      buffer.writeln('  textColor: $textColor,');
    }

    if (onComplete != null) {
      buffer.writeln('  $onComplete,');
    }

    if (onError != null) {
      buffer.writeln('  $onError,');
    }

    if (errorBuilder != null) {
      buffer.writeln('  $errorBuilder,');
    }

    buffer.writeln('  child: YourContentWidget(),');
    buffer.writeln(')');

    return buffer.toString();
  }

  /// Add properties to buffer using template mappings
  static void _addPropertiesFromTemplate(
    StringBuffer buffer,
    CodeTemplate template,
    Map<String, dynamic> properties,
  ) {
    for (final entry in template.propertyMappings.entries) {
      final propertyKey = entry.key;
      final mapping = entry.value;
      final value = properties[propertyKey];

      // Skip if value is null and not required
      if (value == null && !mapping.isRequired) {
        continue;
      }

      // Skip if value equals default value
      if (value == mapping.defaultValue) {
        continue;
      }

      _addPropertyFromMapping(buffer, mapping, value);
    }
  }

  /// Add a single property using its mapping configuration
  static void _addPropertyFromMapping(
    StringBuffer buffer,
    PropertyMapping mapping,
    dynamic value, {
    String indent = '  ',
  }) {
    if (value == null) return;

    buffer.write('$indent${mapping.dartPropertyName}: ');

    switch (mapping.type) {
      case PropertyType.string:
        buffer.writeln("'$value',");
        break;
      case PropertyType.stringList:
        final list = value as List<String>;
        buffer.write('[');
        for (int i = 0; i < list.length; i++) {
          buffer.write("'${list[i]}'");
          if (i < list.length - 1) buffer.write(', ');
        }
        buffer.writeln('],');
        break;
      case PropertyType.duration:
        final duration = value as Duration;
        if (duration.inMilliseconds % 1000 == 0) {
          buffer.writeln('Duration(seconds: ${duration.inSeconds}),');
        } else {
          buffer.writeln('Duration(milliseconds: ${duration.inMilliseconds}),');
        }
        break;
      case PropertyType.color:
        _writeColorValue(buffer, value as Color);
        break;
      case PropertyType.textStyle:
        buffer.writeln('TextStyle(');
        buffer.writeln('$indent  fontSize: 16,');
        buffer.writeln('$indent  fontWeight: FontWeight.normal,');
        buffer.writeln('$indent),');
        break;
      case PropertyType.enumValue:
        buffer.writeln('${mapping.enumType}.$value,');
        break;
      case PropertyType.callback:
        buffer.writeln('() {');
        buffer.writeln('$indent  // Your callback code here');
        buffer.writeln('$indent},');
        break;
      case PropertyType.boolean:
        buffer.writeln('$value,');
        break;
      case PropertyType.number:
        buffer.writeln('$value,');
        break;
      case PropertyType.widget:
        buffer.writeln('$value,');
        break;
      case PropertyType.borderRadius:
        if (value is String) {
          buffer.writeln('$value,');
        } else {
          buffer.writeln('BorderRadius.circular(8.0),');
        }
        break;
      case PropertyType.curve:
        if (value is String) {
          buffer.writeln('$value,');
        } else {
          buffer.writeln('Curves.easeInOut,');
        }
        break;
    }
  }

  /// Write color value with proper formatting
  static void _writeColorValue(StringBuffer buffer, Color color) {
    if (color == Colors.red) {
      buffer.writeln('Colors.red,');
    } else if (color == Colors.blue) {
      buffer.writeln('Colors.blue,');
    } else if (color == Colors.green) {
      buffer.writeln('Colors.green,');
    } else if (color == Colors.orange) {
      buffer.writeln('Colors.orange,');
    } else if (color == Colors.purple) {
      buffer.writeln('Colors.purple,');
    } else if (color == Colors.teal) {
      buffer.writeln('Colors.teal,');
    } else if (color == Colors.black) {
      buffer.writeln('Colors.black,');
    } else if (color == Colors.white) {
      buffer.writeln('Colors.white,');
    } else {
      buffer.writeln(
        'Color(0x${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}),',
      );
    }
  }

  /// Format generated code with proper indentation
  static String formatCode(String code) {
    final lines = code.split('\n');
    final buffer = StringBuffer();
    int indentLevel = 0;

    for (String line in lines) {
      final trimmedLine = line.trim();

      if (trimmedLine.isEmpty) {
        buffer.writeln();
        continue;
      }

      // Decrease indent for closing brackets
      if (trimmedLine.startsWith('}') || trimmedLine.startsWith(')')) {
        indentLevel = (indentLevel - 1).clamp(0, 10);
      }

      // Add indentation
      buffer.write('  ' * indentLevel);
      buffer.writeln(trimmedLine);

      // Increase indent for opening brackets
      if (trimmedLine.endsWith('{') || trimmedLine.endsWith('(')) {
        indentLevel++;
      }
    }

    return buffer.toString();
  }

  /// Get required imports for a specific component type
  static List<String> getRequiredImports([ComponentType? componentType]) {
    if (componentType != null) {
      final template = _templates[componentType];
      return template?.requiredImports ?? [_flutterImport, _baseImport];
    }
    return [_flutterImport, _baseImport];
  }

  /// Get available property mappings for a component type
  static Map<String, PropertyMapping> getPropertyMappings(
    ComponentType componentType,
  ) {
    final template = _templates[componentType];
    return template?.propertyMappings ?? {};
  }

  /// Get default properties for a component type
  static Map<String, dynamic> getDefaultProperties(
    ComponentType componentType,
  ) {
    final mappings = getPropertyMappings(componentType);
    final defaults = <String, dynamic>{};

    for (final entry in mappings.entries) {
      if (entry.value.defaultValue != null) {
        defaults[entry.key] = entry.value.defaultValue;
      }
    }

    return defaults;
  }

  /// Validate properties against template mappings
  static List<String> validateProperties(
    ComponentType componentType,
    Map<String, dynamic> properties,
  ) {
    final mappings = getPropertyMappings(componentType);
    final errors = <String>[];

    // Check required properties
    for (final entry in mappings.entries) {
      if (entry.value.isRequired && !properties.containsKey(entry.key)) {
        errors.add('Required property "${entry.key}" is missing');
      }
    }

    return errors;
  }

  /// Generate a complete example with widget wrapper
  static String generateCompleteExample(
    ComponentType componentType,
    Map<String, dynamic> properties, {
    String? title,
  }) {
    return generateCode(
      componentType,
      properties,
      includeImports: true,
      includeWrapper: true,
      customTitle: title,
    );
  }

  /// Generate just the widget code without imports or wrapper
  static String generateWidgetOnly(
    ComponentType componentType,
    Map<String, dynamic> properties,
  ) {
    return generateCode(
      componentType,
      properties,
      includeImports: false,
      includeWrapper: false,
    );
  }

  /// Get all available component types
  static List<ComponentType> getAllComponentTypes() {
    return ComponentType.values;
  }

  /// Get component type from string name
  static ComponentType? getComponentTypeFromName(String name) {
    try {
      return ComponentType.values.firstWhere(
        (type) => type.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Generate code for using a message pack
  static String generateMessagePackCode(
    String packName,
    List<String> messages,
  ) {
    final buffer = StringBuffer();

    buffer.writeln('FakeLoader(');

    // Use predefined pack if available
    if (packName == 'Tech Startup') {
      buffer.writeln('  messages: FakeMessagePack.techStartup,');
    } else if (packName == 'Gaming') {
      buffer.writeln('  messages: FakeMessagePack.gaming,');
    } else if (packName == 'Casual') {
      buffer.writeln('  messages: FakeMessagePack.casual,');
    } else if (packName == 'Professional') {
      buffer.writeln('  messages: FakeMessagePack.professional,');
    } else {
      // Custom pack - show the messages array
      buffer.writeln('  messages: [');
      for (int i = 0; i < messages.length; i++) {
        buffer.write('    \'${messages[i]}\'');
        if (i < messages.length - 1) buffer.write(',');
        buffer.writeln();
      }
      buffer.writeln('  ],');
    }

    buffer.writeln('  messageDuration: Duration(seconds: 2),');
    buffer.writeln('  textStyle: TextStyle(fontSize: 16),');
    buffer.writeln(')');

    return buffer.toString();
  }

  /// Generate code for weighted message selection
  static String generateWeightedMessageCode(
    List<Map<String, dynamic>> weightedMessages,
  ) {
    final buffer = StringBuffer();

    buffer.writeln('FakeLoader(');
    buffer.writeln('  messages: [');

    for (int i = 0; i < weightedMessages.length; i++) {
      final message = weightedMessages[i];
      final text = message['text'] as String;
      final weight = message['weight'] as double;

      if (weight == 1.0) {
        buffer.write('    \'$text\'');
      } else {
        buffer.write('    FakeMessage.weighted(\'$text\', $weight)');
      }

      if (i < weightedMessages.length - 1) buffer.write(',');
      buffer.writeln();
    }

    buffer.writeln('  ],');
    buffer.writeln('  messageDuration: Duration(seconds: 2),');
    buffer.writeln(')');

    return buffer.toString();
  }

  /// Generate code for message effects
  static String generateMessageEffectCode(
    String effect,
    List<String> messages,
  ) {
    final buffer = StringBuffer();

    buffer.writeln('FakeLoader(');
    buffer.writeln('  messages: [');
    for (int i = 0; i < messages.length; i++) {
      buffer.write('    \'${messages[i]}\'');
      if (i < messages.length - 1) buffer.write(',');
      buffer.writeln();
    }
    buffer.writeln('  ],');
    buffer.writeln('  effect: MessageEffect.$effect,');
    buffer.writeln('  messageDuration: Duration(seconds: 2),');
    buffer.writeln(')');

    return buffer.toString();
  }
}

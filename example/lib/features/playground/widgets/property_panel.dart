import 'package:flutter/material.dart';
import '../../../core/widgets/property_control.dart';
import '../../../core/utils/code_generator.dart';
import '../../../core/data/playground_state.dart';
import '../../../core/data/sample_messages.dart';
import '../../../core/data/demo_constants.dart';
import '../../../core/services/performance_service.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/animations/hover_effects.dart';

/// Interactive panel for controlling component properties in real-time.
///
/// This widget provides a comprehensive interface for modifying component
/// properties with immediate visual feedback. It includes:
/// - Performance-optimized property controls with lazy loading
/// - Sound and haptic feedback for interactions
/// - Debounced updates to prevent excessive rebuilds
/// - Automatic property validation and constraints
/// - Hover effects and micro-interactions for enhanced UX
///
/// The panel automatically generates appropriate controls based on property
/// types and includes helpful descriptions and tooltips for each property.
///
/// Example usage:
/// ```dart
/// PropertyPanel(
///   state: playgroundState,
///   onStateChanged: (newState) {
///     setState(() {
///       playgroundState = newState;
///     });
///   },
/// )
/// ```
class PropertyPanel extends StatefulWidget {
  /// Current playground state containing all property values
  final PlaygroundState state;

  /// Callback invoked when any property value changes
  final ValueChanged<PlaygroundState> onStateChanged;

  const PropertyPanel({
    super.key,
    required this.state,
    required this.onStateChanged,
  });

  @override
  State<PropertyPanel> createState() => _PropertyPanelState();
}

class _PropertyPanelState extends State<PropertyPanel>
    with PerformanceOptimizedWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Properties',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                HoverEffects.elevatedCard(
                  onTap: () {
                    SoundService.instance.playButtonClick();
                    widget.onStateChanged(widget.state.resetToDefaults());
                  },
                  child: IconButton(
                    onPressed: () {
                      SoundService.instance.playButtonClick();
                      widget.onStateChanged(widget.state.resetToDefaults());
                    },
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Reset to defaults',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: OptimizedListView(
                children: _buildPropertyControls(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPropertyControls(BuildContext context) {
    final controls = <Widget>[];
    final mappings = CodeGenerator.getPropertyMappings(
      widget.state.componentType,
    );

    for (final entry in mappings.entries) {
      final propertyName = entry.key;
      final mapping = entry.value;
      final currentValue = widget.state.properties[propertyName];

      if (currentValue == null && !mapping.isRequired) continue;

      // Use lazy loading for property controls with enhanced placeholder
      final control = LazyLoadingWidget(
        cacheKey: 'property_${propertyName}_${widget.state.componentType.name}',
        builder: () => HoverEffects.elevatedCard(
          child: _buildPropertyControl(
            context,
            propertyName,
            mapping,
            currentValue,
          ),
        ),
        placeholder: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );

      controls.add(control);
      controls.add(const SizedBox(height: 16));
    }

    return controls;
  }

  Widget _buildPropertyControl(
    BuildContext context,
    String propertyName,
    PropertyMapping mapping,
    dynamic currentValue,
  ) {
    switch (mapping.type) {
      case PropertyType.stringList:
        return _buildMessageListControl(propertyName, currentValue);
      case PropertyType.duration:
        return _buildDurationControl(propertyName, currentValue);
      case PropertyType.boolean:
        return _buildBooleanControl(propertyName, currentValue);
      case PropertyType.color:
        return _buildColorControl(propertyName, currentValue);
      case PropertyType.string:
        return _buildStringControl(propertyName, currentValue);
      case PropertyType.number:
        return _buildNumberControl(propertyName, currentValue, mapping);
      case PropertyType.enumValue:
        return _buildEnumControl(propertyName, currentValue, mapping);
      default:
        return Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Unsupported property type: ${mapping.type}',
            style: TextStyle(color: Colors.red),
          ),
        );
    }
  }

  Widget _buildMessageListControl(
    String propertyName,
    List<String>? currentValue,
  ) {
    return PropertyControl<List<String>>(
      label: 'Messages',
      value: currentValue ?? SampleMessages.basicMessages,
      type: PropertyControlType.dropdown,
      description: 'Select a message pack or use custom messages',
      options: {
        'items': [
          SampleMessages.basicMessages,
          SampleMessages.funMessages,
          SampleMessages.techStartupMessages,
          SampleMessages.gamingMessages,
          SampleMessages.sciFiMessages,
          SampleMessages.cookingMessages,
        ],
        'itemLabels': [
          'Basic Messages',
          'Fun Messages',
          'Tech Startup',
          'Gaming',
          'Sci-Fi',
          'Cooking',
        ],
      },
      onChanged: (value) => _updateProperty(propertyName, value),
    );
  }

  Widget _buildDurationControl(String propertyName, Duration? currentValue) {
    final durationMs = currentValue?.inMilliseconds.toDouble() ?? 2000.0;

    return PropertyControl<double>(
      label: 'Duration',
      value: durationMs,
      type: PropertyControlType.slider,
      description: 'Animation duration in milliseconds',
      options: {
        'min': 500.0,
        'max': 10000.0,
        'divisions': 95,
        'showLabel': true,
      },
      onChanged: (value) =>
          _updateProperty(propertyName, Duration(milliseconds: value.round())),
    );
  }

  Widget _buildBooleanControl(String propertyName, bool? currentValue) {
    return PropertyControl<bool>(
      label: _formatPropertyName(propertyName),
      value: currentValue ?? false,
      type: PropertyControlType.toggle,
      description: _getPropertyDescription(propertyName),
      onChanged: (value) => _updateProperty(propertyName, value),
    );
  }

  Widget _buildColorControl(String propertyName, Color? currentValue) {
    return PropertyControl<Color>(
      label: _formatPropertyName(propertyName),
      value: currentValue ?? Colors.blue,
      type: PropertyControlType.colorPicker,
      description: _getPropertyDescription(propertyName),
      options: {'colors': DemoConstants.demoColors},
      onChanged: (value) => _updateProperty(propertyName, value),
    );
  }

  Widget _buildStringControl(String propertyName, String? currentValue) {
    return PropertyControl<String>(
      label: _formatPropertyName(propertyName),
      value: currentValue ?? '',
      type: PropertyControlType.textField,
      description: _getPropertyDescription(propertyName),
      onChanged: (value) => _updateProperty(propertyName, value),
    );
  }

  Widget _buildNumberControl(
    String propertyName,
    num? currentValue,
    PropertyMapping mapping,
  ) {
    final constraints = PlaygroundStateHelpers.getPropertyConstraints(
      propertyName,
      widget.state.componentType,
    );

    if (propertyName == 'height' || propertyName == 'strokeWidth') {
      return PropertyControl<double>(
        label: _formatPropertyName(propertyName),
        value: (currentValue ?? mapping.defaultValue ?? 4.0).toDouble(),
        type: PropertyControlType.slider,
        description: _getPropertyDescription(propertyName),
        options: {
          'min': constraints?['min']?.toDouble() ?? 1.0,
          'max': constraints?['max']?.toDouble() ?? 20.0,
          'divisions': 19,
          'showLabel': true,
        },
        onChanged: (value) => _updateProperty(propertyName, value),
      );
    } else {
      return PropertyControl<int>(
        label: _formatPropertyName(propertyName),
        value: (currentValue ?? mapping.defaultValue ?? 1).toInt(),
        type: PropertyControlType.numberField,
        description: _getPropertyDescription(propertyName),
        options: {
          'min': constraints?['min'] ?? 1,
          'max': constraints?['max'] ?? 100,
          'step': 1,
        },
        onChanged: (value) => _updateProperty(propertyName, value),
      );
    }
  }

  Widget _buildEnumControl(
    String propertyName,
    String? currentValue,
    PropertyMapping mapping,
  ) {
    List<String> enumValues;
    List<String> enumLabels;

    switch (mapping.enumType) {
      case 'MessageEffect':
        enumValues = ['fade', 'slide', 'scale', 'typewriter'];
        enumLabels = ['Fade', 'Slide', 'Scale', 'Typewriter'];
        break;
      case 'TextAlign':
        enumValues = ['left', 'center', 'right', 'justify', 'start', 'end'];
        enumLabels = ['Left', 'Center', 'Right', 'Justify', 'Start', 'End'];
        break;
      default:
        enumValues = [currentValue ?? 'default'];
        enumLabels = [currentValue ?? 'Default'];
    }

    return PropertyControl<String>(
      label: _formatPropertyName(propertyName),
      value: currentValue ?? enumValues.first,
      type: PropertyControlType.dropdown,
      description: _getPropertyDescription(propertyName),
      options: {'items': enumValues, 'itemLabels': enumLabels},
      onChanged: (value) => _updateProperty(propertyName, value),
    );
  }

  void _updateProperty(String propertyName, dynamic value) {
    // Play sound feedback for property changes
    SoundService.instance.playPropertyChange();

    // Debounce property updates to prevent excessive rebuilds
    debounceUpdate(() {
      final newState = widget.state.updateProperty(propertyName, value);
      widget.onStateChanged(newState);
    });
  }

  String _formatPropertyName(String propertyName) {
    // Convert camelCase to Title Case
    return propertyName
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }

  String? _getPropertyDescription(String propertyName) {
    switch (propertyName) {
      case 'messages':
        return 'List of messages to display during loading';
      case 'duration':
        return 'How long each message is displayed';
      case 'characterDelay':
        return 'Delay between each character in milliseconds';
      case 'randomOrder':
        return 'Display messages in random order';
      case 'loop':
        return 'Continuously loop through messages';
      case 'maxLoops':
        return 'Maximum number of loops (0 = infinite)';
      case 'effect':
        return 'Animation effect for message transitions';
      case 'backgroundColor':
        return 'Background color of the component';
      case 'textColor':
        return 'Color of the text';
      case 'progressColor':
        return 'Color of the progress indicator';
      case 'showProgress':
        return 'Show progress indicator';
      case 'showCursor':
        return 'Show blinking cursor';
      case 'cursorColor':
        return 'Color of the cursor';
      case 'text':
        return 'Text to display with typewriter effect';
      case 'color':
        return 'Primary color of the component';
      case 'height':
        return 'Height of the progress bar';
      case 'strokeWidth':
        return 'Width of the progress indicator stroke';
      case 'alignment':
        return 'Text alignment within the component';
      default:
        return null;
    }
  }
}

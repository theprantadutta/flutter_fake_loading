import 'package:flutter/material.dart';

/// Enum for different types of property controls
enum PropertyControlType {
  slider,
  toggle,
  dropdown,
  colorPicker,
  textField,
  segmentedButton,
  numberField,
  multiSelect,
  rangeSlider,
}

/// A widget for creating interactive property controls
class PropertyControl<T> extends StatelessWidget {
  /// Label for the control
  final String label;

  /// Current value
  final T value;

  /// Callback when value changes
  final ValueChanged<T> onChanged;

  /// Type of control to display
  final PropertyControlType type;

  /// Additional options for the control
  final Map<String, dynamic>? options;

  /// Optional description
  final String? description;

  const PropertyControl({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.type,
    this.options,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 8),
        _buildControl(context),
      ],
    );
  }

  Widget _buildControl(BuildContext context) {
    switch (type) {
      case PropertyControlType.slider:
        return _buildSlider(context);
      case PropertyControlType.toggle:
        return _buildToggle(context);
      case PropertyControlType.dropdown:
        return _buildDropdown(context);
      case PropertyControlType.colorPicker:
        return _buildColorPicker(context);
      case PropertyControlType.textField:
        return _buildTextField(context);
      case PropertyControlType.segmentedButton:
        return _buildSegmentedButton(context);
      case PropertyControlType.numberField:
        return _buildNumberField(context);
      case PropertyControlType.multiSelect:
        return _buildMultiSelect(context);
      case PropertyControlType.rangeSlider:
        return _buildRangeSlider(context);
    }
  }

  Widget _buildSlider(BuildContext context) {
    final min = options?['min'] as double? ?? 0.0;
    final max = options?['max'] as double? ?? 100.0;
    final divisions = options?['divisions'] as int?;
    final showLabel = options?['showLabel'] as bool? ?? true;

    return Column(
      children: [
        if (showLabel)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(min.toInt().toString()),
              Text((value as double).toStringAsFixed(1)),
              Text(max.toInt().toString()),
            ],
          ),
        Slider(
          value: value as double,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: (newValue) => onChanged(newValue as T),
        ),
      ],
    );
  }

  Widget _buildToggle(BuildContext context) {
    return SwitchListTile(
      title: Text(label),
      subtitle: description != null ? Text(description!) : null,
      value: value as bool,
      onChanged: (newValue) => onChanged(newValue as T),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDropdown(BuildContext context) {
    final items = options?['items'] as List<T>? ?? [];
    final itemLabels =
        options?['itemLabels'] as List<String>? ??
        items.map((e) => e.toString()).toList();

    return DropdownButtonFormField<T>(
      value: value,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final label = index < itemLabels.length
            ? itemLabels[index]
            : item.toString();

        return DropdownMenuItem<T>(value: item, child: Text(label));
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }

  Widget _buildColorPicker(BuildContext context) {
    final colors =
        options?['colors'] as List<Color>? ??
        [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.orange,
          Colors.purple,
          Colors.teal,
        ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((color) {
        final isSelected = value == color;
        return GestureDetector(
          onTap: () => onChanged(color as T),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onChanged: (newValue) {
        // Try to convert the string to the appropriate type
        if (T == int) {
          final intValue = int.tryParse(newValue);
          if (intValue != null) {
            onChanged(intValue as T);
          }
        } else if (T == double) {
          final doubleValue = double.tryParse(newValue);
          if (doubleValue != null) {
            onChanged(doubleValue as T);
          }
        } else {
          onChanged(newValue as T);
        }
      },
    );
  }

  Widget _buildSegmentedButton(BuildContext context) {
    final segments = options?['segments'] as List<ButtonSegment<T>>? ?? [];

    return SegmentedButton<T>(
      segments: segments,
      selected: {value},
      onSelectionChanged: (Set<T> selection) {
        if (selection.isNotEmpty) {
          onChanged(selection.first);
        }
      },
    );
  }

  Widget _buildNumberField(BuildContext context) {
    final min = options?['min'] as num?;
    final max = options?['max'] as num?;
    final step = options?['step'] as num? ?? 1;

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: value.toString(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (newValue) {
              if (T == int) {
                final intValue = int.tryParse(newValue);
                if (intValue != null) {
                  final clampedValue = min != null && max != null
                      ? intValue.clamp(min.toInt(), max.toInt())
                      : intValue;
                  onChanged(clampedValue as T);
                }
              } else if (T == double) {
                final doubleValue = double.tryParse(newValue);
                if (doubleValue != null) {
                  final minDouble = min?.toDouble();
                  final maxDouble = max?.toDouble();
                  final clampedValue = minDouble != null && maxDouble != null
                      ? doubleValue.clamp(minDouble, maxDouble)
                      : doubleValue;
                  onChanged(clampedValue as T);
                }
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            IconButton(
              onPressed: () => _adjustNumber(step),
              icon: const Icon(Icons.keyboard_arrow_up, size: 16),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              onPressed: () => _adjustNumber(-step),
              icon: const Icon(Icons.keyboard_arrow_down, size: 16),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMultiSelect(BuildContext context) {
    final items = options?['items'] as List<T>? ?? [];
    final itemLabels =
        options?['itemLabels'] as List<String>? ??
        items.map((e) => e.toString()).toList();
    final selectedItems = value as List<T>? ?? [];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final label = index < itemLabels.length
            ? itemLabels[index]
            : item.toString();
        final isSelected = selectedItems.contains(item);

        return FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            final newSelection = List<T>.from(selectedItems);
            if (selected) {
              newSelection.add(item);
            } else {
              newSelection.remove(item);
            }
            onChanged(newSelection as T);
          },
        );
      }).toList(),
    );
  }

  Widget _buildRangeSlider(BuildContext context) {
    final min = options?['min'] as double? ?? 0.0;
    final max = options?['max'] as double? ?? 100.0;
    final divisions = options?['divisions'] as int?;
    final rangeValue = value as RangeValues;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(min.toInt().toString()),
            Text(
              '${rangeValue.start.toStringAsFixed(1)} - ${rangeValue.end.toStringAsFixed(1)}',
            ),
            Text(max.toInt().toString()),
          ],
        ),
        RangeSlider(
          values: rangeValue,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: (newValue) => onChanged(newValue as T),
        ),
      ],
    );
  }

  void _adjustNumber(num step) {
    final min = options?['min'] as num?;
    final max = options?['max'] as num?;

    if (T == int) {
      final currentValue = value as int;
      final newValue = currentValue + step.toInt();
      final clampedValue = min != null && max != null
          ? newValue.clamp(min.toInt(), max.toInt())
          : newValue;
      onChanged(clampedValue as T);
    } else if (T == double) {
      final currentValue = value as double;
      final newValue = currentValue + step.toDouble();
      final minDouble = min?.toDouble();
      final maxDouble = max?.toDouble();
      final clampedValue = minDouble != null && maxDouble != null
          ? newValue.clamp(minDouble, maxDouble)
          : newValue;
      onChanged(clampedValue as T);
    }
  }
}

import 'package:flutter/material.dart';
import '../../../core/data/playground_state.dart';
import '../../../core/widgets/code_display.dart';
import 'preview_area.dart';

/// Widget for comparing different configurations side by side
class ConfigurationComparison extends StatefulWidget {
  final List<PlaygroundState> configurations;
  final VoidCallback? onClearAll;

  const ConfigurationComparison({
    super.key,
    required this.configurations,
    this.onClearAll,
  });

  @override
  State<ConfigurationComparison> createState() =>
      _ConfigurationComparisonState();
}

class _ConfigurationComparisonState extends State<ConfigurationComparison> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.configurations.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        _buildTabBar(context),
        const SizedBox(height: 16),
        Expanded(child: _buildComparisonContent(context)),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.compare_arrows,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No Configurations to Compare',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add configurations to compare their properties and code',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // This would typically navigate back or show help
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Configuration'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.compare_arrows,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          'Configuration Comparison',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        Text(
          '${widget.configurations.length} configurations',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 16),
        if (widget.onClearAll != null)
          TextButton.icon(
            onPressed: widget.onClearAll,
            icon: const Icon(Icons.clear_all, size: 16),
            label: const Text('Clear All'),
          ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildTabButton(context, 0, 'Side by Side', Icons.view_column),
          _buildTabButton(context, 1, 'Properties', Icons.list),
          _buildTabButton(context, 2, 'Code', Icons.code),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    int index,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedTab == index;

    return Expanded(
      child: Material(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => setState(() => _selectedTab = index),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonContent(BuildContext context) {
    switch (_selectedTab) {
      case 0:
        return _buildSideBySideView(context);
      case 1:
        return _buildPropertiesView(context);
      case 2:
        return _buildCodeView(context);
      default:
        return _buildSideBySideView(context);
    }
  }

  Widget _buildSideBySideView(BuildContext context) {
    return Row(
      children: widget.configurations.asMap().entries.map((entry) {
        final index = entry.key;
        final config = entry.value;

        return Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Configuration ${index + 1}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _removeConfiguration(index),
                      icon: Icon(
                        Icons.close,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  child: PreviewArea(state: config, onPreviewAction: () {}),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPropertiesView(BuildContext context) {
    return SingleChildScrollView(
      child: Table(
        border: TableBorder.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        children: [
          // Header row
          TableRow(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            children: [
              _buildTableCell(context, 'Property', isHeader: true),
              ...widget.configurations.asMap().entries.map(
                (entry) => _buildTableCell(
                  context,
                  'Config ${entry.key + 1}',
                  isHeader: true,
                ),
              ),
            ],
          ),
          // Property rows
          ..._buildPropertyRows(context),
        ],
      ),
    );
  }

  List<TableRow> _buildPropertyRows(BuildContext context) {
    final allProperties = <String>{};
    for (final config in widget.configurations) {
      allProperties.addAll(config.properties.keys);
    }

    return allProperties.map((property) {
      return TableRow(
        children: [
          _buildTableCell(context, _formatPropertyName(property)),
          ...widget.configurations.map((config) {
            final value = config.properties[property];
            return _buildTableCell(context, _formatPropertyValue(value));
          }),
        ],
      );
    }).toList();
  }

  Widget _buildTableCell(
    BuildContext context,
    String content, {
    bool isHeader = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        content,
        style: isHeader
            ? Theme.of(context).textTheme.titleSmall
            : Theme.of(context).textTheme.bodySmall,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCodeView(BuildContext context) {
    return ListView.builder(
      itemCount: widget.configurations.length,
      itemBuilder: (context, index) {
        final config = widget.configurations[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Configuration ${index + 1}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _removeConfiguration(index),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              CodeDisplay(
                code: config.generatedCode,
                language: 'dart',
                maxHeight: 300,
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeConfiguration(int index) {
    // This would typically call a callback to remove the configuration
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Configuration ${index + 1} removed'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatPropertyName(String propertyName) {
    return propertyName
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }

  String _formatPropertyValue(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return '"$value"';
    if (value is List) return '[${value.length} items]';
    if (value is Duration) return '${value.inMilliseconds}ms';
    if (value is Color) {
      return 'Color(0x${value.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()})';
    }
    return value.toString();
  }
}

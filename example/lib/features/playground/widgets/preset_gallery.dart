import 'package:flutter/material.dart';
import '../../../core/data/demo_configurations.dart';
import '../../../core/data/playground_state.dart';
import '../../../core/utils/code_generator.dart';

/// Gallery widget for browsing and selecting preset configurations
class PresetGallery extends StatefulWidget {
  final ComponentType componentType;
  final ValueChanged<PlaygroundState> onPresetSelected;

  const PresetGallery({
    super.key,
    required this.componentType,
    required this.onPresetSelected,
  });

  @override
  State<PresetGallery> createState() => _PresetGalleryState();
}

class _PresetGalleryState extends State<PresetGallery> {
  String? _selectedTag;
  List<String> _availableTags = [];
  List<DemoConfiguration> _filteredConfigs = [];

  @override
  void initState() {
    super.initState();
    _loadPresets();
  }

  @override
  void didUpdateWidget(PresetGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.componentType != oldWidget.componentType) {
      _loadPresets();
    }
  }

  void _loadPresets() {
    final componentName = _getComponentName(widget.componentType);
    final configs = DemoConfigurations.getConfigurationsForComponent(
      componentName,
    );

    setState(() {
      _filteredConfigs = configs;
      _availableTags = configs.expand((config) => config.tags).toSet().toList()
        ..sort();
      _selectedTag = null;
    });
  }

  void _filterByTag(String? tag) {
    final componentName = _getComponentName(widget.componentType);
    final allConfigs = DemoConfigurations.getConfigurationsForComponent(
      componentName,
    );

    setState(() {
      _selectedTag = tag;
      _filteredConfigs = tag == null
          ? allConfigs
          : allConfigs.where((config) => config.tags.contains(tag)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        _buildTagFilter(context),
        const SizedBox(height: 16),
        Expanded(child: _buildPresetGrid(context)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.collections_bookmark,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text('Preset Gallery', style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        Text(
          '${_filteredConfigs.length} presets',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTagFilter(BuildContext context) {
    if (_availableTags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Filter by tag:', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _selectedTag == null,
              onSelected: (_) => _filterByTag(null),
            ),
            ..._availableTags.map(
              (tag) => FilterChip(
                label: Text(tag),
                selected: _selectedTag == tag,
                onSelected: (_) => _filterByTag(tag),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetGrid(BuildContext context) {
    if (_filteredConfigs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No presets found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedTag != null
                  ? 'Try selecting a different tag or clear the filter'
                  : 'No presets available for this component',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredConfigs.length,
      itemBuilder: (context, index) {
        final config = _filteredConfigs[index];
        return _buildPresetCard(context, config);
      },
    );
  }

  Widget _buildPresetCard(BuildContext context, DemoConfiguration config) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _selectPreset(config),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      config.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.play_arrow,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  config.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (config.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  children: config.tags
                      .take(3)
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _selectPreset(DemoConfiguration config) {
    final newState = PlaygroundState(
      componentType: widget.componentType,
      properties: Map<String, dynamic>.from(config.properties),
      generatedCode: CodeGenerator.generateCode(
        widget.componentType,
        config.properties,
      ),
    );

    widget.onPresetSelected(newState);

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded preset: ${config.name}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getComponentName(ComponentType componentType) {
    switch (componentType) {
      case ComponentType.fakeLoader:
        return 'FakeLoader';
      case ComponentType.fakeLoadingScreen:
        return 'FakeLoadingScreen';
      case ComponentType.fakeLoadingOverlay:
        return 'FakeLoadingOverlay';
      case ComponentType.fakeProgressIndicator:
        return 'FakeProgressIndicator';
      case ComponentType.typewriterText:
        return 'TypewriterText';
    }
  }
}

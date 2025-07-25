import 'package:flutter/material.dart';
import '../../../core/data/playground_state.dart';
import '../../../core/data/demo_configurations.dart';
import '../../../core/utils/code_generator.dart';

/// Panel for saving, loading, and managing configurations
class ConfigurationPanel extends StatefulWidget {
  final PlaygroundState state;
  final ValueChanged<PlaygroundState> onStateChanged;

  const ConfigurationPanel({
    super.key,
    required this.state,
    required this.onStateChanged,
  });

  @override
  State<ConfigurationPanel> createState() => _ConfigurationPanelState();
}

class _ConfigurationPanelState extends State<ConfigurationPanel> {
  final List<DemoConfigurationState> _savedConfigurations = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPresetConfigurations();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadPresetConfigurations() {
    final componentName = _getComponentName(widget.state.componentType);
    final presets = DemoConfigurations.getConfigurationsForComponent(
      componentName,
    );

    setState(() {
      _savedConfigurations.clear();
      _savedConfigurations.addAll(
        presets.map(
          (preset) => DemoConfigurationState(
            name: preset.name,
            description: preset.description,
            properties: preset.properties,
            tags: preset.tags,
            lastUsed: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          Expanded(child: _buildConfigurationList(context)),
          const Divider(height: 1),
          _buildSaveSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.bookmark, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text('Configurations', style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          IconButton(
            onPressed: _loadPresetConfigurations,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh presets',
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationList(BuildContext context) {
    if (_savedConfigurations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No saved configurations',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Save your current settings to create reusable configurations',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _savedConfigurations.length,
      itemBuilder: (context, index) {
        final config = _savedConfigurations[index];
        return _buildConfigurationItem(context, config, index);
      },
    );
  }

  Widget _buildConfigurationItem(
    BuildContext context,
    DemoConfigurationState config,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(config.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(config.description),
            if (config.tags.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: config.tags
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _toggleFavorite(index),
              icon: Icon(
                config.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: config.isFavorite ? Colors.red : null,
              ),
              tooltip: config.isFavorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',
            ),
            IconButton(
              onPressed: () => _deleteConfiguration(index),
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete configuration',
            ),
          ],
        ),
        onTap: () => _loadConfiguration(config),
      ),
    );
  }

  Widget _buildSaveSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Save Current Configuration',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Configuration Name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveCurrentConfiguration,
              icon: const Icon(Icons.save),
              label: const Text('Save Configuration'),
            ),
          ),
        ],
      ),
    );
  }

  void _loadConfiguration(DemoConfigurationState config) {
    final newState = PlaygroundState(
      componentType: widget.state.componentType,
      properties: Map<String, dynamic>.from(config.properties),
      generatedCode: CodeGenerator.generateCode(
        widget.state.componentType,
        config.properties,
      ),
    );

    widget.onStateChanged(newState);

    // Update last used timestamp
    setState(() {
      final index = _savedConfigurations.indexOf(config);
      if (index != -1) {
        _savedConfigurations[index] = config.markAsUsed();
      }
    });

    _showSnackBar('Configuration "${config.name}" loaded');
  }

  void _saveCurrentConfiguration() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showSnackBar('Please enter a configuration name');
      return;
    }

    final newConfig = DemoConfigurationState(
      name: name,
      description: _descriptionController.text.trim(),
      properties: Map<String, dynamic>.from(widget.state.properties),
      lastUsed: DateTime.now(),
    );

    setState(() {
      _savedConfigurations.add(newConfig);
    });

    _nameController.clear();
    _descriptionController.clear();

    _showSnackBar('Configuration "$name" saved');
  }

  void _toggleFavorite(int index) {
    setState(() {
      _savedConfigurations[index] = _savedConfigurations[index]
          .toggleFavorite();
    });
  }

  void _deleteConfiguration(int index) {
    final config = _savedConfigurations[index];

    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Configuration'),
        content: Text('Are you sure you want to delete "${config.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        setState(() {
          _savedConfigurations.removeAt(index);
        });
        _showSnackBar('Configuration deleted');
      }
    });
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

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

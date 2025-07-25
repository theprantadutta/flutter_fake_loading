import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/demo_card.dart';
import '../../../../core/utils/code_generator.dart';

/// Widget that demonstrates all predefined message packs
class MessagePackDemo extends StatefulWidget {
  const MessagePackDemo({super.key});

  @override
  State<MessagePackDemo> createState() => _MessagePackDemoState();
}

class _MessagePackDemoState extends State<MessagePackDemo> {
  String? _selectedPack;
  final Map<String, FakeLoaderController> _controllers = {};
  final Map<String, List<CustomMessagePack>> _customPacks = {'My Packs': []};

  // Define all predefined message packs
  final Map<String, List<String>> _predefinedPacks = {
    'Tech Startup': FakeMessagePack.techStartup,
    'Gaming': FakeMessagePack.gaming,
    'Casual': FakeMessagePack.casual,
    'Professional': FakeMessagePack.professional,
  };

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each pack
    for (final packName in _predefinedPacks.keys) {
      _controllers[packName] = FakeLoaderController();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Introduction
          DemoCard(
            title: 'Message Pack Gallery',
            description:
                'Explore all predefined message packs and create your own custom collections.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Message packs are themed collections of loading messages that match specific app types or moods. '
                  'Each pack contains contextually appropriate messages to add personality to your loading screens.',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Tip: Click on any pack to see it in action, or use the comparison mode to see multiple packs side by side.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Pack Comparison Mode
          _buildPackComparison(),

          const SizedBox(height: 24),

          // Predefined Packs Gallery
          Text(
            'Predefined Message Packs',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),

          ...(_predefinedPacks.entries.map(
            (entry) => _buildPackCard(entry.key, entry.value),
          )),

          const SizedBox(height: 32),

          // Custom Pack Builder
          _buildCustomPackBuilder(),

          const SizedBox(height: 24),

          // Custom Packs Display
          if (_customPacks['My Packs']!.isNotEmpty) ...[
            Text(
              'My Custom Packs',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...(_customPacks['My Packs']!.map(
              (pack) => _buildCustomPackCard(pack),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildPackCard(String packName, List<String> messages) {
    final controller = _controllers[packName]!;

    return DemoCard(
      title: packName,
      description: '${messages.length} messages',
      showCode: true,
      codeSnippet: CodeGenerator.generateMessagePackCode(packName, messages),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pack Preview
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: FakeLoader(
              controller: controller,
              messages: messages,
              messageDuration: const Duration(seconds: 2),
              autoStart: false,
              textStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              spinner: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Controls
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: controller.isRunning
                    ? null
                    : () => controller.start(),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Preview'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: controller.isRunning
                    ? () => controller.stop()
                    : null,
                icon: const Icon(Icons.pause, size: 18),
                label: const Text('Stop'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => controller.reset(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Message List
          ExpansionTile(
            title: const Text('View All Messages'),
            children: [
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      title: Text(
                        messages[index],
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: messages[index]),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Message copied to clipboard'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackComparison() {
    return DemoCard(
      title: 'Pack Comparison',
      description: 'Compare multiple message packs side by side',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select packs to compare their messages and themes:'),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _predefinedPacks.keys.map((packName) {
              final isSelected = _selectedPack == packName;
              return FilterChip(
                label: Text(packName),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedPack = selected ? packName : null;
                  });
                },
              );
            }).toList(),
          ),

          if (_selectedPack != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedPack!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_predefinedPacks[_selectedPack]!.length} messages',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: _predefinedPacks[_selectedPack]!.take(5).map((
                      message,
                    ) {
                      return Chip(
                        label: Text(
                          message.length > 30
                              ? '${message.substring(0, 30)}...'
                              : message,
                          style: const TextStyle(fontSize: 12),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                  if (_predefinedPacks[_selectedPack]!.length > 5)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '... and ${_predefinedPacks[_selectedPack]!.length - 5} more',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomPackBuilder() {
    return DemoCard(
      title: 'Custom Message Pack Builder',
      description: 'Create your own themed message collections',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Build custom message packs tailored to your app\'s personality and theme.',
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () => _showCustomPackDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Create Custom Pack'),
          ),

          const SizedBox(height: 16),

          // Import/Export functionality
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => _showImportDialog(),
                icon: const Icon(Icons.file_upload),
                label: const Text('Import Pack'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _customPacks['My Packs']!.isEmpty
                    ? null
                    : () => _showExportDialog(),
                icon: const Icon(Icons.file_download),
                label: const Text('Export Packs'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomPackCard(CustomMessagePack pack) {
    return DemoCard(
      title: pack.name,
      description: pack.description ?? 'Custom message pack',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${pack.messages.length} messages'),
          const SizedBox(height: 8),

          // Sample messages
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: pack.messages.take(3).map((message) {
              return Chip(
                label: Text(
                  message.length > 25
                      ? '${message.substring(0, 25)}...'
                      : message,
                  style: const TextStyle(fontSize: 12),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _previewCustomPack(pack),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Preview'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _editCustomPack(pack),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _deleteCustomPack(pack),
                icon: const Icon(Icons.delete, size: 18),
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCustomPackDialog([CustomMessagePack? existingPack]) {
    final nameController = TextEditingController(
      text: existingPack?.name ?? '',
    );
    final descriptionController = TextEditingController(
      text: existingPack?.description ?? '',
    );
    final messagesController = TextEditingController(
      text: existingPack?.messages.join('\n') ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          existingPack == null ? 'Create Custom Pack' : 'Edit Custom Pack',
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Pack Name',
                  hintText: 'e.g., Space Theme',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Brief description of the theme',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messagesController,
                decoration: const InputDecoration(
                  labelText: 'Messages (one per line)',
                  hintText: 'Launching rockets...\nExploring galaxies...',
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final description = descriptionController.text.trim();
              final messagesText = messagesController.text.trim();

              if (name.isEmpty || messagesText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Name and messages are required'),
                  ),
                );
                return;
              }

              final messages = messagesText
                  .split('\n')
                  .map((m) => m.trim())
                  .where((m) => m.isNotEmpty)
                  .toList();

              if (messages.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('At least one message is required'),
                  ),
                );
                return;
              }

              final pack = CustomMessagePack(
                name: name,
                messages: messages,
                description: description.isEmpty ? null : description,
              );

              setState(() {
                if (existingPack != null) {
                  final index = _customPacks['My Packs']!.indexOf(existingPack);
                  _customPacks['My Packs']![index] = pack;
                } else {
                  _customPacks['My Packs']!.add(pack);
                }
              });

              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    existingPack == null
                        ? 'Custom pack created!'
                        : 'Custom pack updated!',
                  ),
                ),
              );
            },
            child: Text(existingPack == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog() {
    // Placeholder for import functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Message Pack'),
        content: const Text(
          'Import functionality would allow users to import message packs from JSON files or shared configurations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    // Placeholder for export functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Message Packs'),
        content: const Text(
          'Export functionality would allow users to save their custom message packs as JSON files for sharing or backup.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _previewCustomPack(CustomMessagePack pack) {
    // Show preview dialog with the custom pack
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Preview: ${pack.name}'),
        content: SizedBox(
          width: 300,
          height: 150,
          child: FakeLoader(
            messages: pack.messages,
            messageDuration: const Duration(seconds: 2),
            autoStart: true,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editCustomPack(CustomMessagePack pack) {
    _showCustomPackDialog(pack);
  }

  void _deleteCustomPack(CustomMessagePack pack) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Custom Pack'),
        content: Text('Are you sure you want to delete "${pack.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _customPacks['My Packs']!.remove(pack);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Custom pack deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

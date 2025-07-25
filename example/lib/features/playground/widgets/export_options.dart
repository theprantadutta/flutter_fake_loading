import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/data/playground_state.dart';
import '../../../core/utils/code_generator.dart';

/// Widget for exporting configurations and code
class ExportOptions extends StatefulWidget {
  final PlaygroundState state;

  const ExportOptions({super.key, required this.state});

  @override
  State<ExportOptions> createState() => _ExportOptionsState();
}

class _ExportOptionsState extends State<ExportOptions> {
  bool _includeImports = true;
  bool _includeWrapper = false;
  String _exportFormat = 'dart';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        _buildExportOptions(context),
        const SizedBox(height: 16),
        _buildExportButtons(context),
        const SizedBox(height: 16),
        _buildShareOptions(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.file_download, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text('Export Options', style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }

  Widget _buildExportOptions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Code Export Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Include imports'),
              subtitle: const Text(
                'Add import statements to the generated code',
              ),
              value: _includeImports,
              onChanged: (value) =>
                  setState(() => _includeImports = value ?? true),
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('Include widget wrapper'),
              subtitle: const Text(
                'Wrap code in a complete StatelessWidget class',
              ),
              value: _includeWrapper,
              onChanged: (value) =>
                  setState(() => _includeWrapper = value ?? false),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),
            Text(
              'Export Format',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'dart',
                  label: Text('Dart Code'),
                  icon: Icon(Icons.code),
                ),
                ButtonSegment(
                  value: 'json',
                  label: Text('JSON Config'),
                  icon: Icon(Icons.data_object),
                ),
              ],
              selected: {_exportFormat},
              onSelectionChanged: (Set<String> selection) {
                setState(() => _exportFormat = selection.first);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButtons(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy to Clipboard'),
                ),
                OutlinedButton.icon(
                  onPressed: _downloadFile,
                  icon: const Icon(Icons.download),
                  label: const Text('Download File'),
                ),
                OutlinedButton.icon(
                  onPressed: _saveAsGist,
                  icon: const Icon(Icons.link),
                  label: const Text('Save as Gist'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOptions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share Configuration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Share your configuration with others using these options:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _generateShareableLink,
                  icon: const Icon(Icons.share),
                  label: const Text('Generate Link'),
                ),
                OutlinedButton.icon(
                  onPressed: _exportAsQR,
                  icon: const Icon(Icons.qr_code),
                  label: const Text('QR Code'),
                ),
                OutlinedButton.icon(
                  onPressed: _shareToSocial,
                  icon: const Icon(Icons.social_distance),
                  label: const Text('Social Media'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard() async {
    final content = _generateExportContent();
    await Clipboard.setData(ClipboardData(text: content));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text('${_exportFormat.toUpperCase()} copied to clipboard'),
            ],
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _downloadFile() {
    final filename = _generateFilename();

    // In a real implementation, this would trigger a file download
    // For web, you'd use dart:html or a package like universal_html
    // For mobile, you'd use a package like path_provider

    _showSnackBar('Download started: $filename');
  }

  void _saveAsGist() {
    // In a real implementation, this would create a GitHub Gist
    _showSnackBar('Gist creation coming soon!');
  }

  void _generateShareableLink() {
    // In a real implementation, this would generate a shareable URL
    // with the configuration encoded in the parameters
    final encodedConfig = _encodeConfiguration();
    final shareableUrl = 'https://example.com/playground?config=$encodedConfig';

    Clipboard.setData(ClipboardData(text: shareableUrl));
    _showSnackBar('Shareable link copied to clipboard');
  }

  void _exportAsQR() {
    // In a real implementation, this would generate a QR code
    // containing the configuration data
    _showSnackBar('QR code generation coming soon!');
  }

  void _shareToSocial() {
    // In a real implementation, this would open social media sharing
    _showSnackBar('Social media sharing coming soon!');
  }

  String _generateExportContent() {
    switch (_exportFormat) {
      case 'dart':
        return CodeGenerator.generateCode(
          widget.state.componentType,
          widget.state.properties,
          includeImports: _includeImports,
          includeWrapper: _includeWrapper,
        );
      case 'json':
        return _generateJsonConfig();
      default:
        return widget.state.generatedCode;
    }
  }

  String _generateJsonConfig() {
    final config = {
      'componentType': widget.state.componentType.name,
      'properties': _serializeProperties(widget.state.properties),
      'timestamp': DateTime.now().toIso8601String(),
      'version': '1.0.0',
    };

    // In a real implementation, you'd use dart:convert
    return config.toString();
  }

  Map<String, dynamic> _serializeProperties(Map<String, dynamic> properties) {
    final serialized = <String, dynamic>{};

    for (final entry in properties.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is Duration) {
        serialized[key] = {
          'type': 'Duration',
          'milliseconds': value.inMilliseconds,
        };
      } else if (value is Color) {
        serialized[key] = {'type': 'Color', 'value': value.toARGB32()};
      } else if (value is List<String>) {
        serialized[key] = {'type': 'List<String>', 'value': value};
      } else {
        serialized[key] = value;
      }
    }

    return serialized;
  }

  String _generateFilename() {
    final componentName = widget.state.componentType.name;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = _exportFormat == 'dart' ? 'dart' : 'json';

    return '${componentName}_config_$timestamp.$extension';
  }

  String _encodeConfiguration() {
    // In a real implementation, this would encode the configuration
    // as a base64 string or similar for URL sharing
    return 'encoded_config_placeholder';
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

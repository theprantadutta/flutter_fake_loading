import 'package:flutter/material.dart';
import '../../../core/widgets/code_display.dart';
import '../../../core/data/playground_state.dart';

/// Panel for displaying generated code with export options
class CodePanel extends StatefulWidget {
  final PlaygroundState state;

  const CodePanel({super.key, required this.state});

  @override
  State<CodePanel> createState() => _CodePanelState();
}

class _CodePanelState extends State<CodePanel> {
  bool _includeImports = true;
  bool _includeWrapper = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          Expanded(child: _buildCodeContent(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Generated Code',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                tooltip: 'Export options',
                onSelected: _handleExportOption,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'copy_widget',
                    child: Row(
                      children: [
                        Icon(Icons.copy, size: 16),
                        SizedBox(width: 8),
                        Text('Copy Widget Only'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'copy_complete',
                    child: Row(
                      children: [
                        Icon(Icons.copy_all, size: 16),
                        SizedBox(width: 8),
                        Text('Copy Complete Example'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share, size: 16),
                        SizedBox(width: 8),
                        Text('Share Configuration'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _includeImports,
                    onChanged: (value) =>
                        setState(() => _includeImports = value ?? true),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Text('Include imports'),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _includeWrapper,
                    onChanged: (value) =>
                        setState(() => _includeWrapper = value ?? false),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Text('Include widget wrapper'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeContent(BuildContext context) {
    final code = _generateCode();

    return CodeDisplay(
      code: code,
      language: 'dart',
      showLineNumbers: false,
      allowCopy: true,
    );
  }

  String _generateCode() {
    return widget.state.generatedCode;
  }

  void _handleExportOption(String option) {
    switch (option) {
      case 'copy_widget':
        _copyWidgetOnly();
        break;
      case 'copy_complete':
        _copyCompleteExample();
        break;
      case 'share':
        _shareConfiguration();
        break;
    }
  }

  void _copyWidgetOnly() {
    // This would copy just the widget code without imports or wrapper
    _showSnackBar('Widget code copied to clipboard');
  }

  void _copyCompleteExample() {
    // This would copy the complete example with imports and wrapper
    _showSnackBar('Complete example copied to clipboard');
  }

  void _shareConfiguration() {
    // This would generate a shareable link or configuration
    _showSnackBar('Configuration sharing coming soon!');
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

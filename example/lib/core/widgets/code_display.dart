import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/vs2015.dart';

/// A widget for displaying syntax-highlighted code with copy functionality
class CodeDisplay extends StatelessWidget {
  /// The code to display
  final String code;

  /// Programming language for syntax highlighting
  final String language;

  /// Whether to show line numbers
  final bool showLineNumbers;

  /// Whether to allow copying the code
  final bool allowCopy;

  /// Maximum height for the code display
  final double? maxHeight;

  const CodeDisplay({
    super.key,
    required this.code,
    this.language = 'dart',
    this.showLineNumbers = false,
    this.allowCopy = true,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with language and copy button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.code,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  language.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (allowCopy)
                  IconButton(
                    onPressed: () => _copyToClipboard(context),
                    icon: const Icon(Icons.copy, size: 16),
                    tooltip: 'Copy to clipboard',
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),

          // Code content
          Container(
            width: double.infinity,
            constraints: maxHeight != null
                ? BoxConstraints(maxHeight: maxHeight!)
                : null,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: _buildCodeContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeContent(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return HighlightView(
      code,
      language: language,
      theme: isDark ? vs2015Theme : githubTheme,
      padding: EdgeInsets.zero,
      textStyle: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        height: 1.4,
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: code));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('Code copied to clipboard'),
            ],
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}

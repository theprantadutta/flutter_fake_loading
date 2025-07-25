import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accessibility_provider.dart';
import 'accessible_text.dart';

/// A consistent section header widget used throughout the app
class SectionHeader extends StatelessWidget {
  /// The title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Optional icon to display before the title
  final IconData? icon;

  /// Optional action widget (like a button)
  final Widget? action;

  /// Custom padding
  final EdgeInsets? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibility, child) {
        return Semantics(
          header: true,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                    semanticLabel: accessibility.screenReaderSupport
                        ? 'Section icon'
                        : null,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccessibleHeading(
                        title,
                        level: 2,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        AccessibleText(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (action != null) ...[const SizedBox(width: 16), action!],
              ],
            ),
          ),
        );
      },
    );
  }
}

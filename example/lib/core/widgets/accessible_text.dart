import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accessibility_provider.dart';

/// Accessible text widget that respects accessibility settings
class AccessibleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticLabel;
  final bool selectable;

  const AccessibleText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.semanticLabel,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibility, child) {
        final effectiveStyle = _getEffectiveTextStyle(context, accessibility);

        Widget textWidget = selectable
            ? SelectableText(
                text,
                style: effectiveStyle,
                textAlign: textAlign,
                maxLines: maxLines,
              )
            : Text(
                text,
                style: effectiveStyle,
                textAlign: textAlign,
                maxLines: maxLines,
                overflow: overflow,
              );

        // Add semantic label if provided and screen reader support is enabled
        if (semanticLabel != null && accessibility.screenReaderSupport) {
          textWidget = Semantics(
            label: semanticLabel,
            child: ExcludeSemantics(child: textWidget),
          );
        }

        return textWidget;
      },
    );
  }

  TextStyle _getEffectiveTextStyle(
    BuildContext context,
    AccessibilityProvider accessibility,
  ) {
    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium!;

    // Apply text scale factor
    final scaledStyle = baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14) * accessibility.textScaleFactor,
    );

    // High contrast adjustments
    if (accessibility.highContrast) {
      return scaledStyle.copyWith(
        color: _getHighContrastColor(context, scaledStyle.color),
        fontWeight: FontWeight.w600, // Make text bolder for better readability
      );
    }

    return scaledStyle;
  }

  Color _getHighContrastColor(BuildContext context, Color? originalColor) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    // Use high contrast colors
    if (brightness == Brightness.dark) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}

/// Accessible heading widget with proper semantic structure
class AccessibleHeading extends StatelessWidget {
  final String text;
  final int level; // 1-6, similar to HTML headings
  final TextStyle? style;
  final TextAlign? textAlign;
  final String? semanticLabel;

  const AccessibleHeading(
    this.text, {
    super.key,
    this.level = 1,
    this.style,
    this.textAlign,
    this.semanticLabel,
  }) : assert(
         level >= 1 && level <= 6,
         'Heading level must be between 1 and 6',
       );

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibility, child) {
        final effectiveStyle = _getHeadingStyle(context, accessibility);

        Widget heading = AccessibleText(
          text,
          style: effectiveStyle,
          textAlign: textAlign,
          semanticLabel: semanticLabel,
        );

        // Add heading semantics for screen readers
        if (accessibility.screenReaderSupport) {
          heading = Semantics(header: true, child: heading);
        }

        return heading;
      },
    );
  }

  TextStyle _getHeadingStyle(
    BuildContext context,
    AccessibilityProvider accessibility,
  ) {
    final theme = Theme.of(context);

    // Get base heading style based on level
    TextStyle baseStyle;
    switch (level) {
      case 1:
        baseStyle = theme.textTheme.headlineLarge!;
        break;
      case 2:
        baseStyle = theme.textTheme.headlineMedium!;
        break;
      case 3:
        baseStyle = theme.textTheme.headlineSmall!;
        break;
      case 4:
        baseStyle = theme.textTheme.titleLarge!;
        break;
      case 5:
        baseStyle = theme.textTheme.titleMedium!;
        break;
      case 6:
        baseStyle = theme.textTheme.titleSmall!;
        break;
      default:
        baseStyle = theme.textTheme.headlineMedium!;
    }

    // Apply custom style if provided
    if (style != null) {
      baseStyle = baseStyle.merge(style);
    }

    // Apply text scale factor
    final scaledStyle = baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 24) * accessibility.textScaleFactor,
    );

    // High contrast adjustments
    if (accessibility.highContrast) {
      return scaledStyle.copyWith(
        color: _getHighContrastColor(context, scaledStyle.color),
        fontWeight: FontWeight.bold,
      );
    }

    return scaledStyle;
  }

  Color _getHighContrastColor(BuildContext context, Color? originalColor) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    if (brightness == Brightness.dark) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}

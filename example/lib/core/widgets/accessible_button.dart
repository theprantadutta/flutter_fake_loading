import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accessibility_provider.dart';

/// Accessible button with proper focus management and semantic labels
class AccessibleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final String? tooltip;
  final ButtonStyle? style;
  final bool autofocus;
  final FocusNode? focusNode;

  const AccessibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.semanticLabel,
    this.tooltip,
    this.style,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<AccessibleButton> createState() => _AccessibleButtonState();
}

class _AccessibleButtonState extends State<AccessibleButton> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, accessibility, child) {
        final button = ElevatedButton(
          onPressed: widget.onPressed == null
              ? null
              : () {
                  accessibility.provideFeedback(HapticFeedbackType.lightImpact);
                  widget.onPressed!();
                },
          style: _getButtonStyle(context, accessibility),
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          child: widget.child,
        );

        Widget result = button;

        // Add semantic label if provided
        if (widget.semanticLabel != null && accessibility.screenReaderSupport) {
          result = Semantics(
            label: widget.semanticLabel,
            button: true,
            enabled: widget.onPressed != null,
            child: result,
          );
        }

        // Add tooltip if provided
        if (widget.tooltip != null) {
          result = Tooltip(message: widget.tooltip!, child: result);
        }

        return result;
      },
    );
  }

  ButtonStyle? _getButtonStyle(
    BuildContext context,
    AccessibilityProvider accessibility,
  ) {
    final baseStyle = widget.style ?? ElevatedButton.styleFrom();

    // Add focus indicator if enabled
    if (accessibility.showFocusIndicators && _isFocused) {
      return baseStyle.copyWith(
        side: WidgetStateProperty.all(
          BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        elevation: WidgetStateProperty.all(4),
      );
    }

    // High contrast adjustments
    if (accessibility.highContrast) {
      return baseStyle.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.12);
          }
          return Theme.of(context).colorScheme.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.38);
          }
          return Theme.of(context).colorScheme.onPrimary;
        }),
        side: WidgetStateProperty.all(
          BorderSide(color: Theme.of(context).colorScheme.outline, width: 1),
        ),
      );
    }

    return baseStyle;
  }
}

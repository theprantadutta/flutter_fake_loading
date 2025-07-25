import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accessibility_provider.dart';

/// Accessible card with proper focus management and semantic labels
class AccessibleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final String? semanticHint;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? elevation;
  final bool focusable;
  final FocusNode? focusNode;

  const AccessibleCard({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.semanticHint,
    this.margin,
    this.padding,
    this.color,
    this.elevation,
    this.focusable = true,
    this.focusNode,
  });

  @override
  State<AccessibleCard> createState() => _AccessibleCardState();
}

class _AccessibleCardState extends State<AccessibleCard> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isHovered = false;

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
        Widget card = Card(
          margin: widget.margin,
          color: _getCardColor(context, accessibility),
          elevation: _getCardElevation(accessibility),
          child: InkWell(
            onTap: widget.onTap == null
                ? null
                : () {
                    accessibility.provideFeedback(
                      HapticFeedbackType.lightImpact,
                    );
                    widget.onTap!();
                  },
            onHover: (hovering) {
              setState(() {
                _isHovered = hovering;
              });
            },
            focusNode: widget.focusable ? _focusNode : null,
            canRequestFocus: widget.focusable && widget.onTap != null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: widget.padding ?? const EdgeInsets.all(16),
              decoration: _getFocusDecoration(context, accessibility),
              child: widget.child,
            ),
          ),
        );

        // Add semantic information if provided
        if ((widget.semanticLabel != null || widget.semanticHint != null) &&
            accessibility.screenReaderSupport) {
          card = Semantics(
            label: widget.semanticLabel,
            hint: widget.semanticHint,
            button: widget.onTap != null,
            enabled: widget.onTap != null,
            focusable: widget.focusable,
            child: card,
          );
        }

        return card;
      },
    );
  }

  Color? _getCardColor(
    BuildContext context,
    AccessibilityProvider accessibility,
  ) {
    if (widget.color != null) return widget.color;

    // High contrast adjustments
    if (accessibility.highContrast) {
      return Theme.of(context).colorScheme.surface;
    }

    return null;
  }

  double? _getCardElevation(AccessibilityProvider accessibility) {
    if (widget.elevation != null) return widget.elevation;

    // Increase elevation when focused or hovered for better visibility
    if (_isFocused || _isHovered) {
      return accessibility.highContrast ? 8 : 4;
    }

    return accessibility.highContrast ? 2 : 1;
  }

  Decoration? _getFocusDecoration(
    BuildContext context,
    AccessibilityProvider accessibility,
  ) {
    if (!accessibility.showFocusIndicators || !_isFocused) {
      return null;
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
    );
  }
}

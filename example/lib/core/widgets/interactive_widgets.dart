import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Interactive button with enhanced hover effects, haptic feedback, and micro-interactions.
///
/// This button provides a rich interactive experience with:
/// - Smooth hover animations with scale and color transitions
/// - Haptic feedback for tactile response
/// - Accessibility support with proper focus indicators
/// - Customizable appearance and behavior
///
/// Example usage:
/// ```dart
/// InteractiveButton(
///   onPressed: () => print('Pressed!'),
///   child: Text('Click me'),
///   backgroundColor: Colors.blue,
///   enableHaptics: true,
/// )
/// ```
class InteractiveButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? pressedColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final bool enableHaptics;
  final bool enableHover;
  final Duration animationDuration;

  const InteractiveButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.hoverColor,
    this.pressedColor,
    this.borderRadius,
    this.padding,
    this.enableHaptics = true,
    this.enableHover = true,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<InteractiveButton> createState() => _InteractiveButtonState();
}

class _InteractiveButtonState extends State<InteractiveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _updateColorAnimation();
  }

  void _updateColorAnimation() {
    final theme = Theme.of(context);
    final baseColor = widget.backgroundColor ?? theme.colorScheme.primary;
    final hoverColor = widget.hoverColor ?? baseColor.withValues(alpha: 0.8);
    final pressedColor =
        widget.pressedColor ?? baseColor.withValues(alpha: 0.6);

    Color targetColor = baseColor;
    if (_isPressed) {
      targetColor = pressedColor;
    } else if (_isHovered && widget.enableHover) {
      targetColor = hoverColor;
    }

    _colorAnimation = ColorTween(
      begin: _colorAnimation?.value ?? baseColor,
      end: targetColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _updateColorAnimation();
    _controller.forward();

    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _updateColorAnimation();
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _updateColorAnimation();
    _controller.reverse();
  }

  void _handleHover(bool isHovered) {
    if (widget.enableHover) {
      setState(() {
        _isHovered = isHovered;
      });
      _updateColorAnimation();

      if (isHovered) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTapDown: widget.onPressed != null ? _handleTapDown : null,
        onTapUp: widget.onPressed != null ? _handleTapUp : null,
        onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: widget.padding ?? const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Interactive card with hover and press effects
class InteractiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool enableHover;
  final bool enablePress;
  final Duration animationDuration;

  const InteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
    this.enableHover = true,
    this.enablePress = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _handleHover(bool isHovered) {
    if (widget.enableHover) {
      setState(() {
        _isHovered = isHovered;
      });

      if (isHovered && !_isPressed) {
        _controller.forward();
      } else if (!isHovered && !_isPressed) {
        _controller.reverse();
      }
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePress) {
      setState(() {
        _isPressed = true;
      });
      _controller.reverse();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePress) {
      setState(() {
        _isPressed = false;
      });

      if (_isHovered) {
        _controller.forward();
      }
    }
  }

  void _handleTapCancel() {
    if (widget.enablePress) {
      setState(() {
        _isPressed = false;
      });

      if (_isHovered) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTapDown: widget.onTap != null ? _handleTapDown : null,
        onTapUp: widget.onTap != null ? _handleTapUp : null,
        onTapCancel: widget.onTap != null ? _handleTapCancel : null,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Card(
                margin: widget.margin,
                elevation: _elevationAnimation.value,
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.all(16),
                  child: widget.child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Animated icon button with rotation and color changes
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final IconData? alternateIcon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? hoverColor;
  final double size;
  final bool rotateOnPress;
  final Duration animationDuration;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    this.alternateIcon,
    this.onPressed,
    this.color,
    this.hoverColor,
    this.size = 24.0,
    this.rotateOnPress = false,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isHovered = false;
  bool _isAlternate = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _updateColorAnimation();
  }

  void _updateColorAnimation() {
    final theme = Theme.of(context);
    final baseColor = widget.color ?? theme.iconTheme.color ?? Colors.black;
    final hoverColor = widget.hoverColor ?? theme.colorScheme.primary;

    _colorAnimation = ColorTween(
      begin: _colorAnimation?.value ?? baseColor,
      end: _isHovered ? hoverColor : baseColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    _updateColorAnimation();

    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _handlePress() {
    if (widget.rotateOnPress) {
      _controller.forward().then((_) {
        if (mounted) {
          setState(() {
            _isAlternate = !_isAlternate;
          });
          _controller.reverse();
        }
      });
    }

    HapticFeedback.lightImpact();
    widget.onPressed?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onPressed != null ? _handlePress : null,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: widget.rotateOnPress
                  ? _rotationAnimation.value * 3.14159
                  : 0,
              child: Icon(
                _isAlternate && widget.alternateIcon != null
                    ? widget.alternateIcon!
                    : widget.icon,
                size: widget.size,
                color: _colorAnimation.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Floating action button with pulse animation
class PulsingFAB extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final bool enablePulse;
  final Duration pulseDuration;

  const PulsingFAB({
    super.key,
    this.onPressed,
    required this.child,
    this.backgroundColor,
    this.enablePulse = true,
    this.pulseDuration = const Duration(seconds: 2),
  });

  @override
  State<PulsingFAB> createState() => _PulsingFABState();
}

class _PulsingFABState extends State<PulsingFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.enablePulse) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: FloatingActionButton(
            onPressed: widget.onPressed,
            backgroundColor: widget.backgroundColor,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Ripple effect widget
class RippleEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final Duration duration;

  const RippleEffect({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
    });
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTap: widget.onTap,
      child: CustomPaint(
        painter: _RipplePainter(
          animation: _animation,
          tapPosition: _tapPosition,
          color: widget.rippleColor ?? Theme.of(context).colorScheme.primary,
        ),
        child: widget.child,
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final Animation<double> animation;
  final Offset? tapPosition;
  final Color color;

  _RipplePainter({
    required this.animation,
    this.tapPosition,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (tapPosition == null) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.3 * (1 - animation.value))
      ..style = PaintingStyle.fill;

    final radius = size.width * animation.value;
    canvas.drawCircle(tapPosition!, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

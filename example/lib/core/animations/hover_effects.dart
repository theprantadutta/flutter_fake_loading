import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enhanced hover effects for interactive elements in the showcase app.
///
/// This class provides sophisticated hover animations that enhance user
/// interaction feedback. All effects are optimized for performance and
/// include accessibility considerations.
///
/// Example usage:
/// ```dart
/// HoverEffects.elevatedCard(
///   child: MyCard(),
///   onTap: () => print('Tapped!'),
/// )
/// ```
class HoverEffects {
  HoverEffects._();

  /// Creates an elevated card effect with smooth shadow and scale transitions.
  ///
  /// Perfect for cards, buttons, and interactive containers that need
  /// subtle elevation feedback on hover.
  static Widget elevatedCard({
    required Widget child,
    VoidCallback? onTap,
    double elevation = 8.0,
    double scale = 1.02,
    Duration duration = const Duration(milliseconds: 200),
    bool enableHaptics = true,
  }) {
    return _ElevatedCardHover(
      elevation: elevation,
      scale: scale,
      duration: duration,
      enableHaptics: enableHaptics,
      onTap: onTap,
      child: child,
    );
  }

  /// Creates a glow effect that appears on hover.
  ///
  /// This effect adds a subtle glow around the element, perfect for
  /// highlighting important interactive elements.
  static Widget glow({
    required Widget child,
    VoidCallback? onTap,
    Color glowColor = Colors.blue,
    double glowRadius = 20.0,
    Duration duration = const Duration(milliseconds: 300),
    bool enableHaptics = true,
  }) {
    return _GlowHover(
      glowColor: glowColor,
      glowRadius: glowRadius,
      duration: duration,
      enableHaptics: enableHaptics,
      onTap: onTap,
      child: child,
    );
  }

  /// Creates a shimmer effect that sweeps across the element on hover.
  ///
  /// This effect creates a light sweep animation that suggests interactivity
  /// and adds visual polish to buttons and cards.
  static Widget shimmer({
    required Widget child,
    VoidCallback? onTap,
    Color shimmerColor = Colors.white,
    Duration duration = const Duration(milliseconds: 1500),
    bool enableHaptics = true,
  }) {
    return _ShimmerHover(
      shimmerColor: shimmerColor,
      duration: duration,
      enableHaptics: enableHaptics,
      onTap: onTap,
      child: child,
    );
  }

  /// Creates a ripple effect that emanates from the hover point.
  ///
  /// This effect creates expanding ripples from the cursor position,
  /// providing clear visual feedback for user interactions.
  static Widget ripple({
    required Widget child,
    VoidCallback? onTap,
    Color rippleColor = Colors.blue,
    Duration duration = const Duration(milliseconds: 600),
    bool enableHaptics = true,
  }) {
    return _RippleHover(
      rippleColor: rippleColor,
      duration: duration,
      enableHaptics: enableHaptics,
      onTap: onTap,
      child: child,
    );
  }

  /// Creates a tilt effect that follows the cursor movement.
  ///
  /// This effect creates a 3D-like tilt based on cursor position,
  /// adding depth and interactivity to flat elements.
  static Widget tilt({
    required Widget child,
    VoidCallback? onTap,
    double maxTilt = 0.1,
    Duration duration = const Duration(milliseconds: 200),
    bool enableHaptics = true,
  }) {
    return _TiltHover(
      maxTilt: maxTilt,
      duration: duration,
      enableHaptics: enableHaptics,
      onTap: onTap,
      child: child,
    );
  }
}

/// Elevated card hover effect implementation
class _ElevatedCardHover extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double elevation;
  final double scale;
  final Duration duration;
  final bool enableHaptics;

  const _ElevatedCardHover({
    required this.child,
    this.onTap,
    required this.elevation,
    required this.scale,
    required this.duration,
    required this.enableHaptics,
  });

  @override
  State<_ElevatedCardHover> createState() => _ElevatedCardHoverState();
}

class _ElevatedCardHoverState extends State<_ElevatedCardHover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: widget.elevation,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (_isHovered != isHovered) {
      setState(() {
        _isHovered = isHovered;
      });

      if (isHovered) {
        _controller.forward();
        if (widget.enableHaptics) {
          HapticFeedback.lightImpact();
        }
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Material(
                elevation: _elevationAnimation.value,
                borderRadius: BorderRadius.circular(12),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Glow hover effect implementation
class _GlowHover extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color glowColor;
  final double glowRadius;
  final Duration duration;
  final bool enableHaptics;

  const _GlowHover({
    required this.child,
    this.onTap,
    required this.glowColor,
    required this.glowRadius,
    required this.duration,
    required this.enableHaptics,
  });

  @override
  State<_GlowHover> createState() => _GlowHoverState();
}

class _GlowHoverState extends State<_GlowHover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (_isHovered != isHovered) {
      setState(() {
        _isHovered = isHovered;
      });

      if (isHovered) {
        _controller.forward();
        if (widget.enableHaptics) {
          HapticFeedback.lightImpact();
        }
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.glowColor.withValues(
                      alpha: 0.3 * _glowAnimation.value,
                    ),
                    blurRadius: widget.glowRadius * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
                ],
              ),
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}

/// Shimmer hover effect implementation
class _ShimmerHover extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color shimmerColor;
  final Duration duration;
  final bool enableHaptics;

  const _ShimmerHover({
    required this.child,
    this.onTap,
    required this.shimmerColor,
    required this.duration,
    required this.enableHaptics,
  });

  @override
  State<_ShimmerHover> createState() => _ShimmerHoverState();
}

class _ShimmerHoverState extends State<_ShimmerHover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (_isHovered != isHovered) {
      setState(() {
        _isHovered = isHovered;
      });

      if (isHovered) {
        _controller.forward();
        if (widget.enableHaptics) {
          HapticFeedback.lightImpact();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AnimatedBuilder(
            animation: _shimmerAnimation,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      widget.shimmerColor.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                    stops: [
                      (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                      _shimmerAnimation.value.clamp(0.0, 1.0),
                      (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcOver,
                child: widget.child,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Ripple hover effect implementation
class _RippleHover extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color rippleColor;
  final Duration duration;
  final bool enableHaptics;

  const _RippleHover({
    required this.child,
    this.onTap,
    required this.rippleColor,
    required this.duration,
    required this.enableHaptics,
  });

  @override
  State<_RippleHover> createState() => _RippleHoverState();
}

class _RippleHoverState extends State<_RippleHover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rippleAnimation;
  Offset? _rippleCenter;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(PointerEvent event) {
    setState(() {
      _rippleCenter = event.localPosition;
    });
    _controller.forward().then((_) {
      _controller.reset();
    });

    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _handleHover,
      child: GestureDetector(
        onTap: widget.onTap,
        child: CustomPaint(
          painter: _RipplePainter(
            center: _rippleCenter,
            animation: _rippleAnimation,
            color: widget.rippleColor,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Custom painter for ripple effect
class _RipplePainter extends CustomPainter {
  final Offset? center;
  final Animation<double> animation;
  final Color color;

  _RipplePainter({
    required this.center,
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (center == null || animation.value == 0) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.3 * (1 - animation.value))
      ..style = PaintingStyle.fill;

    final maxRadius = (size.width + size.height) * 0.5;
    final radius = maxRadius * animation.value;

    canvas.drawCircle(center!, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Tilt hover effect implementation
class _TiltHover extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double maxTilt;
  final Duration duration;
  final bool enableHaptics;

  const _TiltHover({
    required this.child,
    this.onTap,
    required this.maxTilt,
    required this.duration,
    required this.enableHaptics,
  });

  @override
  State<_TiltHover> createState() => _TiltHoverState();
}

class _TiltHoverState extends State<_TiltHover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tiltXAnimation;
  late Animation<double> _tiltYAnimation;
  Offset _mousePosition = Offset.zero;
  Size _widgetSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _tiltXAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _tiltYAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(PointerEvent event) {
    setState(() {
      _mousePosition = event.localPosition;
    });

    if (_widgetSize != Size.zero) {
      final centerX = _widgetSize.width / 2;
      final centerY = _widgetSize.height / 2;

      final tiltX = ((_mousePosition.dy - centerY) / centerY) * widget.maxTilt;
      final tiltY = ((_mousePosition.dx - centerX) / centerX) * widget.maxTilt;

      _tiltXAnimation = Tween<double>(
        begin: _tiltXAnimation.value,
        end: -tiltX,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _tiltYAnimation = Tween<double>(
        begin: _tiltYAnimation.value,
        end: tiltY,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _controller.forward().then((_) => _controller.reset());
    }

    if (widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
  }

  void _handleExit(PointerEvent event) {
    _tiltXAnimation = Tween<double>(
      begin: _tiltXAnimation.value,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _tiltYAnimation = Tween<double>(
      begin: _tiltYAnimation.value,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward().then((_) => _controller.reset());
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _handleHover,
      onExit: _handleExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            _widgetSize = Size(constraints.maxWidth, constraints.maxHeight);
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(_tiltXAnimation.value)
                    ..rotateY(_tiltYAnimation.value),
                  child: widget.child,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

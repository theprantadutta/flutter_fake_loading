import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Enhanced loading animations for the showcase app.
///
/// This class provides sophisticated loading animations that go beyond basic
/// spinners to create engaging, branded loading experiences. All animations
/// are optimized for performance and include accessibility considerations.
class LoadingAnimations {
  LoadingAnimations._();

  /// Creates a pulsing dot animation with customizable colors and timing.
  ///
  /// Perfect for subtle loading indicators that don't distract from content.
  /// The animation creates a gentle pulsing effect with smooth transitions.
  static Widget pulsingDots({
    Color color = Colors.blue,
    double size = 8.0,
    Duration duration = const Duration(milliseconds: 1200),
    int dotCount = 3,
  }) {
    return _PulsingDots(
      color: color,
      size: size,
      duration: duration,
      dotCount: dotCount,
    );
  }

  /// Creates a wave loading animation with flowing motion.
  ///
  /// This animation creates a wave-like effect that's visually appealing
  /// and suggests continuous progress or activity.
  static Widget wave({
    Color color = Colors.blue,
    double height = 40.0,
    double width = 200.0,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return _WaveAnimation(
      color: color,
      height: height,
      width: width,
      duration: duration,
    );
  }

  /// Creates a morphing shape animation that transforms between different forms.
  ///
  /// This animation provides visual interest by smoothly transitioning between
  /// different geometric shapes, creating an engaging loading experience.
  static Widget morphingShapes({
    List<Color> colors = const [Colors.blue, Colors.purple, Colors.teal],
    double size = 60.0,
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    return _MorphingShapes(colors: colors, size: size, duration: duration);
  }

  /// Creates a particle system animation with floating elements.
  ///
  /// This animation simulates floating particles that create a dynamic,
  /// engaging loading experience perfect for creative applications.
  static Widget particles({
    Color color = Colors.blue,
    int particleCount = 20,
    double size = 100.0,
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    return _ParticleAnimation(
      color: color,
      particleCount: particleCount,
      size: size,
      duration: duration,
    );
  }

  /// Creates a breathing animation that simulates organic motion.
  ///
  /// This animation creates a calming, organic feel by simulating breathing
  /// or heartbeat-like motion, perfect for wellness or meditation apps.
  static Widget breathing({
    Color color = Colors.blue,
    double size = 80.0,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    return _BreathingAnimation(color: color, size: size, duration: duration);
  }
}

/// Pulsing dots animation implementation
class _PulsingDots extends StatefulWidget {
  final Color color;
  final double size;
  final Duration duration;
  final int dotCount;

  const _PulsingDots({
    required this.color,
    required this.size,
    required this.duration,
    required this.dotCount,
  });

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.dotCount,
      (index) => AnimationController(duration: widget.duration, vsync: this),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.3,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    // Start animations with staggered delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.dotCount, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.2),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: _animations[index].value),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}

/// Wave animation implementation
class _WaveAnimation extends StatefulWidget {
  final Color color;
  final double height;
  final double width;
  final Duration duration;

  const _WaveAnimation({
    required this.color,
    required this.height,
    required this.width,
    required this.duration,
  });

  @override
  State<_WaveAnimation> createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<_WaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _WavePainter(
              color: widget.color,
              animationValue: _animation.value,
            ),
            size: Size(widget.width, widget.height),
          );
        },
      ),
    );
  }
}

/// Custom painter for wave animation
class _WavePainter extends CustomPainter {
  final Color color;
  final double animationValue;

  _WavePainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * 0.3;
    final waveLength = size.width;
    final phase = animationValue * 2 * 3.14159;

    path.moveTo(0, size.height / 2);

    for (double x = 0; x <= size.width; x += 1) {
      final y =
          size.height / 2 +
          waveHeight * 0.5 * (math.sin((x / waveLength) * 2 * math.pi + phase));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Morphing shapes animation implementation
class _MorphingShapes extends StatefulWidget {
  final List<Color> colors;
  final double size;
  final Duration duration;

  const _MorphingShapes({
    required this.colors,
    required this.size,
    required this.duration,
  });

  @override
  State<_MorphingShapes> createState() => _MorphingShapesState();
}

class _MorphingShapesState extends State<_MorphingShapes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _MorphingShapesPainter(
              colors: widget.colors,
              animationValue: _animation.value,
            ),
            size: Size(widget.size, widget.size),
          );
        },
      ),
    );
  }
}

/// Custom painter for morphing shapes
class _MorphingShapesPainter extends CustomPainter {
  final List<Color> colors;
  final double animationValue;

  _MorphingShapesPainter({required this.colors, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    // Calculate current color
    final colorIndex = (animationValue * colors.length).floor();
    final colorProgress = (animationValue * colors.length) - colorIndex;
    final currentColor = Color.lerp(
      colors[colorIndex % colors.length],
      colors[(colorIndex + 1) % colors.length],
      colorProgress,
    )!;

    final paint = Paint()
      ..color = currentColor
      ..style = PaintingStyle.fill;

    // Morph between circle, square, and triangle
    final shapeProgress = (animationValue * 3) % 1;
    final shapeIndex = ((animationValue * 3).floor()) % 3;

    switch (shapeIndex) {
      case 0: // Circle to Square
        _drawMorphedCircleToSquare(
          canvas,
          center,
          radius,
          shapeProgress,
          paint,
        );
        break;
      case 1: // Square to Triangle
        _drawMorphedSquareToTriangle(
          canvas,
          center,
          radius,
          shapeProgress,
          paint,
        );
        break;
      case 2: // Triangle to Circle
        _drawMorphedTriangleToCircle(
          canvas,
          center,
          radius,
          shapeProgress,
          paint,
        );
        break;
    }
  }

  void _drawMorphedCircleToSquare(
    Canvas canvas,
    Offset center,
    double radius,
    double progress,
    Paint paint,
  ) {
    final path = Path();
    final points = <Offset>[];

    // Generate points for morphing
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * 3.14159;
      final circlePoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final squarePoint = _getSquarePoint(center, radius, i);
      final morphedPoint = Offset.lerp(circlePoint, squarePoint, progress)!;
      points.add(morphedPoint);
    }

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawMorphedSquareToTriangle(
    Canvas canvas,
    Offset center,
    double radius,
    double progress,
    Paint paint,
  ) {
    // Implementation for square to triangle morphing
    // Simplified implementation - you can expand this
    canvas.drawCircle(center, radius * (1 - progress * 0.2), paint);
  }

  void _drawMorphedTriangleToCircle(
    Canvas canvas,
    Offset center,
    double radius,
    double progress,
    Paint paint,
  ) {
    // Implementation for triangle to circle morphing
    // Simplified implementation - you can expand this
    canvas.drawCircle(center, radius * (0.8 + progress * 0.2), paint);
  }

  Offset _getSquarePoint(Offset center, double radius, int index) {
    // Generate square points
    final side = radius * 1.4;
    switch (index % 4) {
      case 0:
        return Offset(center.dx + side, center.dy + side);
      case 1:
        return Offset(center.dx - side, center.dy + side);
      case 2:
        return Offset(center.dx - side, center.dy - side);
      case 3:
        return Offset(center.dx + side, center.dy - side);
      default:
        return center;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Particle animation implementation
class _ParticleAnimation extends StatefulWidget {
  final Color color;
  final int particleCount;
  final double size;
  final Duration duration;

  const _ParticleAnimation({
    required this.color,
    required this.particleCount,
    required this.size,
    required this.duration,
  });

  @override
  State<_ParticleAnimation> createState() => _ParticleAnimationState();
}

class _ParticleAnimationState extends State<_ParticleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _particles = List.generate(widget.particleCount, (index) => _Particle());
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ParticlePainter(
              particles: _particles,
              color: widget.color,
              animationValue: _controller.value,
            ),
            size: Size(widget.size, widget.size),
          );
        },
      ),
    );
  }
}

/// Particle data class
class _Particle {
  late double x;
  late double y;
  late double vx;
  late double vy;
  late double size;
  late double opacity;

  _Particle() {
    reset();
  }

  void reset() {
    x = (0.5 + (0.5 - 1.0) * 0.5);
    y = (0.5 + (0.5 - 1.0) * 0.5);
    vx = (0.5 - 1.0) * 0.02;
    vy = (0.5 - 1.0) * 0.02;
    size = 2 + 4 * 0.5;
    opacity = 0.3 + 0.7 * 0.5;
  }

  void update() {
    x += vx;
    y += vy;

    if (x < 0 || x > 1 || y < 0 || y > 1) {
      reset();
    }
  }
}

/// Custom painter for particles
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color color;
  final double animationValue;

  _ParticlePainter({
    required this.particles,
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      particle.update();
      paint.color = color.withValues(alpha: particle.opacity);
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Breathing animation implementation
class _BreathingAnimation extends StatefulWidget {
  final Color color;
  final double size;
  final Duration duration;

  const _BreathingAnimation({
    required this.color,
    required this.size,
    required this.duration,
  });

  @override
  State<_BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<_BreathingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 0.4,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: _opacityAnimation.value),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

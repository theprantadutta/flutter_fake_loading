import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom page transitions for smooth navigation throughout the showcase app.
///
/// This class provides various transition animations that enhance the user
/// experience by creating smooth, visually appealing navigation between screens.
/// All transitions are optimized for performance and accessibility.
///
/// Example usage:
/// ```dart
/// Navigator.of(context).push(
///   PageTransitions.slideFromRight(MyScreen()),
/// );
/// ```
class PageTransitions {
  // Private constructor to prevent instantiation
  PageTransitions._();

  /// Creates a slide transition from right to left with haptic feedback.
  ///
  /// This transition is ideal for forward navigation in hierarchical flows.
  /// The animation duration is 300ms with an easeInOut curve for smooth motion.
  ///
  /// Parameters:
  /// - [page]: The destination widget to navigate to
  /// - [enableHaptics]: Whether to provide haptic feedback (default: true)
  static PageRouteBuilder<T> slideFromRight<T>(
    Widget page, {
    bool enableHaptics = true,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        // Provide haptic feedback when transition starts
        if (enableHaptics && animation.status == AnimationStatus.forward) {
          HapticFeedback.lightImpact();
        }
        return page;
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        // Add subtle fade effect for enhanced visual appeal
        final fadeAnimation = Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(curvedAnimation);

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
    );
  }

  /// Slide transition from bottom to top
  static PageRouteBuilder<T> slideFromBottom<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  /// Fade transition
  static PageRouteBuilder<T> fade<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Scale transition
  static PageRouteBuilder<T> scale<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return ScaleTransition(scale: curvedAnimation, child: child);
      },
    );
  }

  /// Rotation transition
  static PageRouteBuilder<T> rotation<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return RotationTransition(turns: curvedAnimation, child: child);
      },
    );
  }

  /// Combined slide and fade transition
  static PageRouteBuilder<T> slideAndFade<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.3, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final slideTween = Tween(begin: begin, end: end);
        final fadeTween = Tween<double>(begin: 0.0, end: 1.0);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: slideTween.animate(curvedAnimation),
          child: FadeTransition(
            opacity: fadeTween.animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// Custom transition with multiple effects
  static PageRouteBuilder<T> custom<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    Offset? slideBegin,
    double? scaleBegin,
    double? fadeBegin,
    double? rotationBegin,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        Widget result = child;

        // Apply slide transition
        if (slideBegin != null) {
          final slideTween = Tween(begin: slideBegin, end: Offset.zero);
          result = SlideTransition(
            position: slideTween.animate(curvedAnimation),
            child: result,
          );
        }

        // Apply scale transition
        if (scaleBegin != null) {
          final scaleTween = Tween<double>(begin: scaleBegin, end: 1.0);
          result = ScaleTransition(
            scale: scaleTween.animate(curvedAnimation),
            child: result,
          );
        }

        // Apply fade transition
        if (fadeBegin != null) {
          final fadeTween = Tween<double>(begin: fadeBegin, end: 1.0);
          result = FadeTransition(
            opacity: fadeTween.animate(curvedAnimation),
            child: result,
          );
        }

        // Apply rotation transition
        if (rotationBegin != null) {
          final rotationTween = Tween<double>(begin: rotationBegin, end: 0.0);
          result = RotationTransition(
            turns: rotationTween.animate(curvedAnimation),
            child: result,
          );
        }

        return result;
      },
    );
  }
}

/// Animated page wrapper for consistent transitions
class AnimatedPage extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool slideIn;
  final bool fadeIn;
  final bool scaleIn;

  const AnimatedPage({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.slideIn = true,
    this.fadeIn = true,
    this.scaleIn = false,
  });

  @override
  State<AnimatedPage> createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(curvedAnimation);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curvedAnimation);

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(curvedAnimation);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = widget.child;

    if (widget.scaleIn) {
      result = ScaleTransition(scale: _scaleAnimation, child: result);
    }

    if (widget.slideIn) {
      result = SlideTransition(position: _slideAnimation, child: result);
    }

    if (widget.fadeIn) {
      result = FadeTransition(opacity: _fadeAnimation, child: result);
    }

    return result;
  }
}

/// Hero transition for shared elements
class HeroTransition extends StatelessWidget {
  final String tag;
  final Widget child;
  final VoidCallback? onTap;

  const HeroTransition({
    super.key,
    required this.tag,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}

/// Staggered animation for lists
class StaggeredList extends StatefulWidget {
  final List<Widget> children;
  final Duration delay;
  final Duration itemDelay;
  final Curve curve;

  const StaggeredList({
    super.key,
    required this.children,
    this.delay = Duration.zero,
    this.itemDelay = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
  });

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _slideAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0.0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: widget.curve));
    }).toList();

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: widget.curve));
    }).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(widget.delay);

    for (int i = 0; i < _controllers.length; i++) {
      if (mounted) {
        _controllers[i].forward();
        if (i < _controllers.length - 1) {
          await Future.delayed(widget.itemDelay);
        }
      }
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
    return Column(
      children: List.generate(widget.children.length, (index) {
        return SlideTransition(
          position: _slideAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: widget.children[index],
          ),
        );
      }),
    );
  }
}

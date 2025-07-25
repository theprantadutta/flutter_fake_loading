import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Sound service for providing audio feedback in the showcase app.
///
/// This service manages sound effects and audio feedback to enhance user
/// interaction. It includes volume control, accessibility considerations,
/// and performance optimizations.
///
/// Example usage:
/// ```dart
/// SoundService.instance.playButtonClick();
/// SoundService.instance.playSuccess();
/// ```
class SoundService {
  static final SoundService _instance = SoundService._internal();
  static SoundService get instance => _instance;

  SoundService._internal();

  bool _soundEnabled = true;
  double _volume = 0.7;

  /// Whether sound effects are enabled
  bool get soundEnabled => _soundEnabled;

  /// Current volume level (0.0 to 1.0)
  double get volume => _volume;

  /// Enable or disable sound effects
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  /// Set the volume level (0.0 to 1.0)
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
  }

  /// Play a button click sound with haptic feedback
  void playButtonClick() {
    if (!_soundEnabled) return;

    try {
      // Use system sound for button clicks
      SystemSound.play(SystemSoundType.click);

      // Add haptic feedback
      HapticFeedback.lightImpact();
    } catch (e) {
      // Silently handle any sound playback errors
      debugPrint('Sound playback error: $e');
    }
  }

  /// Play a success sound for completed actions
  void playSuccess() {
    if (!_soundEnabled) return;

    try {
      // Use system sound for success
      SystemSound.play(SystemSoundType.click);

      // Add haptic feedback
      HapticFeedback.mediumImpact();
    } catch (e) {
      // Silently handle any sound playback errors
      debugPrint('Sound playback error: $e');
    }
  }

  /// Play an error sound for failed actions
  void playError() {
    if (!_soundEnabled) return;

    try {
      // Use system sound for errors
      SystemSound.play(SystemSoundType.alert);

      // Add haptic feedback
      HapticFeedback.heavyImpact();
    } catch (e) {
      // Silently handle any sound playback errors
      debugPrint('Sound playback error: $e');
    }
  }

  /// Play a navigation sound for page transitions
  void playNavigation() {
    if (!_soundEnabled) return;

    try {
      // Use system sound for navigation
      SystemSound.play(SystemSoundType.click);

      // Add subtle haptic feedback
      HapticFeedback.selectionClick();
    } catch (e) {
      // Silently handle any sound playback errors
      debugPrint('Sound playback error: $e');
    }
  }

  /// Play a notification sound for alerts
  void playNotification() {
    if (!_soundEnabled) return;

    try {
      // Use system sound for notifications
      SystemSound.play(SystemSoundType.alert);

      // Add haptic feedback
      HapticFeedback.lightImpact();
    } catch (e) {
      // Silently handle any sound playback errors
      debugPrint('Sound playback error: $e');
    }
  }

  /// Play a hover sound for interactive elements
  void playHover() {
    if (!_soundEnabled) return;

    try {
      // Use subtle haptic feedback for hover
      HapticFeedback.selectionClick();
    } catch (e) {
      // Silently handle any haptic feedback errors
      debugPrint('Haptic feedback error: $e');
    }
  }

  /// Play a loading completion sound
  void playLoadingComplete() {
    if (!_soundEnabled) return;

    try {
      // Use system sound for completion
      SystemSound.play(SystemSoundType.click);

      // Add satisfying haptic feedback
      HapticFeedback.mediumImpact();
    } catch (e) {
      // Silently handle any sound playback errors
      debugPrint('Sound playback error: $e');
    }
  }

  /// Play a demo start sound
  void playDemoStart() {
    if (!_soundEnabled) return;

    try {
      // Use system sound for demo start
      SystemSound.play(SystemSoundType.click);

      // Add haptic feedback
      HapticFeedback.lightImpact();
    } catch (e) {
      // Silently handle any sound playback errors
      debugPrint('Sound playback error: $e');
    }
  }

  /// Play a property change sound for playground interactions
  void playPropertyChange() {
    if (!_soundEnabled) return;

    try {
      // Use subtle haptic feedback for property changes
      HapticFeedback.selectionClick();
    } catch (e) {
      // Silently handle any haptic feedback errors
      debugPrint('Haptic feedback error: $e');
    }
  }

  /// Play a code copy sound
  void playCodeCopy() {
    if (!_soundEnabled) return;

    try {
      // Use system sound for copy action
      SystemSound.play(SystemSoundType.click);

      // Add haptic feedback
      HapticFeedback.lightImpact();
    } catch (e) {
      // Silently handle any sound playback errors
      debugPrint('Sound playback error: $e');
    }
  }

  /// Play a generic interaction sound
  void playInteraction() {
    if (!_soundEnabled) return;

    try {
      HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }

  /// Play a toggle sound for switches and checkboxes
  void playToggle() {
    if (!_soundEnabled) return;

    try {
      SystemSound.play(SystemSoundType.click);
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Sound playback error: $e');
    }
  }

  /// Play a selection sound for dropdown and picker interactions
  void playSelection() {
    if (!_soundEnabled) return;

    try {
      HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }

  /// Initialize the sound service with accessibility settings
  void initialize({bool? soundEnabled, double? volume}) {
    if (soundEnabled != null) {
      _soundEnabled = soundEnabled;
    }
    if (volume != null) {
      _volume = volume.clamp(0.0, 1.0);
    }
  }

  /// Reset sound service to default settings
  void reset() {
    _soundEnabled = true;
    _volume = 0.7;
  }
}

/// Sound-enabled button wrapper that automatically plays sounds
class SoundButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final SoundType soundType;

  const SoundButton({
    super.key,
    required this.child,
    this.onPressed,
    this.soundType = SoundType.click,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed != null
          ? () {
              _playSound();
              onPressed!();
            }
          : null,
      child: child,
    );
  }

  void _playSound() {
    switch (soundType) {
      case SoundType.click:
        SoundService.instance.playButtonClick();
        break;
      case SoundType.success:
        SoundService.instance.playSuccess();
        break;
      case SoundType.error:
        SoundService.instance.playError();
        break;
      case SoundType.navigation:
        SoundService.instance.playNavigation();
        break;
      case SoundType.notification:
        SoundService.instance.playNotification();
        break;
      case SoundType.hover:
        SoundService.instance.playHover();
        break;
      case SoundType.toggle:
        SoundService.instance.playToggle();
        break;
      case SoundType.selection:
        SoundService.instance.playSelection();
        break;
      case SoundType.interaction:
        SoundService.instance.playInteraction();
        break;
    }
  }
}

/// Types of sounds available
enum SoundType {
  click,
  success,
  error,
  navigation,
  notification,
  hover,
  toggle,
  selection,
  interaction,
}

/// Sound-enabled card that plays hover sounds
class SoundCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enableHoverSound;

  const SoundCard({
    super.key,
    required this.child,
    this.onTap,
    this.enableHoverSound = true,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: enableHoverSound
          ? (_) => SoundService.instance.playHover()
          : null,
      child: GestureDetector(
        onTap: onTap != null
            ? () {
                SoundService.instance.playButtonClick();
                onTap!();
              }
            : null,
        child: child,
      ),
    );
  }
}

/// Mixin for widgets that need sound integration
mixin SoundMixin {
  void playSound(SoundType type) {
    switch (type) {
      case SoundType.click:
        SoundService.instance.playButtonClick();
        break;
      case SoundType.success:
        SoundService.instance.playSuccess();
        break;
      case SoundType.error:
        SoundService.instance.playError();
        break;
      case SoundType.navigation:
        SoundService.instance.playNavigation();
        break;
      case SoundType.notification:
        SoundService.instance.playNotification();
        break;
      case SoundType.hover:
        SoundService.instance.playHover();
        break;
      case SoundType.toggle:
        SoundService.instance.playToggle();
        break;
      case SoundType.selection:
        SoundService.instance.playSelection();
        break;
      case SoundType.interaction:
        SoundService.instance.playInteraction();
        break;
    }
  }

  void playHoverSound() {
    SoundService.instance.playHover();
  }

  void playLoadingCompleteSound() {
    SoundService.instance.playLoadingComplete();
  }

  void playDemoStartSound() {
    SoundService.instance.playDemoStart();
  }

  void playPropertyChangeSound() {
    SoundService.instance.playPropertyChange();
  }

  void playCodeCopySound() {
    SoundService.instance.playCodeCopy();
  }

  void playToggleSound() {
    SoundService.instance.playToggle();
  }

  void playSelectionSound() {
    SoundService.instance.playSelection();
  }

  void playInteractionSound() {
    SoundService.instance.playInteraction();
  }
}

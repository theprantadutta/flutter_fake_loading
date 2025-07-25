import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Provider for managing accessibility settings and state
class AccessibilityProvider extends ChangeNotifier {
  bool _reduceMotion = false;
  bool _highContrast = false;
  bool _largeText = false;
  bool _screenReaderSupport = true;
  bool _keyboardNavigation = true;
  bool _hapticFeedback = true;
  double _textScaleFactor = 1.0;
  bool _showFocusIndicators = true;

  // Getters
  bool get reduceMotion => _reduceMotion;
  bool get highContrast => _highContrast;
  bool get largeText => _largeText;
  bool get screenReaderSupport => _screenReaderSupport;
  bool get keyboardNavigation => _keyboardNavigation;
  bool get hapticFeedback => _hapticFeedback;
  double get textScaleFactor => _textScaleFactor;
  bool get showFocusIndicators => _showFocusIndicators;

  /// Set reduce motion preference
  void setReduceMotion(bool value) {
    _reduceMotion = value;
    notifyListeners();
  }

  /// Set high contrast preference
  void setHighContrast(bool value) {
    _highContrast = value;
    notifyListeners();
  }

  /// Set large text preference
  void setLargeText(bool value) {
    _largeText = value;
    _textScaleFactor = value ? 1.3 : 1.0;
    notifyListeners();
  }

  /// Set screen reader support
  void setScreenReaderSupport(bool value) {
    _screenReaderSupport = value;
    notifyListeners();
  }

  /// Set keyboard navigation support
  void setKeyboardNavigation(bool value) {
    _keyboardNavigation = value;
    notifyListeners();
  }

  /// Set haptic feedback preference
  void setHapticFeedback(bool value) {
    _hapticFeedback = value;
    notifyListeners();
  }

  /// Set text scale factor
  void setTextScaleFactor(double value) {
    _textScaleFactor = value;
    _largeText = value > 1.0;
    notifyListeners();
  }

  /// Set focus indicators visibility
  void setShowFocusIndicators(bool value) {
    _showFocusIndicators = value;
    notifyListeners();
  }

  /// Get animation duration based on reduce motion setting
  Duration getAnimationDuration(Duration defaultDuration) {
    return _reduceMotion ? Duration.zero : defaultDuration;
  }

  /// Provide haptic feedback if enabled
  void provideFeedback(HapticFeedbackType type) {
    if (_hapticFeedback) {
      switch (type) {
        case HapticFeedbackType.lightImpact:
          HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.mediumImpact:
          HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavyImpact:
          HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.selectionClick:
          HapticFeedback.selectionClick();
          break;
        case HapticFeedbackType.vibrate:
          HapticFeedback.vibrate();
          break;
      }
    }
  }

  /// Get semantic label for screen readers
  String getSemanticLabel(String baseLabel, {String? hint, String? value}) {
    if (!_screenReaderSupport) return baseLabel;

    final buffer = StringBuffer(baseLabel);
    if (value != null) {
      buffer.write(', $value');
    }
    if (hint != null) {
      buffer.write(', $hint');
    }
    return buffer.toString();
  }

  /// Check if accessibility features are enabled
  bool get hasAccessibilityFeatures {
    return _reduceMotion ||
        _highContrast ||
        _largeText ||
        _textScaleFactor != 1.0 ||
        !_screenReaderSupport ||
        !_keyboardNavigation;
  }

  /// Get accessibility summary for testing
  Map<String, bool> get accessibilitySummary {
    return {
      'Screen Reader Support': _screenReaderSupport,
      'Keyboard Navigation': _keyboardNavigation,
      'High Contrast Mode': _highContrast,
      'Reduced Motion': _reduceMotion,
      'Large Text': _largeText,
      'Haptic Feedback': _hapticFeedback,
      'Focus Indicators': _showFocusIndicators,
    };
  }

  /// Reset all settings to defaults
  void resetToDefaults() {
    _reduceMotion = false;
    _highContrast = false;
    _largeText = false;
    _screenReaderSupport = true;
    _keyboardNavigation = true;
    _hapticFeedback = true;
    _textScaleFactor = 1.0;
    _showFocusIndicators = true;
    notifyListeners();
  }
}

/// Haptic feedback types
enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}

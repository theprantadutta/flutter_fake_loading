import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service for managing focus and keyboard navigation
class FocusService {
  static final FocusService _instance = FocusService._internal();
  factory FocusService() => _instance;
  FocusService._internal();

  final List<FocusNode> _focusNodes = [];
  int _currentFocusIndex = -1;

  /// Register a focus node for keyboard navigation
  void registerFocusNode(FocusNode node) {
    if (!_focusNodes.contains(node)) {
      _focusNodes.add(node);
    }
  }

  /// Unregister a focus node
  void unregisterFocusNode(FocusNode node) {
    _focusNodes.remove(node);
    if (_currentFocusIndex >= _focusNodes.length) {
      _currentFocusIndex = _focusNodes.length - 1;
    }
  }

  /// Move focus to the next focusable element
  void focusNext() {
    if (_focusNodes.isEmpty) return;

    _currentFocusIndex = (_currentFocusIndex + 1) % _focusNodes.length;
    _focusNodes[_currentFocusIndex].requestFocus();
  }

  /// Move focus to the previous focusable element
  void focusPrevious() {
    if (_focusNodes.isEmpty) return;

    _currentFocusIndex =
        (_currentFocusIndex - 1 + _focusNodes.length) % _focusNodes.length;
    _focusNodes[_currentFocusIndex].requestFocus();
  }

  /// Focus the first element
  void focusFirst() {
    if (_focusNodes.isNotEmpty) {
      _currentFocusIndex = 0;
      _focusNodes[_currentFocusIndex].requestFocus();
    }
  }

  /// Focus the last element
  void focusLast() {
    if (_focusNodes.isNotEmpty) {
      _currentFocusIndex = _focusNodes.length - 1;
      _focusNodes[_currentFocusIndex].requestFocus();
    }
  }

  /// Clear all registered focus nodes
  void clear() {
    _focusNodes.clear();
    _currentFocusIndex = -1;
  }

  /// Get the currently focused node
  FocusNode? get currentFocusNode {
    if (_currentFocusIndex >= 0 && _currentFocusIndex < _focusNodes.length) {
      return _focusNodes[_currentFocusIndex];
    }
    return null;
  }

  /// Check if keyboard navigation is available
  bool get hasKeyboardNavigation => _focusNodes.isNotEmpty;
}

/// Widget that provides keyboard navigation shortcuts
class KeyboardNavigationWrapper extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const KeyboardNavigationWrapper({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<KeyboardNavigationWrapper> createState() =>
      _KeyboardNavigationWrapperState();
}

class _KeyboardNavigationWrapperState extends State<KeyboardNavigationWrapper> {
  final FocusService _focusService = FocusService();

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.tab): const NextFocusIntent(),
        LogicalKeySet(LogicalKeyboardKey.tab, LogicalKeyboardKey.shift):
            const PreviousFocusIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const NextFocusIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const PreviousFocusIntent(),
        LogicalKeySet(LogicalKeyboardKey.home): const FirstFocusIntent(),
        LogicalKeySet(LogicalKeyboardKey.end): const LastFocusIntent(),
      },
      child: Actions(
        actions: {
          NextFocusIntent: CallbackAction<NextFocusIntent>(
            onInvoke: (intent) {
              _focusService.focusNext();
              return null;
            },
          ),
          PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
            onInvoke: (intent) {
              _focusService.focusPrevious();
              return null;
            },
          ),
          FirstFocusIntent: CallbackAction<FirstFocusIntent>(
            onInvoke: (intent) {
              _focusService.focusFirst();
              return null;
            },
          ),
          LastFocusIntent: CallbackAction<LastFocusIntent>(
            onInvoke: (intent) {
              _focusService.focusLast();
              return null;
            },
          ),
        },
        child: widget.child,
      ),
    );
  }
}

/// Focus intents for keyboard navigation
class NextFocusIntent extends Intent {
  const NextFocusIntent();
}

class PreviousFocusIntent extends Intent {
  const PreviousFocusIntent();
}

class FirstFocusIntent extends Intent {
  const FirstFocusIntent();
}

class LastFocusIntent extends Intent {
  const LastFocusIntent();
}

/// Mixin for widgets that need to register focus nodes
mixin FocusRegistrationMixin<T extends StatefulWidget> on State<T> {
  final FocusService _focusService = FocusService();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusService.registerFocusNode(_focusNode);
  }

  @override
  void dispose() {
    _focusService.unregisterFocusNode(_focusNode);
    _focusNode.dispose();
    super.dispose();
  }

  FocusNode get focusNode => _focusNode;
}

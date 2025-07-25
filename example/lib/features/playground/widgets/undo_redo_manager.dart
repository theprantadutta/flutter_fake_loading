import 'package:flutter/material.dart';
import '../../../core/data/playground_state.dart';

/// Manager for undo/redo functionality in the playground
class UndoRedoManager extends ChangeNotifier {
  final List<PlaygroundState> _history = [];
  int _currentIndex = -1;
  static const int _maxHistorySize = 50;

  /// Current state
  PlaygroundState? get currentState =>
      _currentIndex >= 0 && _currentIndex < _history.length
      ? _history[_currentIndex]
      : null;

  /// Whether undo is available
  bool get canUndo => _currentIndex > 0;

  /// Whether redo is available
  bool get canRedo => _currentIndex < _history.length - 1;

  /// Number of states in history
  int get historyLength => _history.length;

  /// Current position in history (0-based)
  int get currentPosition => _currentIndex;

  /// Add a new state to history
  void addState(PlaygroundState state) {
    // Remove any states after current position (when adding after undo)
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }

    // Add new state
    _history.add(state);
    _currentIndex = _history.length - 1;

    // Limit history size
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
      _currentIndex--;
    }

    notifyListeners();
  }

  /// Undo to previous state
  PlaygroundState? undo() {
    if (!canUndo) return null;

    _currentIndex--;
    notifyListeners();
    return currentState;
  }

  /// Redo to next state
  PlaygroundState? redo() {
    if (!canRedo) return null;

    _currentIndex++;
    notifyListeners();
    return currentState;
  }

  /// Clear all history
  void clear() {
    _history.clear();
    _currentIndex = -1;
    notifyListeners();
  }

  /// Get a preview of the state at a specific index
  PlaygroundState? getStateAt(int index) {
    if (index >= 0 && index < _history.length) {
      return _history[index];
    }
    return null;
  }

  /// Jump to a specific state in history
  PlaygroundState? jumpToState(int index) {
    if (index >= 0 && index < _history.length) {
      _currentIndex = index;
      notifyListeners();
      return currentState;
    }
    return null;
  }

  /// Get a description of the change at a specific index
  String getChangeDescription(int index) {
    if (index <= 0 || index >= _history.length) {
      return 'Initial state';
    }

    final current = _history[index];
    final previous = _history[index - 1];

    // Compare properties to determine what changed
    final changedProperties = <String>[];

    for (final key in current.properties.keys) {
      if (current.properties[key] != previous.properties[key]) {
        changedProperties.add(_formatPropertyName(key));
      }
    }

    for (final key in previous.properties.keys) {
      if (!current.properties.containsKey(key)) {
        changedProperties.add('Removed ${_formatPropertyName(key)}');
      }
    }

    if (changedProperties.isEmpty) {
      return 'No changes';
    } else if (changedProperties.length == 1) {
      return 'Changed ${changedProperties.first}';
    } else {
      return 'Changed ${changedProperties.length} properties';
    }
  }

  String _formatPropertyName(String propertyName) {
    return propertyName
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }
}

/// Widget for displaying undo/redo controls
class UndoRedoControls extends StatelessWidget {
  final UndoRedoManager manager;
  final ValueChanged<PlaygroundState>? onStateChanged;

  const UndoRedoControls({
    super.key,
    required this.manager,
    this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: manager,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: manager.canUndo ? _undo : null,
              icon: const Icon(Icons.undo),
              tooltip: 'Undo',
            ),
            IconButton(
              onPressed: manager.canRedo ? _redo : null,
              icon: const Icon(Icons.redo),
              tooltip: 'Redo',
            ),
            const SizedBox(width: 8),
            PopupMenuButton<int>(
              icon: const Icon(Icons.history),
              tooltip: 'History',
              enabled: manager.historyLength > 0,
              onSelected: _jumpToState,
              itemBuilder: (context) => _buildHistoryItems(context),
            ),
          ],
        );
      },
    );
  }

  List<PopupMenuEntry<int>> _buildHistoryItems(BuildContext context) {
    final items = <PopupMenuEntry<int>>[];

    for (int i = manager.historyLength - 1; i >= 0; i--) {
      final isCurrent = i == manager.currentPosition;
      final description = manager.getChangeDescription(i);

      items.add(
        PopupMenuItem<int>(
          value: i,
          child: Row(
            children: [
              Icon(
                isCurrent
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 16,
                color: isCurrent
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${i + 1}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: isCurrent
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isNotEmpty) {
      items.add(const PopupMenuDivider());
      items.add(
        PopupMenuItem<int>(
          value: -1,
          child: Row(
            children: [
              Icon(
                Icons.clear_all,
                size: 16,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                'Clear History',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
        ),
      );
    }

    return items;
  }

  void _undo() {
    final state = manager.undo();
    if (state != null) {
      onStateChanged?.call(state);
    }
  }

  void _redo() {
    final state = manager.redo();
    if (state != null) {
      onStateChanged?.call(state);
    }
  }

  void _jumpToState(int index) {
    if (index == -1) {
      manager.clear();
      return;
    }

    final state = manager.jumpToState(index);
    if (state != null) {
      onStateChanged?.call(state);
    }
  }
}

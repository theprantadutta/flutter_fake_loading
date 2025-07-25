import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Service for managing memory usage and cleanup
class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final Set<Disposable> _disposables = {};
  final Map<String, Timer> _cleanupTimers = {};
  Timer? _periodicCleanupTimer;

  /// Initialize the memory manager
  void initialize() {
    // Start periodic cleanup every 5 minutes
    _periodicCleanupTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => performCleanup(),
    );
  }

  /// Register a disposable resource
  void register(Disposable disposable) {
    _disposables.add(disposable);
  }

  /// Unregister a disposable resource
  void unregister(Disposable disposable) {
    _disposables.remove(disposable);
  }

  /// Schedule cleanup for a specific resource
  void scheduleCleanup(String key, Duration delay, VoidCallback cleanup) {
    _cleanupTimers[key]?.cancel();
    _cleanupTimers[key] = Timer(delay, () {
      cleanup();
      _cleanupTimers.remove(key);
    });
  }

  /// Cancel scheduled cleanup
  void cancelCleanup(String key) {
    _cleanupTimers[key]?.cancel();
    _cleanupTimers.remove(key);
  }

  /// Perform immediate cleanup of all registered resources
  void performCleanup() {
    // Clean up disposables
    final disposablesToRemove = <Disposable>[];
    for (final disposable in _disposables) {
      try {
        if (disposable.shouldDispose()) {
          disposable.dispose();
          disposablesToRemove.add(disposable);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error disposing resource: $e');
        }
        disposablesToRemove.add(disposable);
      }
    }

    // Remove disposed resources
    for (final disposable in disposablesToRemove) {
      _disposables.remove(disposable);
    }

    // Force garbage collection in debug mode
    if (kDebugMode) {
      // Note: This is for debugging only, not recommended in production
      print(
        'Memory cleanup completed. Active disposables: ${_disposables.length}',
      );
    }
  }

  /// Get memory usage statistics
  Map<String, dynamic> getMemoryStats() {
    return {
      'activeDisposables': _disposables.length,
      'scheduledCleanups': _cleanupTimers.length,
      'periodicCleanupActive': _periodicCleanupTimer?.isActive ?? false,
    };
  }

  /// Dispose of the memory manager
  void dispose() {
    _periodicCleanupTimer?.cancel();

    // Cancel all scheduled cleanups
    for (final timer in _cleanupTimers.values) {
      timer.cancel();
    }
    _cleanupTimers.clear();

    // Dispose all registered resources
    for (final disposable in _disposables) {
      try {
        disposable.dispose();
      } catch (e) {
        if (kDebugMode) {
          print('Error disposing resource during shutdown: $e');
        }
      }
    }
    _disposables.clear();
  }
}

/// Interface for disposable resources
abstract class Disposable {
  /// Whether this resource should be disposed
  bool shouldDispose();

  /// Dispose of this resource
  void dispose();
}

/// Mixin for widgets that need memory management
mixin MemoryManagedWidget<T extends StatefulWidget> on State<T>
    implements Disposable {
  final MemoryManager _memoryManager = MemoryManager();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _memoryManager.register(this);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _memoryManager.unregister(this);
    super.dispose();
  }

  @override
  bool shouldDispose() => _isDisposed;

  /// Schedule cleanup for this widget
  void scheduleCleanup(Duration delay, VoidCallback cleanup) {
    final key = '${T.toString()}_$hashCode';
    _memoryManager.scheduleCleanup(key, delay, cleanup);
  }
}

/// Controller cache for managing animation controllers
class ControllerCache {
  static final ControllerCache _instance = ControllerCache._internal();
  factory ControllerCache() => _instance;
  ControllerCache._internal();

  final Map<String, AnimationController> _controllers = {};
  final Map<String, Timer> _cleanupTimers = {};

  /// Get or create an animation controller
  AnimationController getController(
    String key,
    TickerProvider vsync, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    // Cancel cleanup timer if it exists
    _cleanupTimers[key]?.cancel();
    _cleanupTimers.remove(key);

    // Return existing controller or create new one
    return _controllers[key] ??= AnimationController(
      duration: duration,
      vsync: vsync,
    );
  }

  /// Release a controller (schedule for cleanup)
  void releaseController(
    String key, {
    Duration delay = const Duration(seconds: 30),
  }) {
    _cleanupTimers[key] = Timer(delay, () {
      final controller = _controllers.remove(key);
      controller?.dispose();
      _cleanupTimers.remove(key);
    });
  }

  /// Immediately dispose a controller
  void disposeController(String key) {
    _cleanupTimers[key]?.cancel();
    _cleanupTimers.remove(key);

    final controller = _controllers.remove(key);
    controller?.dispose();
  }

  /// Clear all controllers
  void clearAll() {
    for (final timer in _cleanupTimers.values) {
      timer.cancel();
    }
    _cleanupTimers.clear();

    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  /// Get cache statistics
  Map<String, int> getStats() {
    return {
      'activeControllers': _controllers.length,
      'scheduledCleanups': _cleanupTimers.length,
    };
  }
}

/// Resource pool for reusing expensive objects
class ResourcePool<T> {
  final T Function() _factory;
  final void Function(T)? _reset;
  final List<T> _available = [];
  final Set<T> _inUse = {};
  final int _maxSize;

  ResourcePool({
    required T Function() factory,
    void Function(T)? reset,
    int maxSize = 10,
  }) : _factory = factory,
       _reset = reset,
       _maxSize = maxSize;

  /// Acquire a resource from the pool
  T acquire() {
    T resource;

    if (_available.isNotEmpty) {
      resource = _available.removeLast();
      _reset?.call(resource);
    } else {
      resource = _factory();
    }

    _inUse.add(resource);
    return resource;
  }

  /// Release a resource back to the pool
  void release(T resource) {
    if (_inUse.remove(resource)) {
      if (_available.length < _maxSize) {
        _available.add(resource);
      } else {
        // Pool is full, dispose if possible
        if (resource is Disposable) {
          resource.dispose();
        }
      }
    }
  }

  /// Clear the entire pool
  void clear() {
    for (final resource in _available) {
      if (resource is Disposable) {
        resource.dispose();
      }
    }
    _available.clear();

    for (final resource in _inUse) {
      if (resource is Disposable) {
        resource.dispose();
      }
    }
    _inUse.clear();
  }

  /// Get pool statistics
  Map<String, int> getStats() {
    return {
      'available': _available.length,
      'inUse': _inUse.length,
      'total': _available.length + _inUse.length,
    };
  }
}

/// Automatic resource cleanup widget
class AutoCleanupWidget extends StatefulWidget {
  final Widget child;
  final Duration cleanupDelay;
  final VoidCallback? onCleanup;

  const AutoCleanupWidget({
    super.key,
    required this.child,
    this.cleanupDelay = const Duration(minutes: 5),
    this.onCleanup,
  });

  @override
  State<AutoCleanupWidget> createState() => _AutoCleanupWidgetState();
}

class _AutoCleanupWidgetState extends State<AutoCleanupWidget>
    with MemoryManagedWidget {
  @override
  void initState() {
    super.initState();

    // Schedule automatic cleanup
    scheduleCleanup(widget.cleanupDelay, () {
      widget.onCleanup?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

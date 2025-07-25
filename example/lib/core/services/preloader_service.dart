import 'dart:async';
import 'package:flutter/material.dart';
import 'performance_service.dart';

/// Service for preloading heavy components and resources
class PreloaderService {
  static final PreloaderService _instance = PreloaderService._internal();
  factory PreloaderService() => _instance;
  PreloaderService._internal();

  final PerformanceService _performanceService = PerformanceService();
  final Map<String, Completer<Widget>> _preloadingComponents = {};
  final Set<String> _preloadQueue = {};
  bool _isPreloading = false;

  /// Preload a component with a given key
  Future<Widget> preloadComponent(
    String key,
    Future<Widget> Function() builder,
  ) async {
    // Check if already cached
    final cached = _performanceService.getCachedWidget(key);
    if (cached != null) {
      return cached;
    }

    // Check if already preloading
    if (_preloadingComponents.containsKey(key)) {
      return _preloadingComponents[key]!.future;
    }

    // Start preloading
    final completer = Completer<Widget>();
    _preloadingComponents[key] = completer;

    try {
      final widget = await builder();
      _performanceService.cacheWidget(key, widget);
      _performanceService.markAsPreloaded(key);
      completer.complete(widget);
      return widget;
    } catch (error) {
      completer.completeError(error);
      rethrow;
    } finally {
      _preloadingComponents.remove(key);
    }
  }

  /// Add component to preload queue
  void queueForPreload(String key, Future<Widget> Function() builder) {
    if (!_performanceService.isPreloaded(key) && !_preloadQueue.contains(key)) {
      _preloadQueue.add(key);
      _schedulePreload(key, builder);
    }
  }

  /// Schedule preloading with delay to avoid blocking UI
  void _schedulePreload(String key, Future<Widget> Function() builder) {
    if (!_isPreloading) {
      _isPreloading = true;
      Timer(const Duration(milliseconds: 100), () async {
        await _processPreloadQueue(key, builder);
        _isPreloading = false;
      });
    }
  }

  /// Process the preload queue
  Future<void> _processPreloadQueue(
    String key,
    Future<Widget> Function() builder,
  ) async {
    if (_preloadQueue.contains(key)) {
      _preloadQueue.remove(key);
      try {
        await preloadComponent(key, builder);
      } catch (e) {
        // Silently handle preload errors
        debugPrint('Preload failed for $key: $e');
      }
    }
  }

  /// Preload common demo components
  Future<void> preloadCommonComponents() async {
    final commonComponents = [
      'fake_loader_basic',
      'fake_loading_screen_basic',
      'typewriter_text_basic',
      'fake_progress_indicator_basic',
    ];

    for (final key in commonComponents) {
      queueForPreload(key, () async {
        // Return placeholder widgets for common components
        return _createPlaceholderWidget(key);
      });
    }
  }

  /// Create placeholder widget for preloading
  Widget _createPlaceholderWidget(String key) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'Loading $key...',
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  /// Get preload statistics
  Map<String, dynamic> getPreloadStats() {
    return {
      'preloadingComponents': _preloadingComponents.length,
      'queuedComponents': _preloadQueue.length,
      'isPreloading': _isPreloading,
    };
  }

  /// Clear all preload data
  void clearPreloadData() {
    _preloadingComponents.clear();
    _preloadQueue.clear();
    _isPreloading = false;
  }
}

/// Widget that handles preloading of its content
class PreloadableWidget extends StatefulWidget {
  final String preloadKey;
  final Widget Function() builder;
  final Widget? placeholder;
  final bool autoPreload;

  const PreloadableWidget({
    super.key,
    required this.preloadKey,
    required this.builder,
    this.placeholder,
    this.autoPreload = true,
  });

  @override
  State<PreloadableWidget> createState() => _PreloadableWidgetState();
}

class _PreloadableWidgetState extends State<PreloadableWidget> {
  final PreloaderService _preloader = PreloaderService();
  Widget? _preloadedWidget;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoPreload) {
      _startPreload();
    }
  }

  void _startPreload() {
    if (_preloadedWidget == null && !_isLoading) {
      _isLoading = true;
      _preloader
          .preloadComponent(widget.preloadKey, () async => widget.builder())
          .then((widget) {
            if (mounted) {
              setState(() {
                _preloadedWidget = widget;
                _isLoading = false;
              });
            }
          })
          .catchError((error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_preloadedWidget != null) {
      return _preloadedWidget!;
    }

    if (_isLoading) {
      return widget.placeholder ??
          const Center(child: CircularProgressIndicator());
    }

    // Fallback to direct build
    return widget.builder();
  }
}

/// Mixin for screens that need component preloading
mixin PreloadingScreen<T extends StatefulWidget> on State<T> {
  final PreloaderService _preloader = PreloaderService();

  /// Preload components for this screen
  void preloadScreenComponents() {
    // Override in subclasses to define specific components to preload
  }

  @override
  void initState() {
    super.initState();
    // Start preloading after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      preloadScreenComponents();
    });
  }

  /// Helper method to queue component for preload
  void queueComponentPreload(String key, Widget Function() builder) {
    _preloader.queueForPreload(key, () async => builder());
  }
}

/// Batch preloader for multiple components
class BatchPreloader {
  final PreloaderService _preloader = PreloaderService();
  final List<PreloadTask> _tasks = [];
  bool _isRunning = false;

  /// Add a preload task
  void addTask(String key, Future<Widget> Function() builder) {
    _tasks.add(PreloadTask(key, builder));
  }

  /// Execute all preload tasks
  Future<void> executeAll({int concurrency = 3}) async {
    if (_isRunning) return;

    _isRunning = true;

    try {
      // Process tasks in batches to avoid overwhelming the system
      for (int i = 0; i < _tasks.length; i += concurrency) {
        final batch = _tasks.skip(i).take(concurrency);
        final futures = batch.map(
          (task) => _preloader.preloadComponent(task.key, task.builder),
        );

        await Future.wait(futures, eagerError: false);

        // Small delay between batches
        if (i + concurrency < _tasks.length) {
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }
    } finally {
      _isRunning = false;
    }
  }

  /// Clear all tasks
  void clear() {
    _tasks.clear();
  }

  /// Get task count
  int get taskCount => _tasks.length;
}

/// Preload task definition
class PreloadTask {
  final String key;
  final Future<Widget> Function() builder;

  const PreloadTask(this.key, this.builder);
}

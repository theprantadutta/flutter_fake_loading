import 'dart:async';
import 'package:flutter/material.dart';

/// Service for managing performance optimizations across the app
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, Widget> _widgetCache = {};
  final Map<String, String> _codeCache = {};
  final Map<String, Timer> _debounceTimers = {};
  final Set<String> _preloadedComponents = {};

  /// Cache a widget with a unique key
  void cacheWidget(String key, Widget widget) {
    if (_widgetCache.length > 100) {
      // Limit cache size to prevent memory issues
      _clearOldestCacheEntries();
    }
    _widgetCache[key] = widget;
  }

  /// Retrieve a cached widget
  Widget? getCachedWidget(String key) {
    return _widgetCache[key];
  }

  /// Cache generated code
  void cacheCode(String key, String code) {
    if (_codeCache.length > 50) {
      // Limit code cache size
      _clearOldestCodeEntries();
    }
    _codeCache[key] = code;
  }

  /// Retrieve cached code
  String? getCachedCode(String key) {
    return _codeCache[key];
  }

  /// Debounce function calls to prevent excessive updates
  void debounce(String key, VoidCallback callback, Duration delay) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, callback);
  }

  /// Cancel a debounced operation
  void cancelDebounce(String key) {
    _debounceTimers[key]?.cancel();
    _debounceTimers.remove(key);
  }

  /// Mark a component as preloaded
  void markAsPreloaded(String componentKey) {
    _preloadedComponents.add(componentKey);
  }

  /// Check if a component is preloaded
  bool isPreloaded(String componentKey) {
    return _preloadedComponents.contains(componentKey);
  }

  /// Clear all caches
  void clearAllCaches() {
    _widgetCache.clear();
    _codeCache.clear();
    _preloadedComponents.clear();
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
  }

  /// Clear old cache entries to manage memory
  void _clearOldestCacheEntries() {
    if (_widgetCache.length > 50) {
      final keysToRemove = _widgetCache.keys.take(25).toList();
      for (final key in keysToRemove) {
        _widgetCache.remove(key);
      }
    }
  }

  /// Clear old code cache entries
  void _clearOldestCodeEntries() {
    if (_codeCache.length > 25) {
      final keysToRemove = _codeCache.keys.take(10).toList();
      for (final key in keysToRemove) {
        _codeCache.remove(key);
      }
    }
  }

  /// Get cache statistics for debugging
  Map<String, int> getCacheStats() {
    return {
      'widgetCache': _widgetCache.length,
      'codeCache': _codeCache.length,
      'preloadedComponents': _preloadedComponents.length,
      'activeDebounceTimers': _debounceTimers.length,
    };
  }

  /// Dispose of all resources
  void dispose() {
    clearAllCaches();
  }
}

/// Mixin for widgets that need performance optimizations
mixin PerformanceOptimizedWidget<T extends StatefulWidget> on State<T> {
  final PerformanceService _performanceService = PerformanceService();

  /// Cache a widget with automatic key generation
  void cacheWidget(String suffix, Widget widget) {
    final key = '${T.toString()}_$suffix';
    _performanceService.cacheWidget(key, widget);
  }

  /// Get cached widget with automatic key generation
  Widget? getCachedWidget(String suffix) {
    final key = '${T.toString()}_$suffix';
    return _performanceService.getCachedWidget(key);
  }

  /// Debounce with automatic key generation
  void debounceUpdate(VoidCallback callback, [Duration? delay]) {
    final key = '${T.toString()}_update';
    _performanceService.debounce(
      key,
      callback,
      delay ?? const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    // Cancel any pending debounced operations for this widget
    final key = '${T.toString()}_update';
    _performanceService.cancelDebounce(key);
    super.dispose();
  }
}

/// Widget that provides lazy loading capabilities
class LazyLoadingWidget extends StatefulWidget {
  final Widget Function() builder;
  final Widget? placeholder;
  final Duration delay;
  final String? cacheKey;

  const LazyLoadingWidget({
    super.key,
    required this.builder,
    this.placeholder,
    this.delay = const Duration(milliseconds: 100),
    this.cacheKey,
  });

  @override
  State<LazyLoadingWidget> createState() => _LazyLoadingWidgetState();
}

class _LazyLoadingWidgetState extends State<LazyLoadingWidget> {
  Widget? _cachedWidget;
  bool _isLoaded = false;
  Timer? _loadTimer;

  @override
  void initState() {
    super.initState();

    // Check cache first
    if (widget.cacheKey != null) {
      _cachedWidget = PerformanceService().getCachedWidget(widget.cacheKey!);
      if (_cachedWidget != null) {
        _isLoaded = true;
        return;
      }
    }

    // Schedule lazy loading
    _loadTimer = Timer(widget.delay, _loadWidget);
  }

  void _loadWidget() {
    if (mounted) {
      setState(() {
        _cachedWidget = widget.builder();
        _isLoaded = true;

        // Cache the widget if key is provided
        if (widget.cacheKey != null && _cachedWidget != null) {
          PerformanceService().cacheWidget(widget.cacheKey!, _cachedWidget!);
        }
      });
    }
  }

  @override
  void dispose() {
    _loadTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _cachedWidget != null) {
      return _cachedWidget!;
    }

    return widget.placeholder ??
        const Center(child: CircularProgressIndicator());
  }
}

/// Memory-efficient list view for demo content
class OptimizedListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsets? padding;
  final bool shrinkWrap;

  const OptimizedListView({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use ListView.builder for better performance with large lists
    if (children.length > 10) {
      return ListView.builder(
        controller: controller,
        padding: padding,
        shrinkWrap: shrinkWrap,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      );
    }

    // Use regular ListView for small lists
    return ListView(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }
}

/// Optimized code generator with caching
class OptimizedCodeGenerator {
  static final PerformanceService _performanceService = PerformanceService();

  /// Generate code with caching
  static String generateWithCache(
    String cacheKey,
    String Function() generator,
  ) {
    // Check cache first
    final cached = _performanceService.getCachedCode(cacheKey);
    if (cached != null) {
      return cached;
    }

    // Generate and cache
    final code = generator();
    _performanceService.cacheCode(cacheKey, code);
    return code;
  }

  /// Generate cache key from properties
  static String generateCacheKey(
    String prefix,
    Map<String, dynamic> properties,
  ) {
    final sortedKeys = properties.keys.toList()..sort();
    final keyParts = [prefix];

    for (final key in sortedKeys) {
      final value = properties[key];
      keyParts.add('${key}_${value.hashCode}');
    }

    return keyParts.join('_');
  }
}

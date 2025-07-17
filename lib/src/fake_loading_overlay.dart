import 'package:flutter/material.dart';
import 'fake_loader.dart';
import 'fake_loader_controller.dart';

/// A widget that displays fake loading messages while a Future is executing.
/// Shows the child widget once the Future completes.
class FakeLoadingOverlay<T> extends StatefulWidget {
  /// The Future to wait for completion.
  final Future<T> future;

  /// List of messages to display while loading.
  final List<dynamic> messages;

  /// The widget to display after the Future completes.
  final Widget child;

  /// Widget to display if the Future completes with an error.
  final Widget Function(Object error)? errorBuilder;

  /// Default duration for each message.
  final Duration messageDuration;

  /// Whether to display messages in random order.
  final bool randomOrder;

  /// Text style for the loading messages.
  final TextStyle? textStyle;

  /// Widget to display as a spinner/loading indicator.
  final Widget? spinner;

  /// Transition animation between messages.
  final Widget Function(Widget child, Animation<double> animation)? transition;

  /// Background color for the loading overlay.
  final Color? backgroundColor;

  /// Callback when the Future completes successfully.
  final void Function(T data)? onComplete;

  /// Callback when the Future completes with an error.
  final void Function(Object error)? onError;

  const FakeLoadingOverlay({
    super.key,
    required this.future,
    required this.messages,
    required this.child,
    this.errorBuilder,
    this.messageDuration = const Duration(seconds: 2),
    this.randomOrder = false,
    this.textStyle,
    this.spinner,
    this.transition,
    this.backgroundColor,
    this.onComplete,
    this.onError,
  });

  @override
  State<FakeLoadingOverlay<T>> createState() => _FakeLoadingOverlayState<T>();
}

class _FakeLoadingOverlayState<T> extends State<FakeLoadingOverlay<T>> {
  late Future<T> _future;
  bool _isLoading = true;
  Object? _error;
  late FakeLoaderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FakeLoaderController();
    _future = widget.future;
    _startLoading();
  }

  void _startLoading() {
    _controller.start();

    _future
        .then((data) {
          widget.onComplete?.call(data);

          // Wait a bit to show the last message before completing
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          });
        })
        .catchError((error) {
          _error = error;
          widget.onError?.call(error);

          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      if (_error != null) {
        return widget.errorBuilder?.call(_error!) ??
            Center(child: Text('Error: $_error'));
      }
      return widget.child;
    }

    return Container(
      color:
          widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FakeLoader(
            controller: _controller,
            messages: widget.messages,
            messageDuration: widget.messageDuration,
            randomOrder: widget.randomOrder,
            textStyle: widget.textStyle,
            spinner: widget.spinner ?? const CircularProgressIndicator(),
            transition: widget.transition,
            autoStart: false, // We control it manually
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'code_display.dart';
import '../services/performance_service.dart';

/// A reusable card widget for displaying demos with optional code examples.
///
/// This widget provides a consistent layout for showcasing library components
/// with integrated code examples, descriptions, and interactive controls.
/// It includes performance optimizations like widget caching and lazy loading.
///
/// Features:
/// - Expandable/collapsible content areas
/// - Integrated code display with syntax highlighting
/// - Action button support for interactive demos
/// - Performance optimized with caching
/// - Accessibility support with proper semantics
/// - Responsive design for different screen sizes
///
/// Example usage:
/// ```dart
/// DemoCard(
///   title: 'Basic FakeLoader',
///   description: 'A simple loading animation with custom messages',
///   showCode: true,
///   codeSnippet: '''
/// FakeLoader(
///   messages: ['Loading...', 'Almost there...'],
///   duration: Duration(seconds: 2),
/// )
///   ''',
///   child: FakeLoader(
///     messages: ['Loading...', 'Almost there...'],
///     duration: Duration(seconds: 2),
///   ),
///   actions: [
///     IconButton(
///       icon: Icon(Icons.play_arrow),
///       onPressed: () => startDemo(),
///     ),
///   ],
/// )
/// ```
class DemoCard extends StatefulWidget {
  /// The title displayed at the top of the card.
  ///
  /// This should be a concise, descriptive name for the demo.
  final String title;

  /// Optional description text shown below the title.
  ///
  /// Use this to provide context about what the demo demonstrates
  /// or how to interact with it.
  final String? description;

  /// The main content widget to display in the card.
  ///
  /// This is typically the component being demonstrated.
  final Widget child;

  /// Optional action buttons displayed in the card header.
  ///
  /// These can be used for demo controls like play/pause, reset,
  /// or configuration options.
  final List<Widget>? actions;

  /// Whether to show the expandable code section.
  ///
  /// When true, a "Show Code" button will be displayed that
  /// reveals the code snippet when tapped.
  final bool showCode;

  /// The code snippet to display when [showCode] is true.
  ///
  /// This should be properly formatted Dart code that demonstrates
  /// how to use the component shown in [child].
  final String? codeSnippet;

  /// Custom padding for the card content.
  ///
  /// If not provided, default padding will be applied.
  final EdgeInsets? padding;

  /// Whether the card content is expanded by default.
  ///
  /// When false, the card will be collapsed initially and can
  /// be expanded by tapping the header.
  final bool initiallyExpanded;

  const DemoCard({
    super.key,
    required this.title,
    this.description,
    required this.child,
    this.actions,
    this.showCode = false,
    this.codeSnippet,
    this.padding,
    this.initiallyExpanded = true,
  });

  @override
  State<DemoCard> createState() => _DemoCardState();
}

class _DemoCardState extends State<DemoCard> with PerformanceOptimizedWidget {
  bool _showCode = false;
  late bool _isExpanded;
  Widget? _cachedChild;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    // Cache the child widget if it's expensive to build
    if (widget.initiallyExpanded) {
      _cacheChildWidget();
    }
  }

  void _cacheChildWidget() {
    if (_cachedChild == null) {
      _cachedChild = getCachedWidget('child') ?? widget.child;
      if (getCachedWidget('child') == null) {
        cacheWidget('child', widget.child);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (widget.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.description!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showCode && widget.codeSnippet != null) ...[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _showCode = !_showCode;
                            });
                          },
                          icon: Icon(
                            _showCode ? Icons.code_off : Icons.code,
                            color: _showCode
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                          tooltip: _showCode ? 'Hide Code' : 'Show Code',
                        ),
                      ],
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: widget.padding ?? const EdgeInsets.all(16),
              child: LazyLoadingWidget(
                cacheKey: 'demo_card_${widget.title.hashCode}',
                builder: () {
                  _cacheChildWidget();
                  return _cachedChild ?? widget.child;
                },
                placeholder: const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),

            // Actions
            if (widget.actions != null && widget.actions!.isNotEmpty) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.actions!,
                ),
              ),
            ],

            // Code Display
            if (_showCode && widget.codeSnippet != null) ...[
              const Divider(height: 1),
              LazyLoadingWidget(
                cacheKey: 'code_display_${widget.codeSnippet.hashCode}',
                builder: () =>
                    CodeDisplay(code: widget.codeSnippet!, language: 'dart'),
                placeholder: const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

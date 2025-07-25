import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/navigation_provider.dart';

/// Quick demo widget showing a simple FakeLoader in action
class QuickDemo extends StatefulWidget {
  const QuickDemo({super.key});

  @override
  State<QuickDemo> createState() => _QuickDemoState();
}

class _QuickDemoState extends State<QuickDemo> {
  final FakeLoaderController _controller = FakeLoaderController();
  bool _isRunning = false;

  final List<String> _messages = [
    "Charging flux capacitor...",
    "Summoning cats...",
    "Uploading your vibe to the cloud...",
    "Dusting off widgets...",
    "Calibrating awesome-ness...",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDemo() {
    if (!mounted) return;

    if (_isRunning) {
      _controller.stop();
    } else {
      _controller.start();
    }

    if (mounted) {
      setState(() {
        _isRunning = !_isRunning;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.preview,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Interactive Preview',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (_isRunning)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Running',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Experience the magic of fake loading messages in action',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Demo Area
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surfaceContainerLow,
                    Theme.of(context).colorScheme.surfaceContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: FakeLoader(
                controller: _controller,
                messages: _messages,
                messageDuration: const Duration(seconds: 2),
                textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
                spinner: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 3,
                ),
                autoStart: false,
                onComplete: () {
                  if (mounted) {
                    setState(() {
                      _isRunning = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.celebration,
                              color: Theme.of(
                                context,
                              ).colorScheme.onInverseSurface,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text('Demo completed! 🎉'),
                          ],
                        ),
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.inverseSurface,
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 24),

            // Control Buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _toggleDemo,
                    icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
                    label: Text(_isRunning ? 'Stop Demo' : 'Start Demo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                      foregroundColor: _isRunning
                          ? Theme.of(context).colorScheme.onError
                          : Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.read<NavigationProvider>().goToComponents(),
                    icon: const Icon(Icons.explore),
                    label: const Text('Explore'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

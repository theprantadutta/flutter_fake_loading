import 'package:flutter/material.dart';
import '../../core/widgets/section_header.dart';
import 'fake_loader/fake_loader_demo.dart';
import 'fake_loading_screen/fake_loading_screen_demo.dart';
import 'fake_loading_overlay/fake_loading_overlay_demo.dart';
import 'typewriter_text/typewriter_text_demo.dart';

/// Screen for displaying component demonstrations
class ComponentsScreen extends StatelessWidget {
  const ComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Components')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Component Demonstrations',
              subtitle:
                  'Explore all available components with interactive examples',
              icon: Icons.widgets,
            ),

            const SizedBox(height: 16),

            // FakeLoader Component
            _ComponentCard(
              title: 'FakeLoader',
              description:
                  'Core loading widget with customizable messages and effects',
              icon: Icons.refresh,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FakeLoaderDemo(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // FakeLoadingScreen Component
            _ComponentCard(
              title: 'FakeLoadingScreen',
              description:
                  'Full-screen loading experience with progress indicators',
              icon: Icons.fullscreen,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FakeLoadingScreenDemo(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            _ComponentCard(
              title: 'FakeLoadingOverlay',
              description: 'Overlay loading for async operations',
              icon: Icons.layers,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FakeLoadingOverlayDemo(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            _ComponentCard(
              title: 'FakeProgressIndicator',
              description: 'Standalone progress simulation widget',
              icon: Icons.donut_large,
              isComingSoon: true,
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Coming soon!')));
              },
            ),

            const SizedBox(height: 12),

            _ComponentCard(
              title: 'TypewriterText',
              description: 'Character-by-character text animation effect',
              icon: Icons.keyboard,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TypewriterTextDemo(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final bool isComingSoon;

  const _ComponentCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isComingSoon
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isComingSoon
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isComingSoon
                                ? theme.colorScheme.onSurfaceVariant
                                : null,
                          ),
                        ),
                        if (isComingSoon) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'SOON',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.outline,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isComingSoon
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isComingSoon
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

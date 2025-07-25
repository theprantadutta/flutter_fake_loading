import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/navigation_provider.dart';

/// Grid displaying all available features and components
class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final features = _getFeatures();

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: crossAxisCount == 3 ? 1.1 : 1.0,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return _FeatureCard(feature: feature);
          },
        );
      },
    );
  }

  List<_Feature> _getFeatures() {
    return [
      _Feature(
        title: 'FakeLoader',
        description: 'Customizable loading widget with personality',
        details: 'Messages, spinners, effects & more',
        icon: Icons.refresh,
        color: const Color(0xFF2196F3),
        badge: 'Core',
        onTap: (context) => context.read<NavigationProvider>().goToComponents(),
      ),
      _Feature(
        title: 'Loading Screen',
        description: 'Full-screen loading experiences',
        details: 'Theming, layouts & responsive design',
        icon: Icons.fullscreen,
        color: const Color(0xFF4CAF50),
        badge: 'Screen',
        onTap: (context) => context.read<NavigationProvider>().goToComponents(),
      ),
      _Feature(
        title: 'Loading Overlay',
        description: 'Async operation wrapper',
        details: 'Future integration & error handling',
        icon: Icons.layers,
        color: const Color(0xFFFF9800),
        badge: 'Async',
        onTap: (context) => context.read<NavigationProvider>().goToComponents(),
      ),
      _Feature(
        title: 'Progress Indicator',
        description: 'Custom progress animations',
        details: 'Circular, linear & custom widgets',
        icon: Icons.timeline,
        color: const Color(0xFF9C27B0),
        badge: 'Progress',
        onTap: (context) => context.read<NavigationProvider>().goToComponents(),
      ),
      _Feature(
        title: 'Typewriter Text',
        description: 'Character-by-character animation',
        details: 'Cursors, speeds & formatting',
        icon: Icons.keyboard,
        color: const Color(0xFF009688),
        badge: 'Text',
        onTap: (context) => context.read<NavigationProvider>().goToComponents(),
      ),
      _Feature(
        title: 'Message System',
        description: 'Smart message management',
        details: 'Packs, weights & effects',
        icon: Icons.message,
        color: const Color(0xFFE91E63),
        badge: 'Messages',
        onTap: (context) => context.read<NavigationProvider>().goToComponents(),
      ),
      _Feature(
        title: 'Interactive Playground',
        description: 'Real-time customization',
        details: 'Live preview & code generation',
        icon: Icons.tune,
        color: const Color(0xFFFF5722),
        badge: 'Playground',
        onTap: (context) => context.read<NavigationProvider>().goToPlayground(),
      ),
      _Feature(
        title: 'Real-World Examples',
        description: 'Production-ready scenarios',
        details: 'API calls, onboarding & more',
        icon: Icons.apps,
        color: const Color(0xFF795548),
        badge: 'Examples',
        onTap: (context) => context.read<NavigationProvider>().goToExamples(),
      ),
    ];
  }
}

class _Feature {
  final String title;
  final String description;
  final String details;
  final IconData icon;
  final Color color;
  final String badge;
  final void Function(BuildContext context) onTap;

  _Feature({
    required this.title,
    required this.description,
    required this.details,
    required this.icon,
    required this.color,
    required this.badge,
    required this.onTap,
  });
}

class _FeatureCard extends StatelessWidget {
  final _Feature feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () => feature.onTap(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: feature.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(feature.icon, color: feature.color, size: 24),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: feature.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      feature.badge,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: feature.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                feature.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  feature.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                feature.details,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.arrow_forward, size: 16, color: feature.color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

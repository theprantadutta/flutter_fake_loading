import 'package:flutter/material.dart';
import '../../../core/utils/code_generator.dart';

/// Tab configuration for the playground
class PlaygroundTab {
  final ComponentType componentType;
  final String title;
  final IconData icon;
  final String description;

  const PlaygroundTab({
    required this.componentType,
    required this.title,
    required this.icon,
    required this.description,
  });
}

/// Widget for managing playground tabs
class PlaygroundTabs extends StatelessWidget {
  final ComponentType selectedComponent;
  final ValueChanged<ComponentType> onComponentChanged;

  const PlaygroundTabs({
    super.key,
    required this.selectedComponent,
    required this.onComponentChanged,
  });

  static const List<PlaygroundTab> _tabs = [
    PlaygroundTab(
      componentType: ComponentType.fakeLoader,
      title: 'FakeLoader',
      icon: Icons.refresh,
      description: 'Animated loading messages',
    ),
    PlaygroundTab(
      componentType: ComponentType.fakeLoadingScreen,
      title: 'Loading Screen',
      icon: Icons.fullscreen,
      description: 'Full-screen loading',
    ),
    PlaygroundTab(
      componentType: ComponentType.fakeLoadingOverlay,
      title: 'Overlay',
      icon: Icons.layers,
      description: 'Loading overlay',
    ),
    PlaygroundTab(
      componentType: ComponentType.fakeProgressIndicator,
      title: 'Progress',
      icon: Icons.donut_small,
      description: 'Progress indicators',
    ),
    PlaygroundTab(
      componentType: ComponentType.typewriterText,
      title: 'Typewriter',
      icon: Icons.keyboard,
      description: 'Typewriter text effect',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final tab = _tabs[index];
          final isSelected = tab.componentType == selectedComponent;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              width: 140,
              child: Card(
                elevation: isSelected ? 4 : 1,
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null,
                child: InkWell(
                  onTap: () => onComponentChanged(tab.componentType),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tab.icon,
                          size: 32,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tab.title,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer
                                    : null,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.description,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isSelected
                                    ? Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer
                                          .withValues(alpha: 0.7)
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

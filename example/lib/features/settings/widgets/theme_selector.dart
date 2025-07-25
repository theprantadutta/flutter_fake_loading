import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';

/// Theme selection widget with live preview
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),

            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Column(
                  children: [
                    // Theme Mode Selection
                    _ThemeModeCard(
                      title: 'Light Theme',
                      subtitle: 'Always use light theme',
                      icon: Icons.light_mode,
                      themeMode: ThemeMode.light,
                      currentMode: themeProvider.themeMode,
                      onChanged: (value) => themeProvider.setThemeMode(value),
                      previewColors: _getLightPreviewColors(context),
                    ),
                    const SizedBox(height: 8),

                    _ThemeModeCard(
                      title: 'Dark Theme',
                      subtitle: 'Always use dark theme',
                      icon: Icons.dark_mode,
                      themeMode: ThemeMode.dark,
                      currentMode: themeProvider.themeMode,
                      onChanged: (value) => themeProvider.setThemeMode(value),
                      previewColors: _getDarkPreviewColors(context),
                    ),
                    const SizedBox(height: 8),

                    _ThemeModeCard(
                      title: 'System Theme',
                      subtitle: 'Follow system settings',
                      icon: Icons.settings_system_daydream,
                      themeMode: ThemeMode.system,
                      currentMode: themeProvider.themeMode,
                      onChanged: (value) => themeProvider.setThemeMode(value),
                      previewColors: _getSystemPreviewColors(context),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getLightPreviewColors(BuildContext context) {
    return [
      const Color(0xFF6750A4), // Primary
      const Color(0xFFEADDFF), // Primary container
      const Color(0xFF625B71), // Secondary
      const Color(0xFFFFFBFE), // Surface
    ];
  }

  List<Color> _getDarkPreviewColors(BuildContext context) {
    return [
      const Color(0xFFD0BCFF), // Primary
      const Color(0xFF4F378B), // Primary container
      const Color(0xFFCCC2DC), // Secondary
      const Color(0xFF10131C), // Surface
    ];
  }

  List<Color> _getSystemPreviewColors(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark
        ? _getDarkPreviewColors(context)
        : _getLightPreviewColors(context);
  }
}

class _ThemeModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final ThemeMode themeMode;
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;
  final List<Color> previewColors;

  const _ThemeModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.themeMode,
    required this.currentMode,
    required this.onChanged,
    required this.previewColors,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentMode == themeMode;

    return InkWell(
      onTap: () => onChanged(themeMode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3)
              : null,
        ),
        child: Row(
          children: [
            // Theme icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Theme info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Color preview
            Row(
              mainAxisSize: MainAxisSize.min,
              children: previewColors.map((color) {
                return Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.only(left: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(width: 8),

            // Selection indicator
            Radio<ThemeMode>(
              value: themeMode,
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) onChanged(value);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}

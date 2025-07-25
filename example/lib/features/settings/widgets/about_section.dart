import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Enhanced about section with app information
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text('About', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),

            // App Information
            _InfoTile(
              icon: Icons.apps,
              title: 'Flutter Fake Loading Showcase',
              subtitle: 'Version 1.0.0',
              onTap: () => _showAppDetails(context),
            ),

            _InfoTile(
              icon: Icons.code,
              title: 'Built with Flutter',
              subtitle: 'Material 3 Design System',
              onTap: () => _launchUrl('https://flutter.dev'),
            ),

            _InfoTile(
              icon: Icons.palette,
              title: 'Design System',
              subtitle: 'Material You & Dynamic Color',
              onTap: () => _launchUrl('https://m3.material.io'),
            ),

            _InfoTile(
              icon: Icons.favorite,
              title: 'Made with ❤️',
              subtitle: 'For the Flutter community',
            ),

            const SizedBox(height: 16),

            // Links Section
            _LinksSection(),

            const SizedBox(height: 16),

            // System Information
            _SystemInfoSection(),
          ],
        ),
      ),
    );
  }

  void _showAppDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow('Package Name', 'flutter_fake_loading'),
            _DetailRow('Version', '1.0.0'),
            _DetailRow('Build Number', '1'),
            _DetailRow('Flutter Version', '3.8.1'),
            _DetailRow('Dart Version', '3.8.1'),
            _DetailRow('Platform', Theme.of(context).platform.name),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      trailing: onTap != null
          ? Icon(
              Icons.open_in_new,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )
          : null,
    );
  }
}

class _LinksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Links',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _LinkChip(
              label: 'Documentation',
              icon: Icons.book,
              onTap: () =>
                  _launchUrl('https://pub.dev/packages/flutter_fake_loading'),
            ),
            _LinkChip(
              label: 'GitHub',
              icon: Icons.code,
              onTap: () =>
                  _launchUrl('https://github.com/example/flutter_fake_loading'),
            ),
            _LinkChip(
              label: 'Issues',
              icon: Icons.bug_report,
              onTap: () => _launchUrl(
                'https://github.com/example/flutter_fake_loading/issues',
              ),
            ),
            _LinkChip(
              label: 'Pub.dev',
              icon: Icons.inventory_2,
              onTap: () =>
                  _launchUrl('https://pub.dev/packages/flutter_fake_loading'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _LinkChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _LinkChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: onTap,
    );
  }
}

class _SystemInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Information',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _SystemInfoRow('Platform', Theme.of(context).platform.name),
              _SystemInfoRow('Screen Size', _getScreenSize(context)),
              _SystemInfoRow('Brightness', _getBrightness(context)),
              _SystemInfoRow('Text Scale', _getTextScale(context)),
            ],
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _copySystemInfo(context),
            icon: const Icon(Icons.copy),
            label: const Text('Copy System Info'),
          ),
        ),
      ],
    );
  }

  String _getScreenSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return '${size.width.toInt()} × ${size.height.toInt()}';
  }

  String _getBrightness(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark ? 'Dark' : 'Light';
  }

  String _getTextScale(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    return '${(textScale * 100).toInt()}%';
  }

  void _copySystemInfo(BuildContext context) {
    final info =
        '''
Flutter Fake Loading Showcase
Version: 1.0.0
Platform: ${Theme.of(context).platform.name}
Screen Size: ${_getScreenSize(context)}
Brightness: ${_getBrightness(context)}
Text Scale: ${_getTextScale(context)}
Flutter Version: 3.8.1
Dart Version: 3.8.1
''';

    Clipboard.setData(ClipboardData(text: info));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('System information copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _SystemInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _SystemInfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

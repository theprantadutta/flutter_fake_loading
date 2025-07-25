import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../core/widgets/demo_card.dart';
import '../../../core/widgets/code_display.dart';

/// App launch sequence example demonstrating realistic startup loading
class AppLaunchExample extends StatefulWidget {
  const AppLaunchExample({super.key});

  @override
  State<AppLaunchExample> createState() => _AppLaunchExampleState();
}

class _AppLaunchExampleState extends State<AppLaunchExample> {
  bool _isLaunching = false;
  bool _showMainApp = false;

  void _startLaunchSequence() {
    if (mounted) {
      setState(() {
        _isLaunching = true;
        _showMainApp = false;
      });
    }
  }

  void _onLaunchComplete() {
    if (mounted) {
      setState(() {
        _isLaunching = false;
        _showMainApp = true;
      });
    }
  }

  void _resetDemo() {
    if (mounted) {
      setState(() {
        _isLaunching = false;
        _showMainApp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemoCard(
          title: 'App Launch Sequence',
          description: 'Realistic app startup with progressive loading stages',
          child: Column(
            children: [
              if (!_isLaunching && !_showMainApp) ...[
                _buildLaunchButton(),
              ] else if (_isLaunching) ...[
                _buildLaunchingScreen(),
              ] else if (_showMainApp) ...[
                _buildMainAppContent(),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCodeExample(),
      ],
    );
  }

  Widget _buildLaunchButton() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rocket_launch,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'MyAwesome App',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version 1.0.0',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _startLaunchSequence,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Launch App'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaunchingScreen() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FakeLoadingScreen(
        messages: _getAppLaunchMessages(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        textColor: Theme.of(context).colorScheme.onSurface,
        progressColor: Theme.of(context).colorScheme.primary,
        showProgress: true,
        randomOrder: false,
        onComplete: _onLaunchComplete,
      ),
    );
  }

  Widget _buildMainAppContent() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to MyAwesome App!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'App launched successfully',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _resetDemo,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {
                  // Simulate navigation to main app
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Navigating to main app...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Continue'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExample() {
    return DemoCard(
      title: 'Implementation Code',
      child: CodeDisplay(
        code: '''
// App launch sequence with progressive loading
class AppLaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FakeLoadingScreen(
      messages: [
        'Initializing app...',
        'Loading user preferences...',
        'Connecting to services...',
        'Preparing interface...',
        'Almost ready...',
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      textColor: Theme.of(context).colorScheme.onSurface,
      progressColor: Theme.of(context).colorScheme.primary,
      showProgress: true,
      randomOrder: false,
      onComplete: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainApp()),
      ),
    );
  }
}''',
        language: 'dart',
      ),
    );
  }

  List<String> _getAppLaunchMessages() {
    return [
      'Initializing app...',
      'Loading user preferences...',
      'Connecting to services...',
      'Preparing interface...',
      'Almost ready...',
    ];
  }
}

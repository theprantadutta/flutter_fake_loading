import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../core/widgets/demo_card.dart';
import '../../../core/widgets/code_display.dart';

/// Onboarding flow example with multi-step loading transitions
class OnboardingExample extends StatefulWidget {
  const OnboardingExample({super.key});

  @override
  State<OnboardingExample> createState() => _OnboardingExampleState();
}

class _OnboardingExampleState extends State<OnboardingExample> {
  int _currentStep = 0;
  bool _isLoading = false;
  bool _onboardingComplete = false;

  final List<OnboardingStep> _steps = [
    OnboardingStep(
      title: 'Welcome!',
      description: 'Let\'s get you set up with our amazing app',
      icon: Icons.waving_hand,
      color: Colors.blue,
    ),
    OnboardingStep(
      title: 'Personalize',
      description: 'Tell us about your preferences',
      icon: Icons.person,
      color: Colors.green,
    ),
    OnboardingStep(
      title: 'Connect',
      description: 'Link your accounts and services',
      icon: Icons.link,
      color: Colors.orange,
    ),
    OnboardingStep(
      title: 'Tutorial',
      description: 'Learn the basics with our quick guide',
      icon: Icons.school,
      color: Colors.purple,
    ),
    OnboardingStep(
      title: 'Ready!',
      description: 'You\'re all set to start using the app',
      icon: Icons.rocket_launch,
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemoCard(
          title: 'Onboarding Flow',
          description:
              'Multi-step onboarding with loading transitions between steps',
          child: Column(
            children: [
              _buildProgressIndicator(),
              const SizedBox(height: 16),
              _buildOnboardingContent(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCodeExample(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Onboarding Progress',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '${_currentStep + 1} / ${_steps.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (_currentStep + 1) / _steps.length,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingContent() {
    if (_onboardingComplete) {
      return _buildCompletionScreen();
    }

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: _isLoading ? _buildLoadingTransition() : _buildStepContent(),
    );
  }

  Widget _buildStepContent() {
    final step = _steps[_currentStep];

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: step.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(step.icon, size: 40, color: step.color),
          ),
          const SizedBox(height: 24),
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: step.color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            step.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 32),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _goToPreviousStep,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                )
              else
                const SizedBox.shrink(),

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _goToNextStep,
                icon: Icon(
                  _currentStep == _steps.length - 1
                      ? Icons.check
                      : Icons.arrow_forward,
                ),
                label: Text(
                  _currentStep == _steps.length - 1 ? 'Finish' : 'Continue',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: step.color,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingTransition() {
    final step = _steps[_currentStep];

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: step.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(step.icon, size: 30, color: step.color),
          ),
          const SizedBox(height: 24),

          TypewriterText(
            text: _getLoadingMessage(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),

          const SizedBox(height: 32),

          FakeLoader(
            messages: _getStepLoadingMessages(),
            messageDuration: const Duration(milliseconds: 1200),
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: 200,
            child: FakeProgressIndicator(
              duration: const Duration(seconds: 3),
              color: step.color,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.celebration, size: 40, color: Colors.green),
          ),
          const SizedBox(height: 24),
          Text(
            'Onboarding Complete!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Welcome to the app! You\'re ready to start exploring.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                onPressed: _resetOnboarding,
                icon: const Icon(Icons.refresh),
                label: const Text('Start Over'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Navigating to main app...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Enter App'),
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
// Multi-step onboarding with loading transitions
class OnboardingFlow extends StatefulWidget {
  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int currentStep = 0;
  bool isLoading = false;
  
  void _goToNextStep() async {
    if (currentStep < steps.length - 1) {
      setState(() => isLoading = true);
      
      // Simulate step processing
      await Future.delayed(Duration(seconds: 3));
      
      setState(() {
        currentStep++;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? _buildLoadingTransition()
          : _buildStepContent(),
    );
  }

  Widget _buildLoadingTransition() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TypewriterText(
          text: 'Setting up your preferences...',
        ),
        SizedBox(height: 32),
        FakeLoader(
          messages: [
            'Loading user preferences...',
            'Configuring settings...',
            'Preparing tutorial...',
          ],
          messageDuration: Duration(seconds: 1),
        ),
        SizedBox(height: 24),
        FakeProgressIndicator(
          duration: Duration(seconds: 3),
        ),
      ],
    );
  }
}''',
        language: 'dart',
      ),
    );
  }

  String _getLoadingMessage() {
    switch (_currentStep) {
      case 0:
        return 'Setting up your welcome experience...';
      case 1:
        return 'Saving your preferences...';
      case 2:
        return 'Connecting your accounts...';
      case 3:
        return 'Preparing your tutorial...';
      case 4:
        return 'Finalizing your setup...';
      default:
        return 'Processing...';
    }
  }

  List<String> _getStepLoadingMessages() {
    switch (_currentStep) {
      case 0:
        return [
          'Initializing welcome screen...',
          'Loading app features...',
          'Preparing introduction...',
        ];
      case 1:
        return [
          'Saving theme preferences...',
          'Configuring notifications...',
          'Setting up location services...',
        ];
      case 2:
        return [
          'Connecting email account...',
          'Syncing cloud storage...',
          'Linking social accounts...',
        ];
      case 3:
        return [
          'Loading tutorial content...',
          'Preparing interactive guide...',
          'Setting up help system...',
        ];
      case 4:
        return [
          'Finalizing configuration...',
          'Preparing main interface...',
          'Almost ready...',
        ];
      default:
        return ['Processing...'];
    }
  }

  void _goToNextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _isLoading = true);

      Timer(const Duration(seconds: 3), () {
        setState(() {
          _currentStep++;
          _isLoading = false;
        });
      });
    } else {
      setState(() => _isLoading = true);

      Timer(const Duration(seconds: 3), () {
        setState(() {
          _onboardingComplete = true;
          _isLoading = false;
        });
      });
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _resetOnboarding() {
    setState(() {
      _currentStep = 0;
      _isLoading = false;
      _onboardingComplete = false;
    });
  }
}

class OnboardingStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

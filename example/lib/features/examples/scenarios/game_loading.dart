import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../core/widgets/demo_card.dart';
import '../../../core/widgets/code_display.dart';

/// Game loading screen example with animated characters and asset loading
class GameLoadingExample extends StatefulWidget {
  const GameLoadingExample({super.key});

  @override
  State<GameLoadingExample> createState() => _GameLoadingExampleState();
}

class _GameLoadingExampleState extends State<GameLoadingExample>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _gameReady = false;
  int _selectedGameType = 0;

  late AnimationController _characterAnimationController;
  late AnimationController _backgroundAnimationController;

  final List<GameType> _gameTypes = [
    GameType(
      name: 'Adventure RPG',
      icon: '🗡️',
      color: Colors.deepPurple,
      character: '🧙‍♂️',
      background: Colors.deepPurple.withValues(alpha: 0.1),
    ),
    GameType(
      name: 'Space Shooter',
      icon: '🚀',
      color: Colors.blue,
      character: '👨‍🚀',
      background: Colors.blue.withValues(alpha: 0.1),
    ),
    GameType(
      name: 'Racing Game',
      icon: '🏎️',
      color: Colors.red,
      character: '🏁',
      background: Colors.red.withValues(alpha: 0.1),
    ),
    GameType(
      name: 'Puzzle Quest',
      icon: '🧩',
      color: Colors.green,
      character: '🤔',
      background: Colors.green.withValues(alpha: 0.1),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _characterAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _characterAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemoCard(
          title: 'Game Loading Screen',
          description:
              'Game-style loading with character animations and asset preparation',
          child: Column(
            children: [
              _buildGameTypeSelector(),
              const SizedBox(height: 16),
              _buildGameLoadingDemo(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCodeExample(),
      ],
    );
  }

  Widget _buildGameTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Game Type',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _gameTypes.asMap().entries.map((entry) {
              final index = entry.key;
              final gameType = entry.value;
              final isSelected = index == _selectedGameType;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGameType = index;
                    _gameReady = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? gameType.color.withValues(alpha: 0.2)
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? gameType.color
                          : Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(gameType.icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        gameType.name,
                        style: TextStyle(
                          color: isSelected
                              ? gameType.color
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGameLoadingDemo() {
    final gameType = _gameTypes[_selectedGameType];

    return Container(
      height: 450,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gameType.background, gameType.color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: gameType.color.withValues(alpha: 0.3)),
      ),
      child: _isLoading
          ? _buildLoadingScreen(gameType)
          : _gameReady
          ? _buildGameReadyScreen(gameType)
          : _buildStartScreen(gameType),
    );
  }

  Widget _buildStartScreen(GameType gameType) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(gameType.icon, style: const TextStyle(fontSize: 64)),
        const SizedBox(height: 24),
        Text(
          gameType.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: gameType.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Epic Adventure Awaits',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: _startGameLoading,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Game'),
          style: ElevatedButton.styleFrom(
            backgroundColor: gameType.color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Click to begin loading',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingScreen(GameType gameType) {
    return FakeLoadingScreen(
      messages: _getGameLoadingMessages(gameType),
      backgroundColor: gameType.background,
      textColor: Theme.of(context).colorScheme.onSurface,
      progressColor: gameType.color,
      showProgress: true,
      randomOrder: false,
      onComplete: _onGameLoadingComplete,
    );
  }

  Widget _buildGameReadyScreen(GameType gameType) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gameType.color.withValues(alpha: 0.2),
            gameType.color.withValues(alpha: 0.1),
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
            child: const Icon(
              Icons.check_circle,
              size: 40,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Game Ready!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: gameType.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All assets loaded successfully',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _resetGameDemo,
                icon: const Icon(Icons.refresh),
                label: const Text('Load Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gameType.color,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Starting ${gameType.name}...'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: gameType.color,
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play Game'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: gameType.color,
                  side: BorderSide(color: gameType.color),
                ),
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
// Game loading screen with character animations
class GameLoadingScreen extends StatefulWidget {
  final GameType gameType;
  
  @override
  _GameLoadingScreenState createState() => _GameLoadingScreenState();
}

class _GameLoadingScreenState extends State<GameLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _characterController;
  late Animation<double> _characterBounce;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _characterController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _characterBounce = Tween<double>(
      begin: 0.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _characterController,
      curve: Curves.elasticInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FakeLoadingScreen(
      messages: [
        'Loading world assets...',
        'Preparing character data...',
        'Initializing game engine...',
        'Loading audio files...',
        'Setting up controls...',
        'Almost ready to play...',
      ],
      backgroundColor: widget.gameType.background,
      textColor: Theme.of(context).colorScheme.onSurface,
      progressColor: widget.gameType.color,
      showProgress: true,
      randomOrder: false,
      onComplete: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => GameScreen()),
      ),
    );
  }
}''',
        language: 'dart',
      ),
    );
  }

  List<String> _getGameLoadingMessages(GameType gameType) {
    switch (_selectedGameType) {
      case 0: // Adventure RPG
        return [
          'Loading mystical world...',
          'Preparing character classes...',
          'Initializing spell system...',
          'Loading quest database...',
          'Setting up inventory...',
          'Almost ready for adventure...',
        ];
      case 1: // Space Shooter
        return [
          'Calibrating space engines...',
          'Loading weapon systems...',
          'Initializing star maps...',
          'Preparing enemy AI...',
          'Setting up controls...',
          'Ready for launch...',
        ];
      case 2: // Racing Game
        return [
          'Warming up engines...',
          'Loading race tracks...',
          'Preparing vehicle physics...',
          'Setting up weather system...',
          'Calibrating controls...',
          'Ready to race...',
        ];
      case 3: // Puzzle Quest
        return [
          'Generating puzzle patterns...',
          'Loading brain teasers...',
          'Preparing hint system...',
          'Setting up scoring...',
          'Calibrating difficulty...',
          'Ready to puzzle...',
        ];
      default:
        return ['Loading game...'];
    }
  }

  void _startGameLoading() {
    setState(() {
      _isLoading = true;
      _gameReady = false;
    });

    // Start character animation
    _characterAnimationController.repeat(reverse: true);
    _backgroundAnimationController.repeat(reverse: true);
  }

  void _onGameLoadingComplete() {
    _characterAnimationController.stop();
    _backgroundAnimationController.stop();

    setState(() {
      _isLoading = false;
      _gameReady = true;
    });
  }

  void _resetGameDemo() {
    _characterAnimationController.reset();
    _backgroundAnimationController.reset();

    setState(() {
      _isLoading = false;
      _gameReady = false;
    });
  }
}

class GameType {
  final String name;
  final String icon;
  final Color color;
  final String character;
  final Color background;

  const GameType({
    required this.name,
    required this.icon,
    required this.color,
    required this.character,
    required this.background,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import 'showcase_app.dart';

void main() {
  runApp(const ShowcaseApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Fake Loading Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const BasicDemoTab(),
    const OverlayDemoTab(),
    const StylesTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline),
            selectedIcon: Icon(Icons.play_circle),
            label: 'Basic Demo',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            selectedIcon: Icon(Icons.layers),
            label: 'Overlay Demo',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined),
            selectedIcon: Icon(Icons.palette),
            label: 'Styles',
          ),
        ],
      ),
    );
  }
}

// Home Tab
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Fake Loading'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.rocket_launch,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome to Flutter Fake Loading!',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Because loading shouldn\'t be boring.',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'A quirky, customizable fake loading screen engine perfect for portfolio apps, indie games, onboarding flows, or just for ✨vibes✨.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Demo
            Text(
              'Quick Demo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Here\'s a taste of what you can do:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: FakeLoader(
                          messages: const [
                            "Charging flux capacitor...",
                            "Summoning cats...",
                            "Uploading your vibe to the cloud...",
                            "Dusting off widgets...",
                          ],
                          messageDuration: const Duration(seconds: 2),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                          spinner: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Features
            Text('Features', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),

            _buildFeatureCard(
              context,
              Icons.play_circle_outline,
              'Basic Demo',
              'Simple fake loader with customizable messages and controls.',
            ),

            _buildFeatureCard(
              context,
              Icons.layers_outlined,
              'Overlay Demo',
              'Wrap real async operations with fake loading messages.',
            ),

            _buildFeatureCard(
              context,
              Icons.palette_outlined,
              'Custom Styles',
              'Customize fonts, colors, transitions, and spinners.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
          subtitle: Text(description),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}

// Basic Demo Tab
class BasicDemoTab extends StatefulWidget {
  const BasicDemoTab({super.key});

  @override
  State<BasicDemoTab> createState() => _BasicDemoTabState();
}

class _BasicDemoTabState extends State<BasicDemoTab> {
  final FakeLoaderController _controller = FakeLoaderController();
  bool _randomOrder = false;
  int _selectedMessageSet = 0;

  final List<List<String>> _messageSets = [
    [
      "Charging flux capacitor...",
      "Summoning cats...",
      "Uploading your vibe to the cloud...",
      "Dusting off widgets...",
    ],
    [
      "Feeding the hamsters...",
      "Inverting gravity...",
      "Aligning electrons...",
      "Calibrating sensors...",
    ],
    [
      "Loading awesome sauce...",
      "Preparing magic tricks...",
      "Warming up the engines...",
      "Gathering cosmic energy...",
    ],
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Demo'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic FakeLoader Demo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This demonstrates the core FakeLoader widget with programmatic control. '
                        'You can start, stop, skip, and reset the loading sequence.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Controls
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Controls',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),

                      // Message Set Selection
                      Text(
                        'Message Set:',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 0, label: Text('Tech')),
                          ButtonSegment(value: 1, label: Text('Sci-Fi')),
                          ButtonSegment(value: 2, label: Text('Fun')),
                        ],
                        selected: {_selectedMessageSet},
                        onSelectionChanged: (Set<int> selection) {
                          if (mounted) {
                            setState(() {
                              _selectedMessageSet = selection.first;
                            });
                            _controller.reset();
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Random Order Toggle
                      SwitchListTile(
                        title: const Text('Random Order'),
                        subtitle: const Text(
                          'Display messages in random order',
                        ),
                        value: _randomOrder,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              _randomOrder = value;
                            });
                            _controller.reset();
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Control Buttons
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _controller.isRunning
                                ? null
                                : () {
                                    if (mounted) _controller.start();
                                  },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Start'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _controller.isRunning
                                ? () {
                                    if (mounted) _controller.stop();
                                  }
                                : null,
                            icon: const Icon(Icons.pause),
                            label: const Text('Stop'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _controller.isRunning
                                ? () {
                                    if (mounted) _controller.skip();
                                  }
                                : null,
                            icon: const Icon(Icons.skip_next),
                            label: const Text('Skip'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (mounted) _controller.reset();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Loader Display
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'Fake Loader',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 120,
                        child: FakeLoader(
                          controller: _controller,
                          messages: _messageSets[_selectedMessageSet],
                          messageDuration: const Duration(seconds: 2),
                          randomOrder: _randomOrder,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          spinner: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          autoStart: false,
                          onComplete: () {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Loading completed! 🎉'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Status Info
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ListenableBuilder(
                        listenable: _controller,
                        builder: (context, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Running: ${_controller.isRunning}'),
                              Text('Completed: ${_controller.isCompleted}'),
                              Text(
                                'Current Message Index: ${_controller.currentMessageIndex}',
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Overlay Demo Tab
class OverlayDemoTab extends StatefulWidget {
  const OverlayDemoTab({super.key});

  @override
  State<OverlayDemoTab> createState() => _OverlayDemoTabState();
}

class _OverlayDemoTabState extends State<OverlayDemoTab> {
  bool _showOverlay = false;
  String _lastResult = '';
  int _selectedDuration = 3;

  final List<String> _messages = [
    "Fetching your data...",
    "Organizing information...",
    "Almost ready...",
    "Finalizing results...",
  ];

  Future<String> _simulateAsyncOperation() async {
    await Future.delayed(Duration(seconds: _selectedDuration));
    return 'Data loaded successfully!';
  }

  void _startOverlay() {
    setState(() {
      _showOverlay = true;
      _lastResult = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showOverlay) {
      return FakeLoadingOverlay<String>(
        future: _simulateAsyncOperation(),
        messages: _messages,
        onComplete: (data) {
          if (mounted) {
            setState(() {
              _showOverlay = false;
              _lastResult = data;
            });
          }
        },
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        spinner: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: _buildMainContent(),
      );
    }

    return _buildMainContent();
  }

  Widget _buildMainContent() {
    return Scaffold(
      appBar: AppBar(title: const Text('Overlay Demo'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FakeLoadingOverlay Demo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This demonstrates the FakeLoadingOverlay widget that wraps real async operations. '
                        'It shows fake loading messages while your actual Future executes in the background.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Configuration
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuration',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),

                      // Duration Selection
                      Text(
                        'Duration: ${_selectedDuration}s',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 2, label: Text('2s')),
                          ButtonSegment(value: 3, label: Text('3s')),
                          ButtonSegment(value: 5, label: Text('5s')),
                        ],
                        selected: {_selectedDuration},
                        onSelectionChanged: (Set<int> selection) {
                          setState(() {
                            _selectedDuration = selection.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Try It Out',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _startOverlay,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start Loading Demo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Result Display
            if (_lastResult.isNotEmpty) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Result',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(_lastResult)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Styles Tab
class StylesTab extends StatefulWidget {
  const StylesTab({super.key});

  @override
  State<StylesTab> createState() => _StylesTabState();
}

class _StylesTabState extends State<StylesTab> {
  final FakeLoaderController _controller = FakeLoaderController();

  double _fontSize = 18.0;
  FontWeight _fontWeight = FontWeight.normal;
  FontStyle _fontStyle = FontStyle.normal;
  Color _textColor = Colors.blue;

  final List<String> _messages = [
    "Customizing your experience...",
    "Applying beautiful styles...",
    "Making it look awesome...",
    "Almost perfect!",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Styles'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Custom Styles Demo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Customize the appearance of your fake loader with different fonts, colors, and styles.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Style Controls
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Text Styles',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),

                      // Font Size
                      Text('Font Size: ${_fontSize.round()}px'),
                      Slider(
                        value: _fontSize,
                        min: 12.0,
                        max: 32.0,
                        divisions: 20,
                        onChanged: (value) {
                          setState(() {
                            _fontSize = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Font Weight
                      const Text('Font Weight:'),
                      const SizedBox(height: 8),
                      SegmentedButton<FontWeight>(
                        segments: const [
                          ButtonSegment(
                            value: FontWeight.normal,
                            label: Text(
                              'Normal',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          ButtonSegment(
                            value: FontWeight.bold,
                            label: Text('Bold', style: TextStyle(fontSize: 12)),
                          ),
                          ButtonSegment(
                            value: FontWeight.w300,
                            label: Text(
                              'Light',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                        selected: {_fontWeight},
                        onSelectionChanged: (Set<FontWeight> selection) {
                          setState(() {
                            _fontWeight = selection.first;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Font Style
                      SwitchListTile(
                        title: const Text('Italic'),
                        value: _fontStyle == FontStyle.italic,
                        onChanged: (value) {
                          setState(() {
                            _fontStyle = value
                                ? FontStyle.italic
                                : FontStyle.normal;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Text Color
                      const Text('Text Color:'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            [
                              Colors.blue,
                              Colors.green,
                              Colors.red,
                              Colors.purple,
                              Colors.orange,
                              Colors.teal,
                            ].map((color) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _textColor = color;
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: _textColor == color
                                        ? Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          )
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Preview
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'Preview',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 150,
                        child: FakeLoader(
                          controller: _controller,
                          messages: _messages,
                          messageDuration: const Duration(seconds: 2),
                          textStyle: TextStyle(
                            fontSize: _fontSize,
                            fontWeight: _fontWeight,
                            fontStyle: _fontStyle,
                            color: _textColor,
                          ),
                          spinner: CircularProgressIndicator(color: _textColor),
                          autoStart: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Control Buttons
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Controls',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _controller.isRunning
                                ? null
                                : () {
                                    if (mounted) _controller.start();
                                  },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Start'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _controller.isRunning
                                ? () {
                                    if (mounted) _controller.stop();
                                  }
                                : null,
                            icon: const Icon(Icons.pause),
                            label: const Text('Stop'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (mounted) _controller.reset();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

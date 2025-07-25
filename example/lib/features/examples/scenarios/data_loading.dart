import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../core/widgets/demo_card.dart';
import '../../../core/widgets/code_display.dart';

/// Data loading scenarios with real async operations and error handling
class DataLoadingExample extends StatefulWidget {
  const DataLoadingExample({super.key});

  @override
  State<DataLoadingExample> createState() => _DataLoadingExampleState();
}

class _DataLoadingExampleState extends State<DataLoadingExample> {
  final List<String> _loadedData = [];
  String? _errorMessage;
  bool _isLoading = false;
  int _selectedScenario = 0;

  final List<String> _scenarios = [
    'API Call',
    'Database Query',
    'File Upload',
    'File Download',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemoCard(
          title: 'Data Loading Scenarios',
          description:
              'Real async operations with loading states and error handling',
          child: Column(
            children: [
              _buildScenarioSelector(),
              const SizedBox(height: 16),
              _buildLoadingDemo(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCodeExample(),
      ],
    );
  }

  Widget _buildScenarioSelector() {
    return Row(
      children: [
        Expanded(
          child: SegmentedButton<int>(
            segments: _scenarios.asMap().entries.map((entry) {
              return ButtonSegment<int>(
                value: entry.key,
                label: Text(entry.value),
                icon: _getScenarioIcon(entry.key),
              );
            }).toList(),
            selected: {_selectedScenario},
            onSelectionChanged: (Set<int> selection) {
              setState(() {
                _selectedScenario = selection.first;
                _loadedData.clear();
                _errorMessage = null;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingDemo() {
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
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _getScenarioIcon(_selectedScenario),
                const SizedBox(width: 8),
                Text(
                  '${_scenarios[_selectedScenario]} Demo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (!_isLoading)
                  ElevatedButton.icon(
                    onPressed: _startDataLoading,
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text('Start'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: _isLoading ? _buildLoadingState() : _buildResultState(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return FakeLoadingOverlay<List<String>>(
      future: _simulateDataOperation(),
      messages: _getScenarioMessages(),
      onComplete: _onLoadingComplete,
      onError: _onLoadingError,
      child: Container(), // This won't be shown during loading
    );
  }

  Widget _buildResultState() {
    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_loadedData.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSuccessState();
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getScenarioIcon(_selectedScenario).icon,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Ready to load ${_scenarios[_selectedScenario].toLowerCase()} data',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Click "Start" to begin the loading process',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Loading completed successfully!',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _loadedData.clear();
                    _errorMessage = null;
                  });
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _loadedData.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    title: Text(_loadedData[index]),
                    subtitle: Text(
                      'Loaded at ${DateTime.now().toString().substring(11, 19)}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading Failed',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _startDataLoading,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _loadedData.clear();
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
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
// Data loading with FakeLoadingOverlay
class DataLoadingScreen extends StatefulWidget {
  @override
  _DataLoadingScreenState createState() => _DataLoadingScreenState();
}

class _DataLoadingScreenState extends State<DataLoadingScreen> {
  List<String> _data = [];
  bool _isLoading = false;

  Future<List<String>> _loadData() async {
    // Simulate API call or database query
    await Future.delayed(Duration(seconds: 3));
    
    // Simulate potential error (20% chance)
    if (Random().nextDouble() < 0.2) {
      throw Exception('Network error occurred');
    }
    
    return List.generate(10, (i) => 'Data item \${i + 1}');
  }

  void _startLoading() {
    setState(() => _isLoading = true);
  }

  void _onLoadingComplete(List<String> result) {
    setState(() {
      _data = result;
      _isLoading = false;
    });
  }

  void _onLoadingError(dynamic error) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: \$error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FakeLoadingOverlay<List<String>>(
      future: _loadData(),
      messages: [
        'Connecting to server...',
        'Fetching data...',
        'Processing response...',
      ],
      onComplete: _onLoadingComplete,
      onError: _onLoadingError,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _isLoading ? null : _startLoading,
            child: Text('Load Data'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_data[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}''',
        language: 'dart',
      ),
    );
  }

  Icon _getScenarioIcon(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.api);
      case 1:
        return const Icon(Icons.storage);
      case 2:
        return const Icon(Icons.upload);
      case 3:
        return const Icon(Icons.download);
      default:
        return const Icon(Icons.data_usage);
    }
  }

  List<String> _getScenarioMessages() {
    switch (_selectedScenario) {
      case 0: // API Call
        return [
          'Connecting to server...',
          'Authenticating request...',
          'Fetching data...',
          'Processing response...',
          'Validating data...',
        ];
      case 1: // Database Query
        return [
          'Opening database connection...',
          'Executing query...',
          'Processing results...',
          'Optimizing data...',
          'Finalizing results...',
        ];
      case 2: // File Upload
        return [
          'Preparing file...',
          'Compressing data...',
          'Uploading to server...',
          'Verifying upload...',
          'Processing complete...',
        ];
      case 3: // File Download
        return [
          'Locating file...',
          'Initiating download...',
          'Downloading data...',
          'Verifying integrity...',
          'Saving to device...',
        ];
      default:
        return ['Processing...'];
    }
  }

  void _startDataLoading() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _loadedData.clear();
    });
  }

  Future<List<String>> _simulateDataOperation() async {
    final duration = Duration(seconds: _getScenarioDuration());
    await Future.delayed(duration);

    // Simulate potential error (20% chance)
    if (Random().nextDouble() < 0.2) {
      throw Exception(_getErrorMessage());
    }

    // Generate mock data based on scenario
    return _generateMockData();
  }

  int _getScenarioDuration() {
    switch (_selectedScenario) {
      case 0: // API Call
        return 4;
      case 1: // Database Query
        return 3;
      case 2: // File Upload
        return 6;
      case 3: // File Download
        return 5;
      default:
        return 3;
    }
  }

  String _getErrorMessage() {
    switch (_selectedScenario) {
      case 0:
        return 'Network timeout - Unable to reach server';
      case 1:
        return 'Database connection failed - Please try again';
      case 2:
        return 'Upload failed - File size too large';
      case 3:
        return 'Download failed - File not found on server';
      default:
        return 'An unexpected error occurred';
    }
  }

  List<String> _generateMockData() {
    switch (_selectedScenario) {
      case 0: // API Call
        return List.generate(
          8,
          (i) => 'API Record ${i + 1}: User data from server',
        );
      case 1: // Database Query
        return List.generate(
          12,
          (i) => 'DB Row ${i + 1}: Query result from database',
        );
      case 2: // File Upload
        return [
          'Upload successful: document.pdf (2.4 MB)',
          'File ID: ${Random().nextInt(10000)}',
          'Server location: /uploads/documents/',
        ];
      case 3: // File Download
        return [
          'Download complete: report.xlsx (1.8 MB)',
          'Saved to: Downloads folder',
          'Verification: Checksum verified',
        ];
      default:
        return ['Operation completed successfully'];
    }
  }

  void _onLoadingComplete(List<String> result) {
    setState(() {
      _loadedData.addAll(result);
      _isLoading = false;
    });
  }

  void _onLoadingError(dynamic error) {
    setState(() {
      _isLoading = false;
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    });
  }
}

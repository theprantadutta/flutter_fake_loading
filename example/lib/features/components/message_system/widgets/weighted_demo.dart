import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/demo_card.dart';
import '../../../../core/utils/code_generator.dart';
import 'dart:math' as math;

/// Widget that demonstrates weighted message selection
class WeightedMessageDemo extends StatefulWidget {
  const WeightedMessageDemo({super.key});

  @override
  State<WeightedMessageDemo> createState() => _WeightedMessageDemoState();
}

class _WeightedMessageDemoState extends State<WeightedMessageDemo> {
  final FakeLoaderController _controller = FakeLoaderController();
  final Map<String, double> _messageFrequency = {};
  int _totalSelections = 0;

  // Weighted messages configuration
  final List<Map<String, dynamic>> _weightedMessages = [
    {'text': 'Common message (high weight)', 'weight': 5.0},
    {'text': 'Moderate message', 'weight': 2.0},
    {'text': 'Rare message (low weight)', 'weight': 0.5},
    {'text': 'Easter egg! 🎉', 'weight': 0.1},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Introduction
          DemoCard(
            title: 'Weighted Message Selection',
            description:
                'Control message probability with weights for dynamic loading experiences.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weighted message selection allows you to control how often different messages appear. '
                  'Messages with higher weights are more likely to be selected, while lower weights create rare "easter eggs".',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Weights are relative - a message with weight 2.0 is twice as likely to appear as one with weight 1.0.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Interactive Weight Controls
          _buildWeightControls(),

          const SizedBox(height: 24),

          // Live Demo
          _buildLiveDemo(),

          const SizedBox(height: 24),

          // Probability Visualization
          _buildProbabilityVisualization(),

          const SizedBox(height: 24),

          // Frequency Analysis
          _buildFrequencyAnalysis(),

          const SizedBox(height: 24),

          // Rare Message Showcase
          _buildRareMessageShowcase(),
        ],
      ),
    );
  }

  Widget _buildWeightControls() {
    return DemoCard(
      title: 'Interactive Weight Adjustment',
      description:
          'Adjust message weights and see the probability changes in real-time',
      showCode: true,
      codeSnippet: CodeGenerator.generateWeightedMessageCode(_weightedMessages),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Adjust the weights below to see how they affect message selection probability:',
          ),
          const SizedBox(height: 16),

          ..._weightedMessages.asMap().entries.map((entry) {
            final index = entry.key;
            final message = entry.value;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['text'],
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Text('Weight: '),
                        Expanded(
                          child: Slider(
                            value: message['weight'],
                            min: 0.1,
                            max: 10.0,
                            divisions: 99,
                            label: message['weight'].toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                _weightedMessages[index]['weight'] = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            message['weight'].toStringAsFixed(1),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    // Show calculated probability
                    Text(
                      'Probability: ${_calculateProbability(message['weight']).toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Reset button
          ElevatedButton.icon(
            onPressed: _resetWeights,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset to Defaults'),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveDemo() {
    return DemoCard(
      title: 'Live Weighted Selection Demo',
      description: 'See weighted message selection in action',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Demo area
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: FakeLoader(
              controller: _controller,
              messages: _weightedMessages
                  .map((m) => FakeMessage.weighted(m['text'], m['weight']))
                  .toList(),
              messageDuration: const Duration(seconds: 1),
              randomOrder: true,
              autoStart: false,
              textStyle: const TextStyle(fontSize: 16),
              spinner: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onMessageChanged: (message, index) {
                // Track message frequency
                setState(() {
                  _messageFrequency[message] =
                      (_messageFrequency[message] ?? 0) + 1;
                  _totalSelections++;
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // Controls
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _controller.isRunning
                    ? null
                    : () => _controller.start(),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Start Demo'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _controller.isRunning
                    ? () => _controller.stop()
                    : null,
                icon: const Icon(Icons.pause, size: 18),
                label: const Text('Stop'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {
                  _controller.reset();
                  setState(() {
                    _messageFrequency.clear();
                    _totalSelections = 0;
                  });
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProbabilityVisualization() {
    final totalWeight = _weightedMessages.fold<double>(
      0.0,
      (sum, message) => sum + message['weight'],
    );

    return DemoCard(
      title: 'Probability Visualization',
      description: 'Visual representation of message selection probabilities',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current probability distribution:'),
          const SizedBox(height: 16),

          ..._weightedMessages.map((message) {
            final probability = (message['weight'] / totalWeight) * 100;
            final color = _getColorForProbability(probability);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message['text'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        '${probability.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: probability / 100,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),

          // Statistics
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistics',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text('Total Weight: ${totalWeight.toStringAsFixed(1)}'),
                Text(
                  'Highest Probability: ${_getHighestProbability().toStringAsFixed(1)}%',
                ),
                Text(
                  'Lowest Probability: ${_getLowestProbability().toStringAsFixed(1)}%',
                ),
                Text(
                  'Probability Ratio: ${(_getHighestProbability() / _getLowestProbability()).toStringAsFixed(1)}:1',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyAnalysis() {
    if (_totalSelections == 0) {
      return DemoCard(
        title: 'Message Frequency Analysis',
        description: 'Run the demo to see actual vs expected frequency',
        child: const Text(
          'Start the demo above to collect frequency data and see how actual selection matches expected probabilities.',
        ),
      );
    }

    return DemoCard(
      title: 'Message Frequency Analysis',
      description:
          'Actual vs expected frequency after $_totalSelections selections',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total selections: $_totalSelections',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),

          ..._weightedMessages.map((message) {
            final text = message['text'];
            final actualCount = _messageFrequency[text] ?? 0;
            final actualPercentage = _totalSelections > 0
                ? (actualCount / _totalSelections) * 100
                : 0.0;
            final expectedPercentage = _calculateProbability(message['weight']);
            final difference = actualPercentage - expectedPercentage;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expected: ${expectedPercentage.toStringAsFixed(1)}%',
                              ),
                              Text(
                                'Actual: ${actualPercentage.toStringAsFixed(1)}%',
                              ),
                              Text(
                                'Difference: ${difference >= 0 ? '+' : ''}${difference.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: difference.abs() < 5
                                      ? Colors.green
                                      : difference.abs() < 10
                                      ? Colors.orange
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$actualCount',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Accuracy indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getAccuracyColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _getAccuracyColor()),
            ),
            child: Row(
              children: [
                Icon(_getAccuracyIcon(), color: _getAccuracyColor()),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getAccuracyMessage(),
                    style: TextStyle(color: _getAccuracyColor()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRareMessageShowcase() {
    final rareMessages = _weightedMessages
        .where((m) => m['weight'] < 1.0)
        .toList();

    return DemoCard(
      title: 'Rare Messages & Easter Eggs',
      description: 'Demonstrate low-probability messages for special moments',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rare messages with low weights create delightful surprises for users. '
            'They appear infrequently, making them feel special when they do show up.',
          ),
          const SizedBox(height: 16),

          if (rareMessages.isNotEmpty) ...[
            Text(
              'Current rare messages (weight < 1.0):',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),

            ...rareMessages.map((message) {
              final probability = _calculateProbability(message['weight']);
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(Icons.star, color: Colors.amber),
                  title: Text(message['text']),
                  subtitle: Text('${probability.toStringAsFixed(1)}% chance'),
                  trailing: Chip(
                    label: Text('${message['weight']}x'),
                    backgroundColor: Colors.amber.withOpacity(0.2),
                  ),
                ),
              );
            }),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'No rare messages currently configured. Try reducing some message weights below 1.0 to create easter eggs!',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Force rare message button
          ElevatedButton.icon(
            onPressed: () => _showRareMessageDemo(),
            icon: const Icon(Icons.casino),
            label: const Text('Force Show Rare Messages'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateProbability(double weight) {
    final totalWeight = _weightedMessages.fold<double>(
      0.0,
      (sum, message) => sum + message['weight'],
    );
    return (weight / totalWeight) * 100;
  }

  Color _getColorForProbability(double probability) {
    if (probability > 40) return Colors.green;
    if (probability > 20) return Colors.blue;
    if (probability > 10) return Colors.orange;
    return Colors.red;
  }

  double _getHighestProbability() {
    return _weightedMessages
        .map((m) => _calculateProbability(m['weight']))
        .reduce(math.max);
  }

  double _getLowestProbability() {
    return _weightedMessages
        .map((m) => _calculateProbability(m['weight']))
        .reduce(math.min);
  }

  Color _getAccuracyColor() {
    if (_totalSelections < 10) return Colors.grey;

    final avgDifference =
        _weightedMessages
            .map((message) {
              final text = message['text'];
              final actualCount = _messageFrequency[text] ?? 0;
              final actualPercentage = (actualCount / _totalSelections) * 100;
              final expectedPercentage = _calculateProbability(
                message['weight'],
              );
              return (actualPercentage - expectedPercentage).abs();
            })
            .reduce((a, b) => a + b) /
        _weightedMessages.length;

    if (avgDifference < 5) return Colors.green;
    if (avgDifference < 10) return Colors.orange;
    return Colors.red;
  }

  IconData _getAccuracyIcon() {
    if (_totalSelections < 10) return Icons.info;

    final color = _getAccuracyColor();
    if (color == Colors.green) return Icons.check_circle;
    if (color == Colors.orange) return Icons.warning;
    return Icons.error;
  }

  String _getAccuracyMessage() {
    if (_totalSelections < 10) {
      return 'Run more selections for better accuracy analysis';
    }

    final color = _getAccuracyColor();
    if (color == Colors.green) {
      return 'Excellent! Actual frequencies closely match expected probabilities';
    }
    if (color == Colors.orange) {
      return 'Good accuracy. Small deviations are normal with limited samples';
    }
    return 'Large deviations detected. This is normal with small sample sizes';
  }

  void _resetWeights() {
    setState(() {
      _weightedMessages[0]['weight'] = 5.0;
      _weightedMessages[1]['weight'] = 2.0;
      _weightedMessages[2]['weight'] = 0.5;
      _weightedMessages[3]['weight'] = 0.1;
    });
  }

  void _showRareMessageDemo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rare Message Demo'),
        content: SizedBox(
          width: 300,
          height: 200,
          child: Column(
            children: [
              const Text(
                'Here are all the rare messages in sequence:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FakeLoader(
                  messages: _weightedMessages
                      .where((m) => m['weight'] < 1.0)
                      .map((m) => m['text'] as String)
                      .toList(),
                  messageDuration: const Duration(seconds: 2),
                  autoStart: true,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
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
}

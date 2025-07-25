import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/code_generator.dart';

/// Demonstrates FakeLoadingOverlay with various async operation types
class AsyncOperationDemo extends StatefulWidget {
  const AsyncOperationDemo({super.key});

  @override
  State<AsyncOperationDemo> createState() => _AsyncOperationDemoState();
}

class _AsyncOperationDemoState extends State<AsyncOperationDemo> {
  String? _apiResult;
  String? _fileResult;
  String? _errorResult;
  String? _timeoutResult;
  bool _showApiDemo = false;
  bool _showFileDemo = false;
  bool _showErrorDemo = false;
  bool _showTimeoutDemo = false;

  // Simulated API call
  Future<Map<String, dynamic>> _simulateApiCall() async {
    await Future.delayed(Duration(seconds: 2 + Random().nextInt(3)));
    return {
      'status': 'success',
      'data': {
        'users': List.generate(5, (i) => 'User ${i + 1}'),
        'timestamp': DateTime.now().toIso8601String(),
      },
    };
  }

  // Simulated file loading
  Future<String> _simulateFileLoading() async {
    await Future.delayed(Duration(seconds: 1 + Random().nextInt(2)));
    return 'File content loaded successfully!\n'
        'Size: ${Random().nextInt(1000) + 100} KB\n'
        'Modified: ${DateTime.now().toString()}';
  }

  // Simulated operation that fails
  Future<String> _simulateErrorOperation() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('Network connection failed');
  }

  // Simulated operation with timeout
  Future<String> _simulateTimeoutOperation() async {
    await Future.delayed(const Duration(seconds: 10)); // Will timeout
    return 'This should not be reached';
  }

  void _resetResults() {
    setState(() {
      _apiResult = null;
      _fileResult = null;
      _errorResult = null;
      _timeoutResult = null;
      _showApiDemo = false;
      _showFileDemo = false;
      _showErrorDemo = false;
      _showTimeoutDemo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // API Call Demo
        DemoCard(
          title: 'API Call Simulation',
          description: 'Demonstrates loading overlay during API requests',
          child: Column(
            children: [
              if (!_showApiDemo && _apiResult == null)
                ElevatedButton(
                  onPressed: () => setState(() => _showApiDemo = true),
                  child: const Text('Start API Call'),
                ),
              if (_showApiDemo)
                SizedBox(
                  height: 200,
                  child: FakeLoadingOverlay<Map<String, dynamic>>(
                    future: _simulateApiCall(),
                    messages: FakeMessagePack.techStartup,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    onComplete: (data) {
                      setState(() {
                        _apiResult = const JsonEncoder.withIndent(
                          '  ',
                        ).convert(data);
                        _showApiDemo = false;
                      });
                    },
                    child: Container(),
                  ),
                ),
              if (_apiResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'API Response:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _apiResult!,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          codeSnippet: CodeGenerator.generateFakeLoadingOverlayCode(
            futureType: 'Map<String, dynamic>',
            messages: 'FakeMessagePack.techStartup',
            onComplete: 'onComplete: (data) => handleApiResponse(data)',
          ),
        ),
        const SizedBox(height: 16),

        // File Loading Demo
        DemoCard(
          title: 'File Loading Simulation',
          description: 'Shows overlay during file operations',
          child: Column(
            children: [
              if (!_showFileDemo && _fileResult == null)
                ElevatedButton(
                  onPressed: () => setState(() => _showFileDemo = true),
                  child: const Text('Load File'),
                ),
              if (_showFileDemo)
                SizedBox(
                  height: 200,
                  child: FakeLoadingOverlay<String>(
                    future: _simulateFileLoading(),
                    messages: const [
                      'Reading file headers...',
                      'Parsing content...',
                      'Validating data...',
                      'Almost done...',
                    ],
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    onComplete: (data) {
                      setState(() {
                        _fileResult = data;
                        _showFileDemo = false;
                      });
                    },
                    child: Container(),
                  ),
                ),
              if (_fileResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'File Content:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_fileResult!),
                    ],
                  ),
                ),
              ],
            ],
          ),
          codeSnippet: CodeGenerator.generateFakeLoadingOverlayCode(
            futureType: 'String',
            messages: '''[
  'Reading file headers...',
  'Parsing content...',
  'Validating data...',
  'Almost done...',
]''',
            onComplete: 'onComplete: (content) => displayFileContent(content)',
          ),
        ),
        const SizedBox(height: 16),

        // Error Handling Demo
        DemoCard(
          title: 'Error Handling',
          description: 'Demonstrates error recovery and user feedback',
          child: Column(
            children: [
              if (!_showErrorDemo && _errorResult == null)
                ElevatedButton(
                  onPressed: () => setState(() => _showErrorDemo = true),
                  child: const Text('Trigger Error'),
                ),
              if (_showErrorDemo)
                SizedBox(
                  height: 200,
                  child: FakeLoadingOverlay<String>(
                    future: _simulateErrorOperation(),
                    messages: const [
                      'Connecting to server...',
                      'Authenticating...',
                      'Fetching data...',
                    ],
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    errorBuilder: (error) => Container(
                      padding: const EdgeInsets.all(16),
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
                            'Operation Failed',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => setState(() {
                              _showErrorDemo = false;
                              _errorResult = 'Error handled gracefully';
                            }),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                    onError: (error) {
                      // Error is handled by errorBuilder
                    },
                    child: Container(),
                  ),
                ),
              if (_errorResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                  ),
                  child: Text(_errorResult!),
                ),
              ],
            ],
          ),
          codeSnippet: CodeGenerator.generateFakeLoadingOverlayCode(
            futureType: 'String',
            messages: '''[
  'Connecting to server...',
  'Authenticating...',
  'Fetching data...',
]''',
            errorBuilder: '''errorBuilder: (error) => ErrorWidget(
  error: error,
  onRetry: () => retryOperation(),
)''',
            onError: 'onError: (error) => logError(error)',
          ),
        ),
        const SizedBox(height: 16),

        // Timeout Demo
        DemoCard(
          title: 'Timeout Handling',
          description: 'Shows timeout behavior and cancellation',
          child: Column(
            children: [
              if (!_showTimeoutDemo && _timeoutResult == null)
                ElevatedButton(
                  onPressed: () => setState(() => _showTimeoutDemo = true),
                  child: const Text('Start with Timeout'),
                ),
              if (_showTimeoutDemo)
                SizedBox(
                  height: 200,
                  child: FakeLoadingOverlay<String>(
                    future: _simulateTimeoutOperation().timeout(
                      const Duration(seconds: 4),
                      onTimeout: () => throw TimeoutException(
                        'Operation timed out',
                        const Duration(seconds: 4),
                      ),
                    ),
                    messages: const [
                      'Starting long operation...',
                      'This might take a while...',
                      'Still working...',
                      'Please wait...',
                    ],
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    errorBuilder: (error) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer_off,
                            size: 48,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Operation Timed Out',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'The operation took too long to complete',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => setState(() {
                              _showTimeoutDemo = false;
                              _timeoutResult = 'Timeout handled';
                            }),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                    child: Container(),
                  ),
                ),
              if (_timeoutResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Text(_timeoutResult!),
                ),
              ],
            ],
          ),
          codeSnippet: CodeGenerator.generateFakeLoadingOverlayCode(
            futureType: 'String',
            future: '''longOperation().timeout(
  Duration(seconds: 30),
  onTimeout: () => throw TimeoutException('Timed out'),
)''',
            messages: '''[
  'Starting long operation...',
  'This might take a while...',
  'Still working...',
  'Please wait...',
]''',
            errorBuilder: 'errorBuilder: (error) => TimeoutErrorWidget(error)',
          ),
        ),
        const SizedBox(height: 24),

        // Reset button
        ElevatedButton(
          onPressed: _resetResults,
          child: const Text('Reset All Demos'),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/code_generator.dart';

/// Demonstrates FakeLoadingOverlay integration scenarios
class IntegrationScenariosDemo extends StatefulWidget {
  const IntegrationScenariosDemo({super.key});

  @override
  State<IntegrationScenariosDemo> createState() =>
      _IntegrationScenariosDemoState();
}

class _IntegrationScenariosDemoState extends State<IntegrationScenariosDemo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _showNavigationDemo = false;
  bool _showFormDemo = false;
  bool _showRefreshDemo = false;
  bool _showMultiStepDemo = false;

  String? _navigationResult;
  String? _formResult;
  List<String> _refreshData = ['Item 1', 'Item 2', 'Item 3'];
  int _currentStep = 0;
  String? _multiStepResult;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Simulated navigation operation
  Future<String> _simulateNavigation() async {
    await Future.delayed(Duration(seconds: 2 + Random().nextInt(2)));
    return 'Navigation completed successfully';
  }

  // Simulated form submission
  Future<Map<String, String>> _simulateFormSubmission() async {
    await Future.delayed(Duration(seconds: 1 + Random().nextInt(2)));
    return {
      'status': 'success',
      'message': 'Form submitted successfully',
      'id': Random().nextInt(1000).toString(),
    };
  }

  // Simulated data refresh
  Future<List<String>> _simulateDataRefresh() async {
    await Future.delayed(Duration(seconds: 1 + Random().nextInt(2)));
    return List.generate(
      5 + Random().nextInt(5),
      (i) => 'Refreshed Item ${i + 1}',
    );
  }

  // Simulated multi-step process
  Future<String> _simulateMultiStepProcess() async {
    final steps = [
      'Validating input...',
      'Processing data...',
      'Saving to database...',
      'Sending notifications...',
      'Finalizing...',
    ];

    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _currentStep = i + 1);
      }
    }

    return 'Multi-step process completed';
  }

  void _resetDemos() {
    setState(() {
      _showNavigationDemo = false;
      _showFormDemo = false;
      _showRefreshDemo = false;
      _showMultiStepDemo = false;
      _navigationResult = null;
      _formResult = null;
      _refreshData = ['Item 1', 'Item 2', 'Item 3'];
      _currentStep = 0;
      _multiStepResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Navigation Flow Demo
        DemoCard(
          title: 'Navigation Flow Integration',
          description: 'Loading overlay during navigation transitions',
          child: Column(
            children: [
              if (!_showNavigationDemo && _navigationResult == null)
                ElevatedButton(
                  onPressed: () => setState(() => _showNavigationDemo = true),
                  child: const Text('Navigate with Loading'),
                ),
              if (_showNavigationDemo)
                SizedBox(
                  height: 200,
                  child: FakeLoadingOverlay<String>(
                    future: _simulateNavigation(),
                    messages: const [
                      'Preparing navigation...',
                      'Loading destination...',
                      'Setting up context...',
                      'Almost ready...',
                    ],
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    onComplete: (result) {
                      setState(() {
                        _navigationResult = result;
                        _showNavigationDemo = false;
                      });
                    },
                    child: Container(),
                  ),
                ),
              if (_navigationResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(_navigationResult!),
                    ],
                  ),
                ),
              ],
            ],
          ),
          codeSnippet: CodeGenerator.generateFakeLoadingOverlayCode(
            futureType: 'String',
            messages: '''[
  'Preparing navigation...',
  'Loading destination...',
  'Setting up context...',
  'Almost ready...',
]''',
            onComplete: '''onComplete: (result) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => NextScreen()),
  );
}''',
          ),
        ),
        const SizedBox(height: 16),

        // Form Submission Demo
        DemoCard(
          title: 'Form Submission with Loading',
          description: 'Overlay during form processing and validation',
          child: Column(
            children: [
              if (!_showFormDemo && _formResult == null) ...[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your email';
                          }
                          if (!value!.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _showFormDemo = true);
                          }
                        },
                        child: const Text('Submit Form'),
                      ),
                    ],
                  ),
                ),
              ],
              if (_showFormDemo)
                SizedBox(
                  height: 200,
                  child: FakeLoadingOverlay<Map<String, String>>(
                    future: _simulateFormSubmission(),
                    messages: const [
                      'Validating form data...',
                      'Checking for duplicates...',
                      'Saving to database...',
                      'Sending confirmation...',
                    ],
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    onComplete: (result) {
                      setState(() {
                        _formResult =
                            '${result['message']} (ID: ${result['id']})';
                        _showFormDemo = false;
                      });
                    },
                    child: Container(),
                  ),
                ),
              if (_formResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.send, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_formResult!)),
                    ],
                  ),
                ),
              ],
            ],
          ),
          codeSnippet: CodeGenerator.generateFakeLoadingOverlayCode(
            futureType: 'Map<String, String>',
            messages: '''[
  'Validating form data...',
  'Checking for duplicates...',
  'Saving to database...',
  'Sending confirmation...',
]''',
            onComplete: '''onComplete: (result) {
  showSuccessDialog(result['message']);
  _formKey.currentState?.reset();
}''',
          ),
        ),
        const SizedBox(height: 16),

        // Data Refresh Demo
        DemoCard(
          title: 'Data Refresh Scenarios',
          description: 'Pull-to-refresh and data reload with overlay',
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _showRefreshDemo
                    ? FakeLoadingOverlay<List<String>>(
                        future: _simulateDataRefresh(),
                        messages: const [
                          'Fetching latest data...',
                          'Synchronizing...',
                          'Updating cache...',
                          'Almost done...',
                        ],
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        onComplete: (newData) {
                          setState(() {
                            _refreshData = newData;
                            _showRefreshDemo = false;
                          });
                        },
                        child: Container(),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: _refreshData.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text('${index + 1}'),
                                  ),
                                  title: Text(_refreshData[index]),
                                  subtitle: Text(
                                    'Updated: ${DateTime.now().toString().substring(11, 19)}',
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  setState(() => _showRefreshDemo = true),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refresh Data'),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
          codeSnippet: CodeGenerator.generateFakeLoadingOverlayCode(
            futureType: 'List<String>',
            messages: '''[
  'Fetching latest data...',
  'Synchronizing...',
  'Updating cache...',
  'Almost done...',
]''',
            onComplete: '''onComplete: (newData) {
  setState(() => _dataList = newData);
  _refreshController.refreshCompleted();
}''',
          ),
        ),
        const SizedBox(height: 16),

        // Multi-Step Process Demo
        DemoCard(
          title: 'Multi-Step Process',
          description: 'Complex workflows with progress tracking',
          child: Column(
            children: [
              if (!_showMultiStepDemo && _multiStepResult == null)
                ElevatedButton(
                  onPressed: () => setState(() => _showMultiStepDemo = true),
                  child: const Text('Start Multi-Step Process'),
                ),
              if (_showMultiStepDemo)
                SizedBox(
                  height: 250,
                  child: FakeLoadingOverlay<String>(
                    future: _simulateMultiStepProcess(),
                    messages: [
                      'Step 1: Validating input...',
                      'Step 2: Processing data...',
                      'Step 3: Saving to database...',
                      'Step 4: Sending notifications...',
                      'Step 5: Finalizing...',
                    ],
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    onComplete: (result) {
                      setState(() {
                        _multiStepResult = result;
                        _showMultiStepDemo = false;
                        _currentStep = 0;
                      });
                    },
                    child: Container(),
                  ),
                ),
              if (_showMultiStepDemo) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _currentStep / 5,
                  backgroundColor: Colors.grey.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 8),
                Text('Step $_currentStep of 5'),
              ],
              if (_multiStepResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.done_all, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(_multiStepResult!),
                    ],
                  ),
                ),
              ],
            ],
          ),
          codeSnippet: CodeGenerator.generateFakeLoadingOverlayCode(
            futureType: 'String',
            messages: '''[
  'Step 1: Validating input...',
  'Step 2: Processing data...',
  'Step 3: Saving to database...',
  'Step 4: Sending notifications...',
  'Step 5: Finalizing...',
]''',
            onComplete: '''onComplete: (result) {
  showCompletionDialog(result);
  resetWorkflow();
}''',
          ),
        ),
        const SizedBox(height: 24),

        // Reset button
        ElevatedButton(
          onPressed: _resetDemos,
          child: const Text('Reset All Demos'),
        ),
      ],
    );
  }
}

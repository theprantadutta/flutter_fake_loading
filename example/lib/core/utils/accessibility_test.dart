import 'package:flutter/material.dart';
import '../providers/accessibility_provider.dart';

/// Comprehensive accessibility testing utilities
class AccessibilityTest {
  /// Run a comprehensive accessibility test
  static void runAccessibilityTest(
    BuildContext context,
    AccessibilityProvider accessibility,
  ) {
    final results = _performAccessibilityChecks(accessibility);

    showDialog(
      context: context,
      builder: (context) => AccessibilityTestDialog(results: results),
    );
  }

  /// Perform all accessibility checks
  static List<AccessibilityTestResult> _performAccessibilityChecks(
    AccessibilityProvider accessibility,
  ) {
    return [
      AccessibilityTestResult(
        category: 'Screen Reader Support',
        tests: [
          AccessibilityCheck(
            'Screen reader support enabled',
            accessibility.screenReaderSupport,
            'Semantic labels and descriptions are provided',
          ),
          AccessibilityCheck(
            'Proper heading structure',
            accessibility.screenReaderSupport,
            'Headings are properly structured for navigation',
          ),
        ],
      ),
      AccessibilityTestResult(
        category: 'Keyboard Navigation',
        tests: [
          AccessibilityCheck(
            'Keyboard navigation enabled',
            accessibility.keyboardNavigation,
            'All interactive elements are keyboard accessible',
          ),
          AccessibilityCheck(
            'Focus indicators visible',
            accessibility.showFocusIndicators,
            'Visual focus indicators help keyboard users',
          ),
        ],
      ),
      AccessibilityTestResult(
        category: 'Visual Accessibility',
        tests: [
          AccessibilityCheck(
            'High contrast mode',
            accessibility.highContrast,
            'Enhanced contrast for better visibility',
          ),
          AccessibilityCheck(
            'Text scaling',
            accessibility.textScaleFactor > 1.0,
            'Text can be scaled for better readability',
          ),
          AccessibilityCheck(
            'Large text support',
            accessibility.largeText,
            'Large text mode is available',
          ),
        ],
      ),
      AccessibilityTestResult(
        category: 'Motion & Interaction',
        tests: [
          AccessibilityCheck(
            'Reduced motion',
            accessibility.reduceMotion,
            'Animations can be reduced for sensitive users',
          ),
          AccessibilityCheck(
            'Haptic feedback',
            accessibility.hapticFeedback,
            'Tactile feedback enhances interaction',
          ),
        ],
      ),
    ];
  }

  /// Get accessibility score (0-100)
  static int getAccessibilityScore(AccessibilityProvider accessibility) {
    final results = _performAccessibilityChecks(accessibility);
    int totalTests = 0;
    int passedTests = 0;

    for (final result in results) {
      for (final test in result.tests) {
        totalTests++;
        if (test.passed) passedTests++;
      }
    }

    return totalTests > 0 ? ((passedTests / totalTests) * 100).round() : 0;
  }

  /// Get accessibility recommendations
  static List<String> getRecommendations(AccessibilityProvider accessibility) {
    final recommendations = <String>[];

    if (!accessibility.screenReaderSupport) {
      recommendations.add(
        'Enable screen reader support for better accessibility',
      );
    }

    if (!accessibility.keyboardNavigation) {
      recommendations.add(
        'Enable keyboard navigation for users who cannot use a mouse',
      );
    }

    if (!accessibility.showFocusIndicators) {
      recommendations.add(
        'Show focus indicators to help keyboard users navigate',
      );
    }

    if (!accessibility.highContrast && accessibility.textScaleFactor <= 1.0) {
      recommendations.add(
        'Consider enabling high contrast or text scaling for better visibility',
      );
    }

    if (accessibility.reduceMotion && !accessibility.hapticFeedback) {
      recommendations.add(
        'Enable haptic feedback to provide alternative sensory feedback',
      );
    }

    if (recommendations.isEmpty) {
      recommendations.add(
        'Great! Your accessibility settings are well configured.',
      );
    }

    return recommendations;
  }
}

/// Result of an accessibility test category
class AccessibilityTestResult {
  final String category;
  final List<AccessibilityCheck> tests;

  AccessibilityTestResult({required this.category, required this.tests});

  bool get allPassed => tests.every((test) => test.passed);
  int get passedCount => tests.where((test) => test.passed).length;
  int get totalCount => tests.length;
}

/// Individual accessibility check
class AccessibilityCheck {
  final String name;
  final bool passed;
  final String description;

  AccessibilityCheck(this.name, this.passed, this.description);
}

/// Dialog to display accessibility test results
class AccessibilityTestDialog extends StatelessWidget {
  final List<AccessibilityTestResult> results;

  const AccessibilityTestDialog({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final totalTests = results.fold<int>(
      0,
      (sum, result) => sum + result.totalCount,
    );
    final passedTests = results.fold<int>(
      0,
      (sum, result) => sum + result.passedCount,
    );
    final score = totalTests > 0
        ? ((passedTests / totalTests) * 100).round()
        : 0;

    return AlertDialog(
      title: const Text('Accessibility Test Results'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Overall Score
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getScoreColor(score).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getScoreColor(score)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getScoreIcon(score),
                    color: _getScoreColor(score),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      Text(
                        'Accessibility Score',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '$score/100',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: _getScoreColor(score),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Test Results
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return ExpansionTile(
                    title: Text(result.category),
                    subtitle: Text(
                      '${result.passedCount}/${result.totalCount} passed',
                    ),
                    leading: Icon(
                      result.allPassed ? Icons.check_circle : Icons.warning,
                      color: result.allPassed ? Colors.green : Colors.orange,
                    ),
                    children: result.tests.map((test) {
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          test.passed ? Icons.check : Icons.close,
                          color: test.passed ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        title: Text(test.name),
                        subtitle: Text(test.description),
                      );
                    }).toList(),
                  );
                },
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
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getScoreIcon(int score) {
    if (score >= 80) return Icons.check_circle;
    if (score >= 60) return Icons.warning;
    return Icons.error;
  }
}

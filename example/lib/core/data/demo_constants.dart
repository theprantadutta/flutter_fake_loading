import 'package:flutter/material.dart';

/// App-wide constants for demo configurations and parameters
class DemoConstants {
  // Private constructor to prevent instantiation
  DemoConstants._();

  /// Default animation durations
  static const Duration shortDuration = Duration(milliseconds: 500);
  static const Duration mediumDuration = Duration(milliseconds: 1500);
  static const Duration longDuration = Duration(milliseconds: 3000);

  /// Default colors for demos
  static const List<Color> demoColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
  ];

  /// Default text styles for demos
  static const TextStyle smallTextStyle = TextStyle(fontSize: 12);
  static const TextStyle mediumTextStyle = TextStyle(fontSize: 16);
  static const TextStyle largeTextStyle = TextStyle(fontSize: 20);

  /// Demo card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: 24);

  /// Animation parameters
  static const int defaultMaxLoops = 3;
  static const double defaultStrokeWidth = 4.0;

  /// Code display settings
  static const double maxCodeHeight = 400.0;
  static const String defaultLanguage = 'dart';

  /// Property control ranges
  static const double minDuration = 100.0;
  static const double maxDuration = 10000.0;
  static const double minStrokeWidth = 1.0;
  static const double maxStrokeWidth = 10.0;
  static const int minLoops = 1;
  static const int maxLoops = 10;

  /// Demo categories
  static const List<String> demoCategories = [
    'Basic Loading',
    'Advanced Loading',
    'Text Effects',
    'Progress Indicators',
    'Overlays',
  ];

  /// Feature tags
  static const List<String> featureTags = [
    'Animation',
    'Customizable',
    'Interactive',
    'Responsive',
    'Themed',
  ];
}

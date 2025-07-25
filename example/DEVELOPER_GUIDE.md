# Developer Guide: Extending the Flutter Fake Loading Showcase

This guide provides detailed instructions for developers who want to extend, modify, or contribute to the Flutter Fake Loading Showcase application.

## 📋 Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Adding New Components](#adding-new-components)
3. [Creating Demo Screens](#creating-demo-screens)
4. [Extending the Playground](#extending-the-playground)
5. [Performance Optimization](#performance-optimization)
6. [Testing Guidelines](#testing-guidelines)
7. [Code Style and Standards](#code-style-and-standards)
8. [Deployment Process](#deployment-process)

## 🏗 Architecture Overview

### Core Principles

The showcase app follows these architectural principles:

- **Separation of Concerns** - Clear separation between UI, business logic, and data
- **Modularity** - Features are organized in self-contained modules
- **Reusability** - Common components are shared across features
- **Performance** - Optimized for smooth user experience
- **Accessibility** - Full accessibility support throughout

### Directory Structure

```
example/
├── lib/
│   ├── core/                    # Core utilities and shared components
│   │   ├── animations/          # Page transitions and animations
│   │   ├── services/           # App-wide services
│   │   ├── utils/              # Utility functions and helpers
│   │   └── widgets/            # Reusable UI components
│   ├── features/               # Feature-specific modules
│   │   ├── components/         # Component demonstrations
│   │   ├── playground/         # Interactive playground
│   │   ├── settings/           # App settings and preferences
│   │   └── showcase/           # Main showcase screens
│   └── showcase_app.dart       # Main app entry point
├── assets/                     # Static assets
└── test/                       # Test files
```

### Key Services

- **PreloaderService** - Manages app initialization and preloading
- **PerformanceService** - Monitors and optimizes app performance
- **MemoryManager** - Handles memory optimization and cleanup

## 🔧 Adding New Components

### Step 1: Create Component Demo

1. Create a new directory under `lib/features/components/`:

```dart
// lib/features/components/my_component/my_component_demo.dart
import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

class MyComponentDemo extends StatefulWidget {
  const MyComponentDemo({super.key});

  @override
  State<MyComponentDemo> createState() => _MyComponentDemoState();
}

class _MyComponentDemoState extends State<MyComponentDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Component Demo'),
      ),
      body: const Center(
        child: Text('Your component demo here'),
      ),
    );
  }
}
```

### Step 2: Add to Navigation

Update the main navigation to include your new component:

```dart
// Add to the appropriate navigation list
{
  'title': 'My Component',
  'subtitle': 'Description of your component',
  'route': '/my-component',
  'builder': (context) => const MyComponentDemo(),
}
```

### Step 3: Create Tests

```dart
// test/my_component_demo_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_loading_example/features/components/my_component/my_component_demo.dart';

void main() {
  group('MyComponentDemo', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyComponentDemo(),
        ),
      );

      expect(find.text('My Component Demo'), findsOneWidget);
    });
  });
}
```

## 🎮 Creating Demo Screens

### Demo Screen Template

Use this template for consistent demo screens:

```dart
import 'package:flutter/material.dart';
import '../../../core/widgets/demo_card.dart';
import '../../../core/widgets/section_header.dart';

class MyDemoScreen extends StatefulWidget {
  const MyDemoScreen({super.key});

  @override
  State<MyDemoScreen> createState() => _MyDemoScreenState();
}

class _MyDemoScreenState extends State<MyDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfo,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(
            title: 'Basic Usage',
            subtitle: 'Simple examples to get started',
          ),
          DemoCard(
            title: 'Basic Example',
            description: 'A simple demonstration',
            child: _buildBasicExample(),
            codeSnippet: '''
// Your code example here
''',
          ),
          // Add more demo cards...
        ],
      ),
    );
  }

  Widget _buildBasicExample() {
    // Your demo widget implementation
    return Container();
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About This Demo'),
        content: const Text('Information about your demo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
```

## 🛝 Extending the Playground

### Adding New Properties

To add new customizable properties to the playground:

1. **Update the Property Panel**:

```dart
// lib/features/playground/widgets/property_panel.dart
// Add your new property widget
Widget _buildMyProperty() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('My Property', style: theme.textTheme.titleSmall),
      Slider(
        value: myValue,
        min: 0,
        max: 100,
        onChanged: (value) {
          setState(() {
            myValue = value;
          });
          widget.onPropertyChanged();
        },
      ),
    ],
  );
}
```

2. **Update the Code Generator**:

```dart
// lib/core/utils/code_generator.dart
// Add your property to the code generation
String _generateMyProperty() {
  if (myValue != defaultValue) {
    return 'myProperty: $myValue,\n';
  }
  return '';
}
```

### Adding New Presets

```dart
// Add to the presets list
static const Map<String, Map<String, dynamic>> presets = {
  'my-preset': {
    'name': 'My Preset',
    'description': 'Description of my preset',
    'properties': {
      'myProperty': 50.0,
      // other properties...
    },
  },
};
```

## ⚡ Performance Optimization

### Memory Management

Always dispose of resources properly:

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late AnimationController _controller;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _subscription = someStream.listen(_handleData);
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Performance Monitoring

Use the PerformanceService to monitor your components:

```dart
import '../../../core/services/performance_service.dart';

class MyPerformantWidget extends StatefulWidget {
  @override
  State<MyPerformantWidget> createState() => _MyPerformantWidgetState();
}

class _MyPerformantWidgetState extends State<MyPerformantWidget> {
  @override
  void initState() {
    super.initState();
    PerformanceService.startMeasurement('my_widget_init');
    // Your initialization code
    PerformanceService.endMeasurement('my_widget_init');
  }

  @override
  Widget build(BuildContext context) {
    return PerformanceService.measureBuild(
      'my_widget_build',
      () => Container(
        // Your widget content
      ),
    );
  }
}
```

## 🧪 Testing Guidelines

### Widget Testing

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyWidget Tests', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: MyWidget(),
        ),
      );

      // Act & Assert
      expect(find.byType(MyWidget), findsOneWidget);
      expect(find.text('Expected Text'), findsOneWidget);
    });

    testWidgets('should handle user interaction', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: MyWidget(),
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(find.text('Updated Text'), findsOneWidget);
    });
  });
}
```

### Integration Testing

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fake_loading_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('full user journey', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate through the app
      await tester.tap(find.text('Components'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('My Component'));
      await tester.pumpAndSettle();

      // Verify the component loads
      expect(find.byType(MyComponentDemo), findsOneWidget);
    });
  });
}
```

## 📝 Code Style and Standards

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Methods**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Private members**: `_leadingUnderscore`

### Documentation

Always document public APIs:

```dart
/// A widget that demonstrates fake loading functionality.
///
/// This widget provides an interactive example of how to use
/// the flutter_fake_loading package in real applications.
///
/// Example usage:
/// ```dart
/// FakeLoaderDemo(
///   duration: Duration(seconds: 3),
///   messages: ['Loading...', 'Almost there...'],
/// )
/// ```
class FakeLoaderDemo extends StatefulWidget {
  /// Creates a fake loader demo.
  ///
  /// The [duration] parameter controls how long the loading animation runs.
  /// The [messages] parameter provides the text shown during loading.
  const FakeLoaderDemo({
    super.key,
    this.duration = const Duration(seconds: 2),
    this.messages = const ['Loading...'],
  });

  /// The duration of the loading animation.
  final Duration duration;

  /// The messages to display during loading.
  final List<String> messages;

  @override
  State<FakeLoaderDemo> createState() => _FakeLoaderDemoState();
}
```

### Error Handling

Always handle errors gracefully:

```dart
class MyService {
  Future<String> fetchData() async {
    try {
      // Your async operation
      return await someAsyncOperation();
    } catch (e) {
      // Log the error
      debugPrint('Error fetching data: $e');
      
      // Return a fallback or rethrow with context
      throw FakeLoadingException('Failed to fetch data: $e');
    }
  }
}
```

## 🚀 Deployment Process

### Pre-deployment Checklist

1. **Run all tests**:
   ```bash
   flutter test
   ```

2. **Check code formatting**:
   ```bash
   dart format --set-exit-if-changed .
   ```

3. **Run static analysis**:
   ```bash
   flutter analyze
   ```

4. **Update version numbers** in `pubspec.yaml`

5. **Update CHANGELOG.md** with new features and fixes

### Building for Different Platforms

#### Web
```bash
flutter build web --release
```

#### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 🤝 Contributing Guidelines

### Pull Request Process

1. **Fork the repository** and create a feature branch
2. **Make your changes** following the code style guidelines
3. **Add tests** for new functionality
4. **Update documentation** as needed
5. **Submit a pull request** with a clear description

### Commit Message Format

```
type(scope): brief description

Longer description if needed

Fixes #issue-number
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Code Review Checklist

- [ ] Code follows style guidelines
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No breaking changes (or properly documented)
- [ ] Performance impact is considered
- [ ] Accessibility is maintained

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)

## 🆘 Getting Help

If you need help or have questions:

1. Check the existing documentation
2. Search through existing issues
3. Create a new issue with detailed information
4. Join our community discussions

---

Happy coding! 🎉
# Flutter Fake Loading Showcase App

A comprehensive demonstration application showcasing all features of the `flutter_fake_loading` library. This app serves as both a demo and a reference implementation for developers who want to understand how to use every feature of the library.

## 🚀 Features

### Core Components Demonstrated

- **FakeLoader** - Basic loading widget with customizable messages and effects
  - Customizable message rotation with timing controls
  - Multiple animation effects (fade, slide, scale, typewriter)
  - Programmatic control with start/stop/skip/reset functionality
  - Weighted message selection for varied experiences
  - Loop control and completion callbacks

- **FakeLoadingScreen** - Full-screen loading experiences with theming
  - Material 3 theme integration with dynamic colors
  - Responsive layouts for all screen sizes
  - Accessibility support with screen reader compatibility
  - Custom background colors and branding options
  - Smooth transitions and micro-interactions

- **FakeLoadingOverlay** - Overlay loading for async operations
  - Real Future integration with error handling
  - Timeout and cancellation support
  - Custom overlay styling and positioning
  - Navigation flow integration examples
  - Performance optimized for complex operations

- **FakeProgressIndicator** - Custom progress indicators with animations
  - Circular and linear progress variations
  - Custom graphics and animated elements
  - Progress state tracking with callbacks
  - Smooth animation curves and timing
  - Integration with other loading components

- **TypewriterText** - Typewriter effect text animations
  - Character-by-character animation with customizable timing
  - Cursor customization and blinking options
  - External controller support for programmatic control
  - Multi-line text and formatting support
  - Completion callbacks and event handling

- **Message System** - Comprehensive message packs and weighted selection
  - Pre-built message packs for different themes
  - Custom message pack creation tools
  - Weighted selection with probability visualization
  - Rare messages and easter egg support
  - Message effect comparison and customization

### Interactive Features

- **Real-time Playground** - Modify component properties and see instant results
  - Live preview with immediate visual feedback
  - Intuitive property controls (sliders, toggles, dropdowns, color pickers)
  - Property validation with helpful error messages
  - Undo/redo functionality for easy experimentation
  - Property grouping and organization for better usability

- **Code Generation** - Dynamic code examples that update as you customize
  - Real-time Dart code generation with proper formatting
  - Syntax highlighting with copy-to-clipboard functionality
  - Import statement management and optimization
  - Multiple code style options (concise vs. verbose)
  - Export options for direct integration into projects

- **Configuration Management** - Save, load, and share component configurations
  - Local storage for persistent configurations
  - Import/export functionality for sharing
  - Configuration versioning and history
  - Backup and restore capabilities
  - Cloud sync support for cross-device access

- **Preset Gallery** - Pre-built configurations for common use cases
  - Curated presets for different app types and themes
  - Community-contributed configurations
  - Preset categories and tagging system
  - Preview thumbnails and descriptions
  - One-click preset application with customization options

- **Comparison Tools** - Side-by-side comparison of different configurations
  - Visual diff highlighting for property changes
  - Performance comparison metrics
  - A/B testing support for user experience optimization
  - Export comparison reports
  - Integration with analytics for usage insights

### Advanced Capabilities

- **Performance Optimizations** - Lazy loading, caching, and memory management
  - Widget caching for frequently used components
  - Code generation caching to avoid recomputation
  - Memory leak prevention with automatic cleanup
  - Debounced updates to prevent excessive rebuilds
  - Performance monitoring and optimization suggestions

- **Accessibility Support** - Full screen reader, keyboard navigation, and high contrast support
  - WCAG 2.1 AA compliance with comprehensive testing
  - Screen reader support with semantic labels and descriptions
  - Full keyboard navigation with visible focus indicators
  - High contrast mode with customizable color schemes
  - Text scaling support for visual impairments
  - Haptic feedback for tactile interaction enhancement

- **Responsive Design** - Optimized for mobile, tablet, desktop, and web
  - Adaptive layouts that respond to screen size changes
  - Touch-optimized controls for mobile devices
  - Mouse and keyboard support for desktop interactions
  - Responsive typography and spacing systems
  - Platform-specific optimizations and native feel

- **Theme Integration** - Material 3 theming with light/dark mode support
  - Dynamic color theming with Material You integration
  - Custom color scheme creation and management
  - Automatic theme switching based on system preferences
  - Theme persistence across app sessions
  - Component-level theme customization options

- **Smooth Animations** - Page transitions, micro-interactions, and loading states
  - Custom page transitions with haptic feedback
  - Micro-interactions for enhanced user engagement
  - Loading animations with skeleton screens
  - Hover effects and interactive element feedback
  - Performance-optimized animations with reduced motion support

## 📱 Screenshots

### Home Screen
The landing page provides an overview of all available components and features.

### Interactive Playground
Real-time customization interface with live preview and code generation.

### Component Demonstrations
Detailed examples showing basic usage, advanced features, and best practices.

### Real-world Examples
Complete scenarios demonstrating integration in actual applications.

## 🛠 Installation & Setup

### Prerequisites

- Flutter SDK (>=3.8.1)
- Dart SDK (>=3.8.1)
- IDE with Flutter support (VS Code, Android Studio, or IntelliJ)

### Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_fake_loading/example
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform-specific Setup

#### Web
```bash
flutter run -d chrome
```

#### Desktop (Windows/macOS/Linux)
```bash
flutter run -d windows  # or macos, linux
```

#### Mobile (iOS/Android)
```bash
flutter run -d ios      # or android
```

## 🏗 Architecture

### Project Structure

```
example/
├── lib/
│   ├── app/                    # App configuration and theming
│   ├── core/                   # Core utilities and services
│   │   ├── animations/         # Page transitions and animations
│   │   ├── data/              # Data models and constants
│   │   ├── providers/         # State management providers
│   │   ├── routing/           # Navigation and routing
│   │   ├── services/          # Performance and utility services
│   │   ├── utils/             # Helper utilities
│   │   └── widgets/           # Reusable UI components
│   ├── features/              # Feature-specific screens
│   │   ├── components/        # Component demonstrations
│   │   ├── examples/          # Real-world usage examples
│   │   ├── home/             # Home screen and overview
│   │   ├── playground/        # Interactive playground
│   │   └── settings/          # App settings and preferences
│   ├── main.dart              # App entry point
│   └── showcase_app.dart      # Main app widget
├── assets/                    # Static assets
├── test/                      # Unit and widget tests
└── pubspec.yaml              # Dependencies and configuration
```

### Key Design Patterns

- **Provider Pattern** - State management using the Provider package
- **Repository Pattern** - Data access abstraction
- **Service Locator** - Dependency injection for services
- **Factory Pattern** - Widget and configuration creation
- **Observer Pattern** - Real-time updates and notifications

## 🎨 Customization

### Theming

The app supports comprehensive theming through Material 3:

```dart
// Light theme
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
);

// Dark theme
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
);
```

### Adding New Components

1. **Create component demo**
   ```dart
   // lib/features/components/my_component/my_component_demo.dart
   class MyComponentDemo extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return DemoCard(
         title: 'My Component',
         child: MyComponent(),
         codeSnippet: CodeGenerator.generateMyComponentCode(),
       );
     }
   }
   ```

2. **Add to navigation**
   ```dart
   // lib/core/routing/app_router.dart
   GoRoute(
     path: '/components/my-component',
     builder: (context, state) => const MyComponentDemo(),
   ),
   ```

3. **Update code generator**
   ```dart
   // lib/core/utils/code_generator.dart
   static String generateMyComponentCode(Map<String, dynamic> properties) {
     // Implementation
   }
   ```

### Performance Optimization

The app includes several performance optimizations:

- **Lazy Loading** - Components load on-demand
- **Widget Caching** - Frequently used widgets are cached
- **Code Generation Caching** - Generated code is cached to avoid recomputation
- **Memory Management** - Automatic cleanup of unused resources
- **Debounced Updates** - Property changes are debounced to prevent excessive rebuilds

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Test Structure

- **Unit Tests** - Core logic and utilities
- **Widget Tests** - UI components and interactions
- **Integration Tests** - Complete user flows
- **Golden Tests** - Visual regression testing

### Writing Tests

```dart
// Example widget test
testWidgets('DemoCard displays title and content', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: DemoCard(
        title: 'Test Title',
        child: Text('Test Content'),
      ),
    ),
  );

  expect(find.text('Test Title'), findsOneWidget);
  expect(find.text('Test Content'), findsOneWidget);
});
```

## 🚀 Deployment

### Web Deployment

```bash
# Build for web
flutter build web

# Deploy to Firebase Hosting (example)
firebase deploy --only hosting
```

### Mobile App Stores

```bash
# Build for Android
flutter build appbundle

# Build for iOS
flutter build ipa
```

### Desktop Distribution

```bash
# Build for Windows
flutter build windows

# Build for macOS
flutter build macos

# Build for Linux
flutter build linux
```

## 🤝 Contributing

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

### Code Style

- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add documentation for public APIs
- Keep functions small and focused
- Use consistent formatting (run `dart format .`)

### Commit Messages

Use conventional commit format:
```
feat: add new component demonstration
fix: resolve performance issue in playground
docs: update README with new examples
test: add unit tests for code generator
```

## 📚 API Reference

### Core Services

#### PerformanceService
Manages widget caching and performance optimizations.

```dart
// Cache a widget
PerformanceService().cacheWidget('key', widget);

// Retrieve cached widget
Widget? cached = PerformanceService().getCachedWidget('key');

// Debounce function calls
PerformanceService().debounce('key', callback, duration);
```

#### MemoryManager
Handles memory management and resource cleanup.

```dart
// Register disposable resource
MemoryManager().register(disposable);

// Schedule cleanup
MemoryManager().scheduleCleanup('key', delay, cleanup);

// Perform immediate cleanup
MemoryManager().performCleanup();
```

#### PreloaderService
Manages component preloading for better performance.

```dart
// Preload component
await PreloaderService().preloadComponent('key', builder);

// Queue for preload
PreloaderService().queueForPreload('key', builder);
```

### Core Widgets

#### DemoCard
Reusable container for component demonstrations.

```dart
DemoCard(
  title: 'Component Name',
  description: 'Component description',
  child: YourComponent(),
  showCode: true,
  codeSnippet: 'YourComponent()',
)
```

#### PropertyControl
Interactive control for component properties.

```dart
PropertyControl<String>(
  label: 'Property Name',
  value: currentValue,
  type: PropertyControlType.textField,
  onChanged: (value) => updateProperty(value),
)
```

#### SkeletonScreen
Loading placeholder for better UX.

```dart
SkeletonScreen(
  isLoading: isLoading,
  type: SkeletonType.list,
  child: actualContent,
)
```

## 🐛 Troubleshooting

### Common Issues

#### Performance Issues
- Enable performance monitoring in debug mode
- Check widget cache statistics
- Monitor memory usage
- Use lazy loading for heavy components

#### Build Errors
- Run `flutter clean` and `flutter pub get`
- Check Flutter and Dart SDK versions
- Verify all dependencies are compatible

#### Platform-specific Issues
- Web: Check browser compatibility
- Mobile: Verify platform-specific permissions
- Desktop: Ensure platform support is enabled

### Debug Tools

```dart
// Performance statistics
final stats = PerformanceService().getCacheStats();
print('Widget cache: ${stats['widgetCache']}');

// Memory usage
final memStats = MemoryManager().getMemoryStats();
print('Active disposables: ${memStats['activeDisposables']}');
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Community contributors and feedback
- Open source packages used in this project

## 📞 Support

- **Documentation**: Check the inline code documentation
- **Issues**: Report bugs on GitHub Issues
- **Discussions**: Join community discussions
- **Examples**: Explore the showcase app for usage examples

---

**Made with ❤️ using Flutter**
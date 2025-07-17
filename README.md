# flutter_fake_loading

A Flutter package that provides customizable fake loading screens with personality. Because loading shouldn't be boring!

Transform mundane loading states into engaging, shareable experiences with entertaining loading messages and fake progress indicators.

## Features

- 🎭 **Entertaining Loading Messages** - "Charging flux capacitor...", "Summoning cats...", and more
- 📊 **Fake Progress Indicators** - Smooth, customizable progress bars that look real
- 🎨 **Highly Customizable** - Colors, animations, messages, and timing
- 🚀 **Easy Integration** - Drop-in replacement for boring loading spinners
- 🎮 **Perfect for Portfolio Apps** - Add personality to your projects
- 📱 **Cross-Platform** - Works on iOS, Android, Web, and Desktop

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_fake_loading: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

Basic usage with default settings:

```dart
import 'package:flutter_fake_loading/flutter_fake_loading.dart';

// Simple fake loading screen
FakeLoadingScreen(
  onComplete: () {
    // Navigate to your main screen
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => HomeScreen(),
    ));
  },
)
```

Customized fake loading:

```dart
FakeLoadingScreen(
  messages: [
    "Charging flux capacitor...",
    "Summoning cats...",
    "Calculating universe...",
    "Almost there!"
  ],
  duration: Duration(seconds: 5),
  backgroundColor: Colors.black,
  textColor: Colors.green,
  progressColor: Colors.green,
  onComplete: () => Navigator.pushReplacement(
    context, 
    MaterialPageRoute(builder: (context) => HomeScreen())
  ),
)
```

## Additional information

- **Repository**: [GitHub](https://github.com/theprantadutta/flutter_fake_loading)
- **Issues**: [Report bugs or request features](https://github.com/theprantadutta/flutter_fake_loading/issues)
- **Author**: [Pranta Dutta](https://github.com/theprantadutta)

Perfect for:
- Portfolio applications
- Indie games and creative apps
- Onboarding flows
- Any app that wants to add personality to loading states

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

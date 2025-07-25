/// A Flutter package that provides customizable fake loading screens with personality.
///
/// This package transforms mundane loading states into engaging, shareable experiences
/// with entertaining messages, fake progress indicators, and various animation effects.
/// Perfect for portfolio apps, indie games, and any app that wants to add personality
/// to loading screens.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:flutter_fake_loading/flutter_fake_loading.dart';
///
/// // Simple usage
/// FakeLoadingScreen(
///   messages: ['Loading awesome content...', 'Almost there...'],
///   duration: Duration(seconds: 3),
///   onComplete: () => Navigator.pushReplacement(context, MyHomePage()),
/// )
///
/// // With progress and theming
/// FakeLoadingScreen(
///   messages: FakeMessagePack.techStartup,
///   showProgress: true,
///   backgroundColor: Colors.black,
///   textColor: Colors.green,
///   progressColor: Colors.green,
/// )
///
/// // With weighted messages and typewriter effect
/// FakeLoader(
///   messages: [
///     FakeMessage.weighted('Common message', 0.8),
///     FakeMessage.weighted('Rare easter egg!', 0.2),
///   ],
///   effect: MessageEffect.typewriter,
/// )
/// ```
///
/// ## Core Components
///
/// - [FakeLoadingScreen]: High-level full-screen loading widget
/// - [FakeLoader]: Core customizable loading widget
/// - [FakeLoaderController]: Programmatic control over loading sequences
/// - [FakeLoadingOverlay]: Integration with Future-based operations
/// - [FakeProgressIndicator]: Standalone progress simulation widget
/// - [TypewriterText]: Character-by-character text animation
///
/// ## Message System
///
/// - [FakeMessage]: Individual loading messages with weights and effects
/// - [FakeMessagePack]: Pre-built themed message collections
/// - [MessageEffect]: Animation effects for message transitions
/// - [MessageSelector]: Weighted random message selection utilities
///
/// ## Utilities
///
/// - [ProgressState]: Progress tracking and state management
/// - [FakeLoadingException]: Comprehensive error handling
/// - [ValidationUtils]: Input validation and normalization
library;

// Core widgets
export 'src/fake_loader.dart';
export 'src/fake_loader_controller.dart';
export 'src/fake_loading_overlay.dart';
export 'src/fake_loading_screen.dart';
export 'src/fake_progress_indicator.dart';

// Animation components
export 'src/typewriter_controller.dart';
export 'src/typewriter_text.dart';

// Data models
export 'src/models/fake_message.dart';
export 'src/models/fake_message_pack.dart';
export 'src/models/message_effect.dart';
export 'src/models/progress_state.dart';

// Utilities
export 'src/utils/message_selector.dart';
export 'src/utils/validation.dart';

// Error handling
export 'src/exceptions/fake_loading_exception.dart';

/// A collection of predefined message packs with different themes for fake loading screens.
///
/// Each message pack contains contextually appropriate messages that match
/// specific app types or moods. Use these to quickly add personality to your
/// loading screens without writing custom messages.
abstract class FakeMessagePack {
  /// Tech startup themed messages with modern development and AI references.
  ///
  /// Perfect for SaaS apps, developer tools, and tech-focused applications.
  static const List<String> techStartup = [
    "Initializing quantum processors...",
    "Calibrating neural networks...",
    "Optimizing algorithms...",
    "Syncing with the cloud...",
    "Compiling machine learning models...",
    "Bootstrapping microservices...",
    "Deploying to production...",
    "Scaling infrastructure...",
    "Training AI models...",
    "Establishing blockchain consensus...",
    "Containerizing applications...",
    "Orchestrating distributed systems...",
    "Analyzing big data patterns...",
    "Implementing DevOps pipelines...",
    "Securing API endpoints...",
  ];

  /// Gaming themed messages with adventure and fantasy references.
  ///
  /// Ideal for games, entertainment apps, and playful applications.
  static const List<String> gaming = [
    "Loading epic adventures...",
    "Spawning legendary items...",
    "Charging power-ups...",
    "Generating random dungeons...",
    "Summoning boss monsters...",
    "Crafting magical weapons...",
    "Loading save game...",
    "Initializing physics engine...",
    "Rendering 3D worlds...",
    "Calculating damage multipliers...",
    "Respawning players...",
    "Loading texture packs...",
    "Compiling shaders...",
    "Synchronizing multiplayer state...",
    "Balancing character stats...",
  ];

  /// Casual and fun messages with humor and personality.
  ///
  /// Great for personal projects, creative apps, and anything that wants
  /// to bring a smile to users' faces.
  static const List<String> casual = [
    "Summoning cats...",
    "Charging flux capacitor...",
    "Counting sheep...",
    "Brewing coffee...",
    "Feeding unicorns...",
    "Polishing pixels...",
    "Untangling headphones...",
    "Finding missing socks...",
    "Teaching robots to dance...",
    "Organizing digital chaos...",
    "Calibrating randomness...",
    "Downloading more RAM...",
    "Convincing hamsters to run faster...",
    "Reticulating splines...",
    "Herding digital cats...",
  ];

  /// Professional and business-appropriate messages.
  ///
  /// Suitable for corporate apps, business tools, and formal applications
  /// where you want personality without being too playful.
  static const List<String> professional = [
    "Processing your request...",
    "Validating data integrity...",
    "Establishing secure connection...",
    "Authenticating credentials...",
    "Synchronizing databases...",
    "Generating reports...",
    "Optimizing performance...",
    "Backing up data...",
    "Updating configurations...",
    "Verifying permissions...",
    "Initializing workspace...",
    "Loading user preferences...",
    "Connecting to services...",
    "Preparing dashboard...",
    "Finalizing setup...",
  ];
}

/// A custom message pack that allows users to define their own themed collections.
///
/// Use this class to create your own message packs with specific themes,
/// contexts, or branding that match your application's personality.
///
/// Example:
/// ```dart
/// final myPack = CustomMessagePack(
///   name: 'Space Theme',
///   messages: [
///     'Launching rockets...',
///     'Exploring galaxies...',
///     'Contacting aliens...',
///   ],
///   description: 'Space exploration themed messages',
/// );
/// ```
class CustomMessagePack {
  /// The name of this message pack.
  final String name;

  /// The list of messages in this pack.
  final List<String> messages;

  /// Optional description of this message pack's theme or purpose.
  final String? description;

  /// Creates a custom message pack with the given name and messages.
  ///
  /// [name] should be a descriptive name for the theme.
  /// [messages] must contain at least one non-empty message.
  /// [description] is optional but recommended for documentation.
  ///
  /// Throws [ArgumentError] if messages list is empty.
  CustomMessagePack({
    required this.name,
    required this.messages,
    this.description,
  }) {
    if (messages.isEmpty) {
      throw ArgumentError('Messages list cannot be empty');
    }
  }

  /// Creates a copy of this message pack with optional modifications.
  CustomMessagePack copyWith({
    String? name,
    List<String>? messages,
    String? description,
  }) {
    return CustomMessagePack(
      name: name ?? this.name,
      messages: messages ?? this.messages,
      description: description ?? this.description,
    );
  }

  /// Returns a string representation of this message pack.
  @override
  String toString() {
    return 'CustomMessagePack(name: $name, messages: ${messages.length} items'
        '${description != null ? ', description: $description' : ''})';
  }

  /// Checks equality based on name, messages, and description.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CustomMessagePack) return false;

    return name == other.name &&
        _listEquals(messages, other.messages) &&
        description == other.description;
  }

  @override
  int get hashCode {
    int messagesHash = 0;
    for (final message in messages) {
      messagesHash = messagesHash ^ message.hashCode;
    }
    return Object.hash(name, messagesHash, description);
  }

  /// Helper method to compare lists for equality.
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

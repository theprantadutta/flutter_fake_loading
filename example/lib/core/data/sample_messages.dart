/// Sample message packs and demo configurations for the showcase app
class SampleMessages {
  // Private constructor to prevent instantiation
  SampleMessages._();

  /// Basic loading messages
  static const List<String> basicMessages = [
    'Loading...',
    'Please wait...',
    'Almost there...',
    'Just a moment...',
  ];

  /// Fun and quirky messages
  static const List<String> funMessages = [
    'Charging flux capacitor...',
    'Summoning digital cats...',
    'Brewing coffee for the servers...',
    'Teaching robots to dance...',
    'Counting backwards from infinity...',
    'Herding pixels...',
    'Calibrating awesome meter...',
    'Loading level of epicness...',
  ];

  /// Tech startup style messages
  static const List<String> techStartupMessages = [
    'Disrupting the loading industry...',
    'Leveraging synergies...',
    'Optimizing user experience...',
    'Scaling infrastructure...',
    'Implementing best practices...',
    'Deploying microservices...',
    'Analyzing big data...',
    'Revolutionizing workflows...',
  ];

  /// Gaming style messages
  static const List<String> gamingMessages = [
    'Spawning enemies...',
    'Loading next level...',
    'Calculating damage...',
    'Respawning player...',
    'Generating world...',
    'Buffering power-ups...',
    'Initializing boss fight...',
    'Saving progress...',
  ];

  /// Retro/vintage messages
  static const List<String> retroMessages = [
    'Rewinding cassette tapes...',
    'Adjusting rabbit ears...',
    'Dialing up the internet...',
    'Loading from floppy disk...',
    'Warming up CRT monitor...',
    'Connecting to BBS...',
    'Defragmenting hard drive...',
    'Booting from DOS...',
  ];

  /// Science fiction messages
  static const List<String> sciFiMessages = [
    'Initializing warp drive...',
    'Scanning for alien life...',
    'Charging photon torpedoes...',
    'Calibrating deflector shields...',
    'Accessing mainframe...',
    'Decrypting alien signals...',
    'Powering up hyperdrive...',
    'Establishing quantum link...',
  ];

  /// Food and cooking messages
  static const List<String> cookingMessages = [
    'Preheating the oven...',
    'Chopping virtual vegetables...',
    'Stirring the code soup...',
    'Seasoning with algorithms...',
    'Baking fresh pixels...',
    'Marinating data...',
    'Grilling user interfaces...',
    'Serving hot content...',
  ];

  /// Weather and nature messages
  static const List<String> natureMessages = [
    'Watering digital plants...',
    'Counting raindrops...',
    'Chasing butterflies...',
    'Growing virtual trees...',
    'Collecting morning dew...',
    'Following rainbow paths...',
    'Listening to bird songs...',
    'Planting code seeds...',
  ];

  /// Get all message packs as a map
  static Map<String, List<String>> getAllMessagePacks() {
    return {
      'Basic': basicMessages,
      'Fun & Quirky': funMessages,
      'Tech Startup': techStartupMessages,
      'Gaming': gamingMessages,
      'Retro': retroMessages,
      'Sci-Fi': sciFiMessages,
      'Cooking': cookingMessages,
      'Nature': natureMessages,
    };
  }

  /// Get a random message pack
  static List<String> getRandomMessagePack() {
    final packs = getAllMessagePacks().values.toList();
    packs.shuffle();
    return packs.first;
  }

  /// Get messages by category
  static List<String> getMessagesByCategory(String category) {
    final packs = getAllMessagePacks();
    return packs[category] ?? basicMessages;
  }

  /// Get all available categories
  static List<String> getAvailableCategories() {
    return getAllMessagePacks().keys.toList();
  }
}

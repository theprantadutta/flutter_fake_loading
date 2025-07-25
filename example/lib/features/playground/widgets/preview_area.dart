import 'package:flutter/material.dart';
import 'package:flutter_fake_loading/flutter_fake_loading.dart';
import '../../../core/data/playground_state.dart';
import '../../../core/utils/code_generator.dart';

/// Live preview area for testing components in real-time
class PreviewArea extends StatefulWidget {
  final PlaygroundState state;
  final VoidCallback? onPreviewAction;

  const PreviewArea({super.key, required this.state, this.onPreviewAction});

  @override
  State<PreviewArea> createState() => _PreviewAreaState();
}

class _PreviewAreaState extends State<PreviewArea> {
  bool _isPlaying = false;
  bool _showFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          Expanded(child: _buildPreviewContent(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.visibility, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text('Live Preview', style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          if (_canShowFullScreen()) ...[
            IconButton(
              onPressed: () =>
                  setState(() => _showFullScreen = !_showFullScreen),
              icon: Icon(
                _showFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              ),
              tooltip: _showFullScreen
                  ? 'Exit fullscreen'
                  : 'Fullscreen preview',
            ),
          ],
          IconButton(
            onPressed: _togglePlayback,
            icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
            tooltip: _isPlaying ? 'Stop' : 'Play',
          ),
          IconButton(
            onPressed: _restartPreview,
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart',
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent(BuildContext context) {
    if (_showFullScreen &&
        widget.state.componentType == ComponentType.fakeLoadingScreen) {
      return _buildFullScreenPreview(context);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Center(child: _buildComponentPreview(context)),
    );
  }

  Widget _buildFullScreenPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color:
          widget.state.properties['backgroundColor'] as Color? ?? Colors.white,
      child: _buildComponentPreview(context),
    );
  }

  Widget _buildComponentPreview(BuildContext context) {
    switch (widget.state.componentType) {
      case ComponentType.fakeLoader:
        return _buildFakeLoaderPreview();
      case ComponentType.fakeLoadingScreen:
        return _buildFakeLoadingScreenPreview();
      case ComponentType.fakeLoadingOverlay:
        return _buildFakeLoadingOverlayPreview();
      case ComponentType.fakeProgressIndicator:
        return _buildFakeProgressIndicatorPreview();
      case ComponentType.typewriterText:
        return _buildTypewriterTextPreview();
    }
  }

  Widget _buildFakeLoaderPreview() {
    final properties = widget.state.properties;

    return FakeLoader(
      key: ValueKey(_isPlaying),
      messages: properties['messages'] as List<String>? ?? ['Loading...'],
      messageDuration:
          properties['duration'] as Duration? ?? const Duration(seconds: 2),
      randomOrder: properties['randomOrder'] as bool? ?? false,
      loopUntilComplete: properties['loop'] as bool? ?? false,
      maxLoops: properties['maxLoops'] as int? ?? 1,
      textStyle: properties['textStyle'] as TextStyle?,
      textAlign: _parseTextAlign(properties['alignment'] as String?),
      autoStart: _isPlaying,
    );
  }

  Widget _buildFakeLoadingScreenPreview() {
    final properties = widget.state.properties;

    if (_showFullScreen) {
      return FakeLoadingScreen(
        key: ValueKey(_isPlaying),
        messages: properties['messages'] as List<String>? ?? ['Loading...'],
        duration:
            properties['duration'] as Duration? ?? const Duration(seconds: 2),
        backgroundColor:
            properties['backgroundColor'] as Color? ?? Colors.white,
        textColor: properties['textColor'] as Color? ?? Colors.black,
        progressColor: properties['progressColor'] as Color? ?? Colors.blue,
        showProgress: properties['showProgress'] as bool? ?? true,
        onComplete: () {
          setState(() {
            _isPlaying = false;
            _showFullScreen = false;
          });
        },
      );
    }

    // Show a scaled-down preview
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        color: properties['backgroundColor'] as Color? ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (properties['showProgress'] as bool? ?? true) ...[
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                color: properties['progressColor'] as Color? ?? Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            (properties['messages'] as List<String>?)?.first ?? 'Loading...',
            style: TextStyle(
              color: properties['textColor'] as Color? ?? Colors.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFakeLoadingOverlayPreview() {
    final properties = widget.state.properties;

    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          // Background content
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Your Content Here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          // Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: properties['backgroundColor'] as Color? ?? Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    (properties['messages'] as List<String>?)?.first ??
                        'Loading...',
                    style: TextStyle(
                      color: properties['textColor'] as Color? ?? Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFakeProgressIndicatorPreview() {
    final properties = widget.state.properties;

    return FakeProgressIndicator(
      key: ValueKey(_isPlaying),
      duration:
          properties['duration'] as Duration? ?? const Duration(seconds: 2),
      color: properties['color'] as Color? ?? Colors.blue,
      backgroundColor: properties['backgroundColor'] as Color?,
      height: properties['height'] as double? ?? 4.0,
      autoStart: _isPlaying,
    );
  }

  Widget _buildTypewriterTextPreview() {
    final properties = widget.state.properties;

    return TypewriterText(
      key: ValueKey(_isPlaying),
      text: properties['text'] as String? ?? 'Hello, World!',
      characterDelay:
          properties['characterDelay'] as Duration? ??
          const Duration(milliseconds: 50),
      style:
          (properties['style'] as TextStyle?)?.copyWith(
            color: properties['cursorColor'] as Color? ?? Colors.black,
          ) ??
          TextStyle(color: properties['cursorColor'] as Color? ?? Colors.black),
      showCursor: properties['showCursor'] as bool? ?? true,
      autoStart: _isPlaying,
    );
  }

  TextAlign _parseTextAlign(String? alignmentString) {
    switch (alignmentString) {
      case 'left':
      case 'centerLeft':
        return TextAlign.left;
      case 'center':
        return TextAlign.center;
      case 'right':
      case 'centerRight':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      case 'start':
        return TextAlign.start;
      case 'end':
        return TextAlign.end;
      default:
        return TextAlign.center;
    }
  }

  bool _canShowFullScreen() {
    return widget.state.componentType == ComponentType.fakeLoadingScreen;
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    widget.onPreviewAction?.call();
  }

  void _restartPreview() {
    setState(() {
      _isPlaying = false;
    });

    // Small delay to ensure the widget is rebuilt
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    });

    widget.onPreviewAction?.call();
  }
}

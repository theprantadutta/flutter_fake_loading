import 'package:flutter/material.dart';
import '../../core/utils/code_generator.dart';
import '../../core/data/playground_state.dart';
import '../../core/services/performance_service.dart';
import '../../core/services/memory_manager.dart';
import 'widgets/playground_tabs.dart';
import 'widgets/property_panel.dart';
import 'widgets/preview_area.dart';
import 'widgets/code_panel.dart';
import 'widgets/configuration_panel.dart';
import 'widgets/preset_gallery.dart';
import 'widgets/configuration_comparison.dart';
import 'widgets/undo_redo_manager.dart';
import 'widgets/export_options.dart';

/// Interactive playground screen for real-time customization
class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen>
    with
        TickerProviderStateMixin,
        PerformanceOptimizedWidget,
        MemoryManagedWidget {
  late TabController _tabController;
  PlaygroundState _playgroundState = PlaygroundState.createInitialState(
    ComponentType.fakeLoader,
  );
  final UndoRedoManager _undoRedoManager = UndoRedoManager();
  final List<PlaygroundState> _comparisonConfigs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Initialize undo/redo with initial state
    _undoRedoManager.addState(_playgroundState);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _undoRedoManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Playground'),
        actions: [
          UndoRedoControls(
            manager: _undoRedoManager,
            onStateChanged: _onStateChanged,
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _addToComparison,
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Add to comparison',
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              PlaygroundTabs(
                selectedComponent: _playgroundState.componentType,
                onComponentChanged: _onComponentChanged,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Bottom tabs for different panels
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(icon: Icon(Icons.tune), text: 'Properties'),
                Tab(icon: Icon(Icons.code), text: 'Code'),
                Tab(icon: Icon(Icons.bookmark), text: 'Configs'),
                Tab(icon: Icon(Icons.collections_bookmark), text: 'Presets'),
                Tab(icon: Icon(Icons.file_download), text: 'Export'),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Row(
              children: [
                // Left panel - Properties/Code/Configurations
                SizedBox(
                  width: 350,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      PropertyPanel(
                        state: _playgroundState,
                        onStateChanged: _onStateChanged,
                      ),
                      CodePanel(state: _playgroundState),
                      ConfigurationPanel(
                        state: _playgroundState,
                        onStateChanged: _onStateChanged,
                      ),
                      PresetGallery(
                        componentType: _playgroundState.componentType,
                        onPresetSelected: _onStateChanged,
                      ),
                      ExportOptions(state: _playgroundState),
                    ],
                  ),
                ),

                // Divider
                VerticalDivider(
                  width: 1,
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),

                // Right panel - Live preview
                Expanded(
                  child: PreviewArea(
                    state: _playgroundState,
                    onPreviewAction: _onPreviewAction,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onComponentChanged(ComponentType componentType) {
    final newState = PlaygroundState.createInitialState(componentType);
    setState(() {
      _playgroundState = newState;
    });
    _undoRedoManager.clear();
    _undoRedoManager.addState(newState);
  }

  void _onStateChanged(PlaygroundState newState) {
    // Debounce state updates to prevent excessive rebuilds
    debounceUpdate(() {
      if (mounted) {
        setState(() {
          _playgroundState = newState;
        });
        _undoRedoManager.addState(newState);
      }
    });
  }

  void _onPreviewAction() {
    // Handle preview actions like play/stop/restart
    // This could trigger analytics or other side effects
  }

  void _addToComparison() {
    if (_comparisonConfigs.length < 4) {
      // Limit to 4 configurations
      setState(() {
        _comparisonConfigs.add(_playgroundState);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to comparison (${_comparisonConfigs.length}/4)'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(label: 'View', onPressed: _showComparison),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 4 configurations can be compared'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showComparison() {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Configuration Comparison'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _comparisonConfigs.clear();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          body: ConfigurationComparison(
            configurations: _comparisonConfigs,
            onClearAll: () {
              setState(() {
                _comparisonConfigs.clear();
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}

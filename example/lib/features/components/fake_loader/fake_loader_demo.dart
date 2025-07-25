import 'package:flutter/material.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/skeleton_screen.dart';
import '../../../core/services/preloader_service.dart';
import 'widgets/basic_demo.dart';
import 'widgets/advanced_demo.dart';
import 'widgets/playground.dart';

/// Main screen for FakeLoader component demonstrations
class FakeLoaderDemo extends StatefulWidget {
  const FakeLoaderDemo({super.key});

  @override
  State<FakeLoaderDemo> createState() => _FakeLoaderDemoState();
}

class _FakeLoaderDemoState extends State<FakeLoaderDemo>
    with SingleTickerProviderStateMixin, PreloadingScreen {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void preloadScreenComponents() {
    // Preload demo components
    queueComponentPreload(
      'fake_loader_basic',
      () => const BasicFakeLoaderDemo(),
    );
    queueComponentPreload(
      'fake_loader_advanced',
      () => const AdvancedFakeLoaderDemo(),
    );
    queueComponentPreload(
      'fake_loader_playground',
      () => const FakeLoaderPlayground(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FakeLoader'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Basic', icon: Icon(Icons.play_arrow)),
            Tab(text: 'Advanced', icon: Icon(Icons.tune)),
            Tab(text: 'Playground', icon: Icon(Icons.science)),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: SectionHeader(
              title: 'FakeLoader Component',
              subtitle:
                  'Core loading widget with customizable messages and effects',
              icon: Icons.refresh,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PreloadableWidget(
                  preloadKey: 'fake_loader_basic',
                  builder: () => const BasicFakeLoaderDemo(),
                  placeholder: const SkeletonScreen(type: SkeletonType.demo),
                ),
                PreloadableWidget(
                  preloadKey: 'fake_loader_advanced',
                  builder: () => const AdvancedFakeLoaderDemo(),
                  placeholder: const SkeletonScreen(type: SkeletonType.demo),
                ),
                PreloadableWidget(
                  preloadKey: 'fake_loader_playground',
                  builder: () => const FakeLoaderPlayground(),
                  placeholder: const SkeletonScreen(
                    type: SkeletonType.playground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

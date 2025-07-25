import 'package:flutter/material.dart';
import 'widgets/pack_demo.dart';
import 'widgets/weighted_demo.dart';
import 'widgets/effects_demo.dart';

/// Main screen for message system demonstrations
class MessageSystemDemo extends StatefulWidget {
  const MessageSystemDemo({super.key});

  @override
  State<MessageSystemDemo> createState() => _MessageSystemDemoState();
}

class _MessageSystemDemoState extends State<MessageSystemDemo>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Message System'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.collections_bookmark), text: 'Message Packs'),
            Tab(icon: Icon(Icons.tune), text: 'Weighted Selection'),
            Tab(icon: Icon(Icons.animation), text: 'Effects'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MessagePackDemo(),
          WeightedMessageDemo(),
          MessageEffectsDemo(),
        ],
      ),
    );
  }
}

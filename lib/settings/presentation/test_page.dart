import 'package:flutter/material.dart';
import 'package:pwd/settings/presentation/settings_page/settings_page.dart';

class TestPage extends StatelessWidget {
  final Future Function(BuildContext, SettingsRouteData) onRoute;

  const TestPage({super.key, required this.onRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(
        child: Text('Settings'),
      ),
    );
  }
}

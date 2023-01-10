import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class SettingsRouteData {
  const SettingsRouteData();

  factory SettingsRouteData.onTest() = OnTestPage;
}

class OnTestPage extends SettingsRouteData {
  const OnTestPage();
}

class SettingsPage extends StatelessWidget {
  final Future Function(BuildContext, SettingsRouteData) onRoute;

  const SettingsPage({super.key, required this.onRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: CupertinoButton(
          child: const Text('On test page'),
          onPressed: () {
            onRoute(context, SettingsRouteData.onTest());
          },
        ),
      ),
    );
  }
}

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

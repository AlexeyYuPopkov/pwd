import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/common_size.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';

abstract class SettingsRouteData {
  const SettingsRouteData();

  factory SettingsRouteData.onTest() = OnTestPage;
}

class OnTestPage extends SettingsRouteData {
  const OnTestPage();
}

class SettingsPage extends StatelessWidget with ShowErrorDialogMixin {
  final Future Function(BuildContext, SettingsRouteData) onRoute;

  const SettingsPage({super.key, required this.onRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.pageTitle)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: CommonSize.indent2x),
          CupertinoButton(
            child: Text(context.testPageButtonTitle),
            onPressed: () => _onTest(context),
          ),
        ],
      ),
    );
  }

  void _onTest(BuildContext context) {
    onRoute(context, SettingsRouteData.onTest());
  }
}

// Localization
extension on BuildContext {
  String get pageTitle => 'Settings';
  String get testPageButtonTitle => 'On test page';
}

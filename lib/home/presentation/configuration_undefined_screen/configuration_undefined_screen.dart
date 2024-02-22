import 'package:flutter/material.dart';
import 'package:pwd/theme/common_size.dart';

sealed class ConfigurationUndefinedScreensRoute {
  const ConfigurationUndefinedScreensRoute();
}

final class ToSettingsRoute extends ConfigurationUndefinedScreensRoute {
  const ToSettingsRoute();
}

final class ConfigurationUndefinedScreen extends StatelessWidget {
  final Future Function(BuildContext, Object) onRoute;
  const ConfigurationUndefinedScreen({super.key, required this.onRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(CommonSize.indent2x),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.labelText,
                key: const Key(ConfigurationUndefinedScreenTestHelper.label),
                maxLines: 2,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: CommonSize.indent4x),
              OutlinedButton(
                key: const Key(ConfigurationUndefinedScreenTestHelper.button),
                onPressed: () => onRoute(context, const ToSettingsRoute()),
                child: Text(context.buttomTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on BuildContext {
  String get labelText => 'Synchronization methods are not defined';

  String get buttomTitle => 'Setup synchronization';
}

final class ConfigurationUndefinedScreenTestHelper {
  static const label = 'ConfigurationUndefinedScreen.Label.TestKey';
  static const button = 'ConfigurationUndefinedScreen.Button.TestKey';
}

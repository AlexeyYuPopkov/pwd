import 'package:flutter/material.dart';
import 'package:pwd/l10n/localization_helper.dart';
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
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(CommonSize.indent2x),
          child: Center(
            child: FutureBuilder(
                future: Future.delayed(Durations.short1).then((_) => 1.0),
                initialData: 0.0,
                builder: (context, snapshot) => AnimatedOpacity(
                      opacity: snapshot.data ?? 1.0,
                      duration: Durations.medium4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.labelText,
                            key: const Key(
                                ConfigurationUndefinedScreenTestHelper.label),
                            maxLines: 2,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: CommonSize.indent4x),
                          OutlinedButton(
                            key: const Key(
                                ConfigurationUndefinedScreenTestHelper.button),
                            onPressed: () =>
                                onRoute(context, const ToSettingsRoute()),
                            child: Text(context.buttonTitle),
                          ),
                        ],
                      ),
                    )),
          ),
        ),
      );
}

extension on BuildContext {
  String get labelText => localization.configurationUndefinedScreenLabel;
  String get buttonTitle => localization.configurationUndefinedScreenButton;
}

final class ConfigurationUndefinedScreenTestHelper {
  static const label = 'ConfigurationUndefinedScreen.Label.TestKey';
  static const button = 'ConfigurationUndefinedScreen.Button.TestKey';
}

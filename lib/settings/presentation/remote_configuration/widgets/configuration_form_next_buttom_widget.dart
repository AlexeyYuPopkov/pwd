import 'package:flutter/material.dart';

import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc_data.dart';
import 'package:pwd/theme/common_size.dart';

final class ConfigurationFormNextButtomWidget extends StatelessWidget {
  static const outlinedButtonKey = 'OutlinedButton.Key';

  final SetConfigurationBlocMode mode;
  final VoidCallback? onTap;

  const ConfigurationFormNextButtomWidget({
    super.key,
    required this.mode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: CommonSize.indent2x),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: OutlinedButton(
            key: const Key(outlinedButtonKey),
            onPressed: onTap,
            child: Text(context.nextButtonTitle(mode: mode)),
          ),
        ),
      );
}

// Localization
extension on BuildContext {
  String nextButtonTitle({required SetConfigurationBlocMode mode}) {
    switch (mode) {
      case SetConfigurationBlocMode.newConfiguration:
        return 'Save';
      case SetConfigurationBlocMode.editConfiguration:
        return 'Delete';
    }
  }
}

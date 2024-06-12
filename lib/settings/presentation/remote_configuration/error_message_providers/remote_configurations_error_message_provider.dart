import 'package:flutter/widgets.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/l10n/gen_l10n/localization.dart';

final class RemoteConfigurationsErrorMessageProvider {
  const RemoteConfigurationsErrorMessageProvider();
  ErrorMessage? call(BuildContext context, Object e) {
    if (e is RemoteConfigurationsError) {
      switch (e) {
        case MaxCountError():
          return ErrorMessage.common(
            context,
            message: context.maxCount,
          );
        case FilenemeDublicateError():
          return ErrorMessage.common(
            context,
            message: context.filenemeDublicate,
          );
      }
    }

    return null;
  }
}

extension on BuildContext {
  Localization get localization => Localization.of(this)!;
  String get maxCount => localization.remoteConfigurationsErrorMaxCount;
  String get filenemeDublicate =>
      localization.remoteConfigurationsErrorFilenemeDublicate;
}

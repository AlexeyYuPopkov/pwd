import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecases_errors.dart';

final class SyncDataErrorMessageProvider {
  const SyncDataErrorMessageProvider();

  ErrorMessage? call(BuildContext context, Object e) {
    if (e is SyncDataError) {
      switch (e) {
        case UnknownSyncDataError():
          return ErrorMessage.common(
            context,
            message: context.unkhown,
          );
      }
    }

    return null;
  }
}

extension on BuildContext {
  String get unkhown => 'Error when sync data';
}

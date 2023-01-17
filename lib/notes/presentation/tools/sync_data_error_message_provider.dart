import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecases_errors.dart';

class SyncDataErrorMessageProvider {
  const SyncDataErrorMessageProvider();

  ErrorMessage? call(BuildContext context, Object e) {
    if (e is UnknownSyncDataError) {
      return ErrorMessage.common(
        context,
        message: context.unkhown,
      );
    } else if (e is DestinationNotFound) {
      return ErrorMessage.common(
        context,
        message: context.destinationNotFound,
      );
    }
    return null;
  }
}

extension on BuildContext {
  String get unkhown => 'Error when sync data';
  String get destinationNotFound =>
      'Forgot to create sync file on current branch. '
      'Synchronization is not possible';
}

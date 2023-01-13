import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecases_errors.dart';

class SyncDataErrorMessageProvider {
  const SyncDataErrorMessageProvider();

  ErrorMessage? call(BuildContext context, Object e) {
    if (e is SyncDataError) {
      return ErrorMessage.common(context, message: 'Error when sync data');
    }
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/notes/domain/model/local_storage_error.dart';

final class LocalStorageErrorMessageProvider {
  const LocalStorageErrorMessageProvider();

  ErrorMessage? call(BuildContext context, Object e) {
    if (e is LocalStorageError) {
      switch (e) {
        case UnknownRealmStorageError():
          return ErrorMessage.uncatch(context);
        case PinDoesNotMatchError():
          return ErrorMessage.common(
            context,
            message: context.pinDoesNotMatch,
          );
      }
    }

    return null;
  }
}

extension on BuildContext {
  String get pinDoesNotMatch => 'Pin does not match';
}

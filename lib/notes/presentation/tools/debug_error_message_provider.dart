import 'package:flutter/material.dart';

import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';

final class DebugErrorMessageProvider {
  const DebugErrorMessageProvider();

  ErrorMessage? call(BuildContext context, Object e) {
    return ErrorMessage(
      title: e.runtimeType.toString(),
      message: e.toString(),
      destination: ErrorMessageDestination.dialog,
    );
  }
}

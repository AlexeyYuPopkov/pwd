import 'package:flutter/material.dart';
import 'package:pwd/common/domain/usecases/hash_usecase.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';

class CryptErrorMessageProvider {
  const CryptErrorMessageProvider();

  ErrorMessage? call(BuildContext context, Object e) {
    if (e is HashUsecaseEmptyPinError) {
      return ErrorMessage.common(context, message: 'Empty Pin');
    } else if (e is HashUsecaseWrongPinLengthError) {
      return ErrorMessage.common(context, message: 'Wrong Pin hash');
    } else if (e is HashUsecaseEncryptError) {
      return ErrorMessage.common(context, message: 'Encrypt error');
    }

    return null;
  }
}

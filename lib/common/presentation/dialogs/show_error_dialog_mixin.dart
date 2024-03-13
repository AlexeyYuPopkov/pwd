import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/common/domain/errors/network_error.dart';
import 'package:pwd/notes/presentation/tools/debug_error_message_provider.dart';

import 'dialog_helper.dart';

part 'show_error_dialog_model.dart';

abstract class ShowErrorDialogInterface {
  void showError(
    BuildContext context,
    Object e, {
    void Function(BuildContext)? handler,
  });

  ErrorMessage errorMessage(BuildContext context, Object e);
}

class _Presenter with DialogHelper {}

extension on List<ErrorMessage? Function(BuildContext context, Object e)> {
  ErrorMessage? compose(BuildContext context, Object e) {
    if (isEmpty) {
      return null;
    }
    for (final provider in this) {
      final result = provider.call(context, e);

      if (result != null && result.message.isNotEmpty) {
        return result;
      }
    }

    return null;
  }
}

mixin ShowErrorDialogMixin implements ShowErrorDialogInterface {
  @override
  void showError(
    BuildContext context,
    Object e, {
    List<ErrorMessage? Function(BuildContext context, Object e)>
        errorMessageProviders = const [],
    void Function(BuildContext)? handler,
  }) {
    final AppConfigurationProvider appConfigurationProvider =
        DiStorage.shared.resolve();

    final showRawErrors =
        appConfigurationProvider.currentConfiguration.showRawErrors;

    final providers = showRawErrors
        ? [const DebugErrorMessageProvider().call]
        : errorMessageProviders;

    final message = providers.compose(context, e) ?? errorMessage(context, e);

    switch (message.destination) {
      case ErrorMessageDestination.dialog:
        _showErrorAlertDialog(
          context,
          message: message.message,
          showRawErrors: showRawErrors,
          title: message.title,
          handler: handler,
        );
        return;
      case ErrorMessageDestination.snackBar:
        _Presenter().showSnackBar(context, message.message);
        return;
      case ErrorMessageDestination.ignore:
        return;
    }
  }

  @override
  ErrorMessage errorMessage(BuildContext context, Object e) {
    if (e is NetworkError) {
      return _networkError(context, e);
    } else if (e is AppError) {
      return _appErrorMessage(context, e);
    } else {
      if (e is Error) {
        debugPrint(e.toString());

        debugPrintStack(
          stackTrace: e.stackTrace,
        );
      }

      return ErrorMessage.uncatch(context);
    }
  }

  void _showErrorAlertDialog(
    BuildContext context, {
    required String message,
    required bool showRawErrors,
    String? title,
    void Function(BuildContext)? handler,
  }) {
    if (showRawErrors) {
      _Presenter().showOkCancelDialog(
        context,
        title: title,
        message: message,
        okButtonTitle: 'Copy',
        onOk: (_) => _onCopyText(context, text: message),
        cancelButtonTitle: 'OK',
        onCancel: handler,
      );
    } else {
      _Presenter().showErrorDialog(
        context,
        title: title,
        message: message,
        onPressed: handler,
      );
    }
  }
}

// Private
extension Private on ShowErrorDialogMixin {
  ErrorMessage _networkError(
    BuildContext context,
    NetworkError e,
  ) {
    if (e is ServiceTimeoutError) {
      return ErrorMessage.disconnected(context, message: e.message);
    } else if (e is UnauthenticatedError) {
      // TODO: ignore if should refresh token error: return ErrorMessage.ignore(context);
      return _appErrorMessage(context, e);
    } else {
      return _appErrorMessage(context, e);
    }
  }

  ErrorMessage _appErrorMessage(BuildContext context, AppError e) {
    final message = e.message;

    if (message.isNotEmpty) {
      return ErrorMessage.common(
        context,
        message: message,
        destination: e.errorDestination,
      );
    } else {
      final parentError = e.parentError;

      return parentError is NetworkError
          ? _networkError(context, parentError)
          : ErrorMessage.uncatch(context);
    }
  }

  void _onCopyText(
    BuildContext context, {
    required String text,
  }) {
    final trimmed = text.trim();
    Clipboard.setData(ClipboardData(text: trimmed));
  }
}

// Private
extension on AppError {
  ErrorMessageDestination get errorDestination {
    if (this is UnauthenticatedError) {
      return ErrorMessageDestination.dialog;
    }
    // else if (this is RefreshTokenError) {
    //   return ErrorMessageDestination.ignore;
    // }
    else {
      return ErrorMessageDestination.dialog;
    }
  }
}

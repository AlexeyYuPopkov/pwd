import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pwd/l10n/gen_l10n/localization.dart';
import 'package:pwd/theme/common_size.dart';

typedef _TestKey = DialogHelperTestHelper;

bool get _isMaterial => !(Platform.isIOS || Platform.isMacOS);

mixin DialogHelper {
  Future<T?> showMessage<T>(
    BuildContext context, {
    String? title,
    String? message,
    void Function(BuildContext)? onPressed,
  }) =>
      _isMaterial
          ? showDialog<T>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: title == null ? null : Text(title),
                  content: message == null ? null : Text(message),
                  actions: <Widget>[
                    TextButton(
                      child: Text(context.okButtonTitle),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            )
          : showCupertinoModalPopup<T>(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: title == null ? null : Text(title),
                content: message == null ? null : Text(message),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(context.okButtonTitle),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );

  Future<T?> showOkCancelDialog<T>(
    BuildContext context, {
    String? title,
    String? message,
    String? okButtonTitle,
    String? cancelButtonTitle,
    void Function(BuildContext)? onOk,
    void Function(BuildContext)? onCancel,
  }) =>
      _isMaterial
          ? showDialog<T>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  key: const Key(_TestKey.okCancelDialog),
                  title: title == null ? null : Text(title),
                  content: message == null ? null : Text(message),
                  actions: [
                    TextButton(
                      key: const Key(_TestKey.okCancelDialogOkButton),
                      onPressed: () =>
                          onOk == null ? Navigator.pop(context) : onOk(context),
                      child: Text(okButtonTitle ?? context.okButtonTitle),
                    ),
                    TextButton(
                      key: const Key(_TestKey.okCancelDialogCancelButton),
                      onPressed: () => onCancel == null
                          ? Navigator.pop(context)
                          : onCancel(context),
                      child:
                          Text(cancelButtonTitle ?? context.cancelButtonTitle),
                    ),
                  ],
                );
              },
            )
          : showCupertinoModalPopup<T>(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                key: const Key(_TestKey.okCancelDialog),
                title: title == null ? null : Text(title),
                content: message == null ? null : Text(message),
                actions: [
                  CupertinoDialogAction(
                    key: const Key(_TestKey.okCancelDialogOkButton),
                    onPressed: () =>
                        onOk == null ? Navigator.pop(context) : onOk(context),
                    child: Text(okButtonTitle ?? context.okButtonTitle),
                  ),
                  CupertinoDialogAction(
                    key: const Key(_TestKey.okCancelDialogCancelButton),
                    isDefaultAction: true,
                    onPressed: () => onCancel == null
                        ? Navigator.pop(context)
                        : onCancel(context),
                    child: Text(cancelButtonTitle ?? context.cancelButtonTitle),
                  ),
                ],
              ),
            );

  Future<T?> showErrorDialog<T>(
    BuildContext context, {
    String? title,
    String? message,
    void Function(BuildContext)? onPressed,
  }) =>
      _isMaterial
          ? showDialog<T>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  key: const Key(DialogHelperTestHelper.errorDialog),
                  title: title == null ? null : Text(title),
                  content: message == null ? null : Text(message),
                  actions: [
                    TextButton(
                      onPressed: () => onPressed == null
                          ? Navigator.pop(context)
                          : onPressed(context),
                      child: Text(context.okButtonTitle),
                    ),
                  ],
                );
              },
            )
          : showCupertinoModalPopup<T>(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                key: const Key(DialogHelperTestHelper.errorDialog),
                title: title == null ? null : Text(title),
                content: message == null ? null : Text(message),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () => onPressed == null
                        ? Navigator.pop(context)
                        : onPressed(context),
                    child: Text(context.okButtonTitle),
                  ),
                ],
              ),
            );

  void showSnackBar(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          margin: const EdgeInsets.only(
            bottom: CommonSize.indent,
            left: CommonSize.indentVariant2x,
            right: CommonSize.indentVariant2x,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
}

// Localization
extension on BuildContext {
  Localization get localization => Localization.of(this)!;
  String get okButtonTitle => localization.commonOk;
  String get cancelButtonTitle => localization.commonCancel;
}

final class DialogHelperTestHelper {
  static const okCancelDialog = 'DialogHelperTestHelper.OkCancelDialog.TestKey';
  static const okCancelDialogOkButton =
      'DialogHelperTestHelper.test_ok_cancel_dialog_ok_button.TestKey';
  static const okCancelDialogCancelButton =
      'DialogHelperTestHelper.test_ok_cancel_dialog_cancel_button.TestKey';

  static const errorDialog = 'DialogHelperTestHelper.errorDialog.TestKey';
}

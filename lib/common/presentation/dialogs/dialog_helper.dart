import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:pwd/theme/common_size.dart';

mixin DialogHelper {
  showMessage(
    BuildContext context, {
    String? title,
    String? message,
    void Function(BuildContext)? onPressed,
  }) =>
      showPlatformDialog(
        context: context,
        builder: (context) => PlatformAlertDialog(
          title: title == null ? null : Text(title),
          content: message == null ? null : Text(message),
          actions: [
            PlatformDialogAction(
              onPressed: () => onPressed == null
                  ? Navigator.pop(context)
                  : onPressed(context),
              child: Text(context.okButtonTitle),
            ),
          ],
        ),
      );

  showOkCancelDialog(
    BuildContext context, {
    String? title,
    String? message,
    String? okButtonTitle,
    String? cancelButtonTitle,
    void Function(BuildContext)? onOk,
    void Function(BuildContext)? onCancel,
  }) =>
      showPlatformDialog(
        context: context,
        builder: (context) => PlatformAlertDialog(
          title: title == null ? null : Text(title),
          content: message == null ? null : Text(message),
          actions: [
            PlatformDialogAction(
              key: const Key('test_ok_cancel_dialog_ok_button'),
              onPressed: () =>
                  onOk == null ? Navigator.pop(context) : onOk(context),
              child: Text(okButtonTitle ?? context.okButtonTitle),
            ),
            PlatformDialogAction(
              key: const Key('test_ok_cancel_dialog_cancel_button'),
              onPressed: () =>
                  onCancel == null ? Navigator.pop(context) : onCancel(context),
              child: Text(cancelButtonTitle ?? context.cancelButtonTitle),
            ),
          ],
        ),
      );

  showErrorDialog(
    BuildContext context, {
    String? title,
    String? message,
    void Function(BuildContext)? onPressed,
  }) =>
      showPlatformDialog(
        context: context,
        builder: (context) => PlatformAlertDialog(
          title: title == null ? null : Text(title),
          content: message == null ? null : Text(message),
          actions: [
            PlatformDialogAction(
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
  String get okButtonTitle => 'OK';
  String get cancelButtonTitle => 'Cancel';
}
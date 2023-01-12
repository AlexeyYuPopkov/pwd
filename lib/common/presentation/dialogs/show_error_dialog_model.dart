part of 'show_error_dialog_mixin.dart';

enum ErrorMessageDestination {
  dialog,
  snackBar,
  ignore,
}

class ErrorMessage {
  final String title;
  final String message;
  final ErrorMessageDestination destination;

  ErrorMessage({
    required this.title,
    required this.message,
    required this.destination,
  });

  factory ErrorMessage.common(
    BuildContext context, {
    required String message,
    ErrorMessageDestination destination = ErrorMessageDestination.dialog,
  }) =>
      ErrorMessage(
        title: context.commonErrorTitle,
        message: message,
        destination: destination,
      );

  factory ErrorMessage.uncatch(BuildContext context) => ErrorMessage(
        title: context.commonErrorTitle,
        message: context.uncatchMessage,
        destination: ErrorMessageDestination.dialog,
      );

  factory ErrorMessage.ignore(BuildContext context) => ErrorMessage(
        title: '',
        message: '',
        destination: ErrorMessageDestination.ignore,
      );

  factory ErrorMessage.disconnected(
    BuildContext context, {
    required String message,
  }) =>
      ErrorMessage(
        title: context.disconnectedMessageTitle,
        message: message.isNotEmpty ? message : context.disconnectedMessage,
        destination: ErrorMessageDestination.dialog,
      );
}

// Private
extension ShowErrorDialogLocalization on BuildContext {
  String get commonErrorTitle => 'Error';

  String get uncatchMessage => 'Somthing went wrong';

  String get disconnectedMessageTitle => 'Error';

  String get disconnectedMessage => 'Network connection error';
}

import 'package:flutter/widgets.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/l10n/localization_helper.dart';
import 'package:pwd/notes/domain/model/db_error.dart';

final class ReadNoteUsecaseErrorMessageProvider {
  const ReadNoteUsecaseErrorMessageProvider();

  ErrorMessage? call(BuildContext context, Object e) {
    if (e is DbError) {
      switch (e) {
        case DbNotFoundError():
          return ErrorMessage.common(
            context,
            message: context.inputParametersAreWrong,
          );
      }
    }

    return null;
  }
}

extension on BuildContext {
  String get inputParametersAreWrong =>
      localization.readNoteUsecaseErrorInputParametersAreWrong;
}

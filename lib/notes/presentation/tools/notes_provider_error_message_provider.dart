import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/notes/domain/usecases/git_notes_provider_usecase.dart';

class NotesProviderErrorMessageProvider {
  const NotesProviderErrorMessageProvider();

  ErrorMessage? call(BuildContext context, Object e) {
    if (e is ReadNotesError) {
      return ErrorMessage.common(context, message: 'Read notes');
    } else if (e is UpdatetNoteError) {
      return ErrorMessage.common(context, message: 'Update note');
    } else if (e is NotesProviderError) {
      return ErrorMessage.common(
        context,
        message: 'Somthing went wrong with note provider',
      );
    }

    return null;
  }
}

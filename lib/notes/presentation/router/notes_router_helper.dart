import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_screen.dart';
import 'package:pwd/notes/presentation/note_details/note_details_page.dart';
import 'package:pwd/notes/presentation/notes_list/note_page_route.dart';
import 'package:pwd/notes/presentation/notes_list/notes_list_screen.dart';
import 'package:pwd/unauth/presentation/router/redirect_to_login_page_helper.dart';

final class NotesRouterHelper with RedirectToLoginPageHelper {
  @override
  final bool Function() isAuthorized;

  NotesRouterHelper({required this.isAuthorized});

  Widget getInitialScreen({required RemoteConfiguration configuration}) {
    return NotesListScreen(
      configuration: configuration,
      onRoute: onRoute,
    );
  }

  late final routes = [
    // final path = NotesRouterOnDetailPath();
    GoRoute(
      path: NotesRouterOnDetailPath.shortPath,
      builder: (context, state) {
        final input = state.extra as BaseNoteItem;
        return NoteDetailsPage(noteItem: input);
      },
      redirect: redirectToLoginPage,
    ),
    GoRoute(
      path: NotesRouterOnEditPath.shortPath,
      builder: (context, state) {
        final input = state.extra as EditNoteScreenInput;

        return EditNoteScreen(
          input: input,
          onRoute: onRoute,
        );
      },
      redirect: redirectToLoginPage,
    ),
  ];

  Future onRoute(BuildContext context, Object action) async {
    if (action is EditNotePagePopResult) {
      return Navigator.of(context).pop(
        const NotePageRoute.shouldSync(),
      );
    } else if (action is NotePageRoute) {
      switch (action) {
        case NotePageOnDetails():
          context.go(
            NotesRouterOnDetailPath.goPath(
              configId: action.config.id,
              noteId: action.noteItem.id,
            ),
            extra: action.noteItem,
          );
          break;
        case NotePageOnEdit():
          context.go(
            NotesRouterOnEditPath.goPath(
              configId: action.config.id,
              noteId: action.noteItem.id,
            ),
            extra: EditNoteScreenInput(
              configuration: action.config,
              noteItem: action.noteItem,
            ),
          );
          break;

        case NotePageShouldSync():
          break;
      }
    }
  }
}

final class NotesRouterOnDetailPath {
  static const shortPath = 'note:note_id';

  static String goPath({required String configId, required String noteId}) =>
      '/home:$configId/note:$noteId';

  static String? configId(Map<String, String> params) =>
      params['id']?.substring(1);
}

final class NotesRouterOnEditPath {
  static const shortPath = 'edit_note:note_id';

  static String goPath({required String configId, required String noteId}) =>
      '/home:$configId/edit_note:$noteId';
}

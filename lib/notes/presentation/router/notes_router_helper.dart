import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pwd/notes/presentation/edit_note/bloc/edit_note_page_data.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_screen.dart';
import 'package:pwd/notes/presentation/note_details/note_details_screen.dart';
import 'package:pwd/notes/presentation/notes_list/note_page_route.dart';
import 'package:pwd/notes/presentation/notes_list/notes_list_screen.dart';
import 'package:pwd/unauth/presentation/router/path_parameters.dart';
import 'package:pwd/unauth/presentation/router/redirect_to_login_page_helper.dart';

final class NotesRouterHelper with RedirectToLoginPageHelper {
  @override
  final bool Function() isAuthorized;

  NotesRouterHelper({required this.isAuthorized});

  Widget getInitialScreen({required String? configId}) => NotesListScreen(
        configId: configId,
        // configuration: configuration,
        onRoute: onRoute,
      );

  late final routes = [
    GoRoute(
      path: NotesRouterOnDetailPath.shortPath,
      name: NotesRouterOnDetailPath.name,
      builder: (_, state) {
        return NoteDetailsScreen(
          noteId: PathParameters.getNoteId(
            pathParameters: state.pathParameters,
          ),
          configId: PathParameters.getConfigId(
            pathParameters: state.pathParameters,
          ),
        );
      },
      redirect: redirectToLoginPage,
    ),
    GoRoute(
      path: NotesRouterOnCreatePath.shortPath,
      name: NotesRouterOnCreatePath.name,
      builder: (context, state) {
        return EditNoteScreen(
          input: EditNoteScreenInput.create(
            configId: PathParameters.getConfigId(
              pathParameters: state.pathParameters,
            ),
          ),
          onRoute: onRoute,
        );
      },
      redirect: redirectToLoginPage,
    ),
    GoRoute(
      path: NotesRouterOnUpdatePath.shortPath,
      name: NotesRouterOnUpdatePath.name,
      builder: (context, state) {
        return EditNoteScreen(
          input: EditNoteScreenInput.update(
            configId: PathParameters.getConfigId(
              pathParameters: state.pathParameters,
            ),
            noteId: PathParameters.getNoteId(
              pathParameters: state.pathParameters,
            ),
          ),
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
            NotesRouterOnDetailPath.namedLocation(
              context,
              action: action,
            ),
          );
          break;

        case NotePageShouldSync():
          break;
        case NotePageOnUpdate():
          context.go(
            NotesRouterOnUpdatePath.namedLocationUpdate(
              context,
              configId: action.configId,
              noteId: action.noteId,
            ),
          );
          break;
        case NotePageOnCreate():
          context.go(
            NotesRouterOnCreatePath.namedLocationCreate(
              context,
              configId: action.configId,
            ),
          );
          break;
      }
    }
  }
}

final class NotesRouterOnDetailPath {
  static const name = 'NoteDetailsScreen';
  static const shortPath = 'note/:note_id';

  static String namedLocation(
    BuildContext context, {
    required NotePageOnDetails action,
  }) =>
      context.namedLocation(
        NotesRouterOnDetailPath.name,
        pathParameters: {
          PathParameters.configId: action.config.id,
          PathParameters.noteId: action.noteItem.id,
        },
      );
}

final class NotesRouterOnUpdatePath {
  static const name = 'EditNoteScreen_Update';
  static const shortPath = 'update_note/:note_id';

  static String namedLocationUpdate(
    BuildContext context, {
    required String configId,
    required String noteId,
  }) =>
      context.namedLocation(
        NotesRouterOnUpdatePath.name,
        pathParameters: {
          PathParameters.configId: configId,
          PathParameters.noteId: noteId,
        },
      );
}

final class NotesRouterOnCreatePath {
  static const name = 'EditNoteScreen_Create';
  static const shortPath = 'create_note';

  static String namedLocationCreate(
    BuildContext context, {
    required String configId,
  }) =>
      context.namedLocation(
        NotesRouterOnCreatePath.name,
        pathParameters: {
          PathParameters.configId: configId,
        },
      );
}

import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/presentation/fade_animation_page.dart';
import 'package:pwd/common/presentation/router/base_router_delegate.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_page.dart';
import 'package:pwd/notes/presentation/git_notes_list/note_page_route.dart';

import 'package:pwd/notes/presentation/note_details/note_details_page.dart';
import 'package:pwd/notes/presentation/google_drive_notes_list/google_drive_notes_list_screen.dart';

abstract final class GoogleDriveItemRouterPagePath {
  static const noteList = 'google_drive_item';
}

final class GoogleDriveItemRouterDelegate extends BaseRouterDelegate {
  final RemoteConfiguration configuration;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  GoogleDriveItemRouterDelegate({
    required this.navigatorKey,
    required this.configuration,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        FadeAnimationPage(
          child: GoogleDriveNotesListScreen(
            configuration: configuration,
            onRoute: onRoute,
          ),
          name: GoogleDriveItemRouterPagePath.noteList,
        )
      ],
      onPopPage: (route, result) {
        updateState();
        if (!route.didPop(result)) {
          return false;
        }

        if (context.navigator.canPop()) {
          return true;
        }

        return false;
      },
    );
  }

  @override
  List<Page> get initialPages => [
        FadeAnimationPage(
          child: GoogleDriveNotesListScreen(
            onRoute: onRoute,
            configuration: configuration,
          ),
          name: GoogleDriveItemRouterPagePath.noteList,
        ),
      ];

  @override
  Future onRoute(BuildContext context, Object action) async {
    if (action is EditNotePagePopResult) {
      return context.navigator.pop(
        const NotePageRoute.shouldSync(),
      );
    } else if (action is NotePageRoute) {
      switch (action) {
        case NotePageOnEdit():
          return context.navigator.push(
            MaterialPageRoute(
              builder: (_) {
                return EditNotePage(
                  configuration: configuration,
                  noteItem: action.noteItem,
                  onRoute: onRoute,
                );
              },
            ),
          ).then(
            (result) {
              updateState();
              return result;
            },
          );
        case NotePageOnDetails():
          return context.navigator.push(
            MaterialPageRoute(
              builder: (_) => NoteDetailsPage(
                noteItem: action.noteItem,
              ),
            ),
          );
        case NotePageShouldSync():
          break;
      }
    }
  }
}

extension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
}

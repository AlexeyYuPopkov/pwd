import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/presentation/fade_animation_page.dart';
import 'package:pwd/common/presentation/router/base_router_delegate.dart';
import 'package:di_storage/di_storage.dart';
import 'package:pwd/notes/domain/usecases/sync_google_drive_item_usecase.dart';
import 'package:pwd/notes/domain/usecases/google_drive_notes_provider_usecase.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_page.dart';
import 'package:pwd/notes/presentation/note/note_page_route.dart';
import 'package:pwd/notes/presentation/note_details/note_details_page.dart';
import 'package:pwd/notes/presentation/notes_list_variant/google_drive_notes_list_screen.dart';

abstract final class GoogleDriveItemRouterPagePath {
  static const noteList = 'google_drive_item';
}

final class GoogleDriveItemRouterDelegate extends BaseRouterDelegate {
  final GoogleDriveConfiguration configuration;

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
                final di = DiStorage.shared;
                return EditNotePage(
                  configuration: configuration,
                  noteItem: action.noteItem,
                  onRoute: onRoute,
                  notesProviderUsecase:
                      di.resolve<GoogleDriveNotesProviderUsecase>(),
                  syncDataUsecase: di.resolve<SyncGoogleDriveItemUsecase>(),
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

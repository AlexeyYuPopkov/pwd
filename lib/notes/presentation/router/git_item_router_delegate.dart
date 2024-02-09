import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/presentation/fade_animation_page.dart';
import 'package:pwd/common/presentation/router/base_router_delegate.dart';
import 'package:di_storage/di_storage.dart';
import 'package:pwd/notes/domain/usecases/git_notes_provider_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_git_item_usecase.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_page.dart';
import 'package:pwd/notes/presentation/note/git_notes_list_screen.dart';
import 'package:pwd/notes/presentation/note/note_page_route.dart';
import 'package:pwd/notes/presentation/note_details/note_details_page.dart';

abstract final class GitItemRouterPagePath {
  static const note = 'git_item';
}

final class GitItemRouterDelegate extends BaseRouterDelegate {
  final GitConfiguration configuration;
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  GitItemRouterDelegate({
    required this.navigatorKey,
    required this.configuration,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        FadeAnimationPage(
          child: GitNotesListScreen(
            configuration: configuration,
            onRoute: onRoute,
          ),
          name: GitItemRouterPagePath.note,
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
          child: GitNotesListScreen(
            configuration: configuration,
            onRoute: onRoute,
          ),
          name: GitItemRouterPagePath.note,
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
                  noteItem: action.noteItem,
                  configuration: configuration,
                  onRoute: onRoute,
                  notesProviderUsecase: di.resolve<GitNotesProviderUsecase>(),
                  syncDataUsecase: di.resolve<SyncGitItemUsecase>(),
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

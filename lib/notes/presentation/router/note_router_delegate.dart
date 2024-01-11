import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/fade_animation_page.dart';
import 'package:pwd/common/presentation/router/base_router_delegate.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_page.dart';
import 'package:pwd/notes/presentation/note/note_page.dart';
import 'package:pwd/notes/presentation/note/note_page_route.dart';
import 'package:pwd/notes/presentation/note_details/note_details_page.dart';

abstract final class MainRouterPagePath {
  static const note = 'note';
  static const editNote = 'note/edit';
}

final class NoteRouterDelegate extends BaseRouterDelegate {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  NoteRouterDelegate({required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        FadeAnimationPage(
          child: NotePage(onRoute: onRoute),
          name: MainRouterPagePath.note,
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
          child: NotePage(onRoute: onRoute),
          name: MainRouterPagePath.note,
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
                  noteItem: action.noteItem,
                  onRoute: onRoute,
                  notesProviderUsecase: DiStorage.shared.resolve(),
                  syncDataUsecase: DiStorage.shared.resolve(),
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

import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/fade_animation_page.dart';
import 'package:pwd/common/presentation/router/base_router_delegate.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/domain/usecases/google_sync_usecase.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase_variant.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_page.dart';
import 'package:pwd/notes/presentation/note/note_page.dart';
import 'package:pwd/notes/presentation/note/note_page_route.dart';
import 'package:pwd/notes/presentation/note_details/note_details_page.dart';
import 'package:pwd/notes/presentation/notes_list_variant/notes_list_variant.dart';

abstract final class NoteRouterVariantPagePath {
  static const noteList = 'note_list_variant';
  // static const editNote = 'note/edit';
}

final class NoteRouterVariantDelegate extends BaseRouterDelegate {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  NoteRouterVariantDelegate({required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        FadeAnimationPage(
          child: NotesListVariant(onRoute: onRoute),
          name: NoteRouterVariantPagePath.noteList,
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
          name: NoteRouterVariantPagePath.noteList,
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
                  notesProviderUsecase:
                      DiStorage.shared.resolve<NotesProviderUsecaseVariant>(),
                  syncDataUsecase:
                      DiStorage.shared.resolve<GoogleSyncUsecase>(),
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

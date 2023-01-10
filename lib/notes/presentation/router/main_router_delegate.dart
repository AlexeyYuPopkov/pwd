import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/fade_animation_page.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_page.dart';
import 'package:pwd/notes/presentation/note/note_page.dart';
import 'package:pwd/notes/presentation/router/main_route_data.dart';

class MainRouterPagePath {
  static const note = 'note';
  static const editNote = 'note/edit';
}

class MainRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MainRouterDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  void updateState() {
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        FadeAnimationPage(
          child: NotePage(onRoute: _onRoute),
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

  Future _onRoute(BuildContext context, MainRouteData action) async {
    if (action is OnNoteEdit) {
      return context.navigator.push(
        MaterialPageRoute(
          builder: (_) {
            return EditNotePage(
              noteItem: action.noteItem,
              onRoute: _onRoute,
            );
          },
        ),
      ).then(
        (_) => updateState(),
      );
    } else if (action is EditNotePageResult) {
      return context.navigator.pop(action.noteItem);
    }
  }

  void parseUri(Uri uri) {}

  @override
  Future<void> setNewRoutePath(configuration) {
    return Future.value(null);
  }
}

extension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
}

/*
 * Copyright (c) 2022-2022.
 * System Technologies <support@st.by>.
 * Alexey Popkov <popkov_oy@st.by> is author  this file.
 * The file more_router_delegate.dart is part of UnifiedProject.
 * UnifiedProject can not be copied and/or distributed without the express permission of System Technologies.
 */

import 'package:flutter/material.dart';
import 'package:pwd/view/edit_note/edit_note_page.dart';
import 'package:pwd/view/note/note_page.dart';
import 'package:pwd/view/router/common/fade_animation_page.dart';
import 'package:pwd/view/router/note_page_configuration.dart';
import 'package:pwd/view/router/main_page_action.dart';
import 'package:pwd/view/router/main_router_state.dart';

import 'package:pwd/view/router/common/page_configuration.dart';
import 'package:pwd/view/router/route_pages_stack.dart';
import 'package:pwd/view/router/router_delegate_tools.dart';

class MainRouterDelegate extends RouterDelegate<PageConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageConfiguration>,
        RouterDelegateTools {
  MainRouterState _state;
  final List<String> _initialPathComponents;
  final BuildContext Function() parentContextProvider;

  final GlobalKey<NavigatorState> _navigatorKey;

  late final RoutePagesStack _stack = _initialStack(
    state: _state,
    onRoute: _onRoute,
  );

  MainRouterState get state => _state;

  set state(MainRouterState value) {
    if (value != _state) {
      _state = value;
      notifyListeners();
    }
  }

  MainRouterDelegate({
    required MainRouterState state,
    required List<String> initialPathComponents,
    required this.parentContextProvider,
  })  : _state = state,
        _initialPathComponents = initialPathComponents,
        _navigatorKey = GlobalKey<NavigatorState>() {
    _state.addListener(notifyListeners);
  }

  List<String> get pathComponents => [
        ..._initialPathComponents,
        ..._stack.pathComponents,
      ];

  @override
  PageConfiguration? get currentConfiguration =>
      state.selectedPage ?? NotePageConfiguration();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _stack.pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (state.selectedPage != null) {
          _stack.pop();
          state.selectedPage = null;
          notifyListeners();

          return true;
        }

        return false;
      },
    );
  }

  void _onRoute(BuildContext context, MainPageAction action) {
    final pageConfiguration = action._pageConfiguration;

    // Test push fullscreen
    // if (pageConfiguration is MoreAboutPageConfiguration) {
    //   final parentContext = parentContextProvider();
    //   Navigator.of(parentContext).push(
    //     MaterialPageRoute(
    //       builder: (context) => const AboutPage(),
    //     ),
    //   );
    //   return;
    // }

    if (pageConfiguration != null) {
      final page = _getPages(pageConfiguration);
      _stack.push(page);
      state.selectedPage = pageConfiguration;
    }
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    return Future.value(null);
  }

  void parseUri(Uri uri) {}
}

extension on MainPageAction {
  PageConfiguration? get _pageConfiguration {
    if (this is OnNoteEdit) {
      return EditNotePageConfiguration();
    } else {
      return null;
    }
  }
}

// Private tools
extension on MainRouterDelegate {
  RoutePagesStack _initialStack({
    required MainRouterState state,
    required void Function(BuildContext, MainPageAction) onRoute,
  }) {
    final initialPage = state.initialPage;

    if (initialPage is NotePageConfiguration) {
      return RoutePagesStack(
        pages: [
          FadeAnimationPage(
            child: NotePage(
              onRoute: onRoute,
            ),
            name: initialPage.name,
          ),
        ],
      );
    } else {
      throw Exception('Impossible case');
    }
  }

  Page _getPages(PageConfiguration selected) {
    if (selected is NotePageConfiguration) {
      return createMaterialPage(
        child: NotePage(
          onRoute: _onRoute,
        ),
        config: selected,
      );
    } else if (selected is EditNotePageConfiguration) {
      return createMaterialPage(
        child: const EditNotePage(),
        config: selected,
      );
    } else {
      throw UnimplementedError('Impossible case');
    }
  }
}

// Navigate to bank message
// extension MoreRouterDelegateBankMessages on MainRouterDelegate {
//   void navigateToBankMessageWithId(String id) {
//     final pageConfiguration = BankMessagesPageConfiguration(
//       initialPages: [
//         BankMessagePageConfiguration(
//           messageId: null,
//           mailingId: id,
//         ),
//       ],
//       initialPath: _stack.pages.first.name!,
//     );

//     _stack.push(_getAuthPage(pageConfiguration));
//     state.selectedPage = pageConfiguration;
//   }
// }

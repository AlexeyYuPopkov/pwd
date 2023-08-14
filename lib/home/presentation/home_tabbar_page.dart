import 'package:flutter/material.dart';
import 'package:pwd/notes/presentation/router/note_router_delegate.dart';
import 'package:pwd/settings/presentation/router/settings_router_delegate.dart';
import 'package:pwd/theme/common_size.dart';

final _noteRouterKey = GlobalKey<NavigatorState>();
final _settingsRouterKey = GlobalKey<NavigatorState>();

class HomeTabbarPage extends StatelessWidget {
  const HomeTabbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > constraints.maxHeight) {
        return const HomeTabbarPageDesktopContent();
      } else {
        return const HomeTabbarPageMobileContent();
      }
    });
  }
}

class HomeTabbarPageDesktopContent extends StatefulWidget {
  const HomeTabbarPageDesktopContent({super.key});

  @override
  State<HomeTabbarPageDesktopContent> createState() =>
      _HomeTabbarPageDesktopContentState();
}

class _HomeTabbarPageDesktopContentState
    extends State<HomeTabbarPageDesktopContent> {
  static const initialTabIndex = 0;
  int _selectedIndex = initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => _onTap(index),
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.home),
                label: Text(context.homeTabName),
              ),
              NavigationRailDestination(
                icon: const Icon(
                  Icons.settings,
                  key: Key('test_bottom_navigation_bar_settings_item_icon'),
                ),
                label: Text(context.settingsTabName),
              ),
            ],
          ),
          const VerticalDivider(
            thickness: CommonSize.thickness,
            width: CommonSize.thickness,
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                Router(
                  routerDelegate: NoteRouterDelegate(
                    navigatorKey: _noteRouterKey,
                  ),
                ),
                Router(
                  routerDelegate: SettingsRouterDelegate(
                    navigatorKey: _settingsRouterKey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }
}

class HomeTabbarPageMobileContent extends StatefulWidget {
  const HomeTabbarPageMobileContent({super.key});

  @override
  State<HomeTabbarPageMobileContent> createState() =>
      _HomeTabbarPageMobileContentState();
}

class _HomeTabbarPageMobileContentState
    extends State<HomeTabbarPageMobileContent> {
  static const initialTabIndex = 0;

  int _selectedIndex = initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Router(
            routerDelegate: NoteRouterDelegate(navigatorKey: _noteRouterKey),
          ),
          Router(
            routerDelegate: SettingsRouterDelegate(
              navigatorKey: _settingsRouterKey,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: context.homeTabName,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.settings,
              key: Key('test_bottom_navigation_bar_settings_item_icon'),
            ),
            label: context.settingsTabName,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }

  void _onTap(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }
}

extension on BuildContext {
  String get homeTabName => 'Home';
  String get settingsTabName => 'Settings';
}

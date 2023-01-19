import 'package:flutter/material.dart';
import 'package:pwd/notes/presentation/router/note_router_delegate.dart';
import 'package:pwd/settings/presentation/router/settings_router_delegate.dart';

class HomeTabbarPage extends StatefulWidget {
  const HomeTabbarPage({super.key});

  @override
  State<HomeTabbarPage> createState() => _HomeTabbarPageState();
}

class _HomeTabbarPageState extends State<HomeTabbarPage> {
  static const initialTabIndex = 0;
  late final _noteRouterKey = GlobalKey<NavigatorState>();
  late final _settingsRouterKey = GlobalKey<NavigatorState>();
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

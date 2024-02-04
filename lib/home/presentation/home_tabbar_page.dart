import 'package:flutter/material.dart';
import 'package:pwd/home/presentation/home_tabbar_tab_model.dart';
import 'package:pwd/theme/common_size.dart';

final class HomeTabbarPage extends StatelessWidget {
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

final class HomeTabbarPageDesktopContent extends StatefulWidget {
  const HomeTabbarPageDesktopContent({super.key});

  @override
  State<HomeTabbarPageDesktopContent> createState() =>
      _HomeTabbarPageDesktopContentState();
}

final class _HomeTabbarPageDesktopContentState
    extends State<HomeTabbarPageDesktopContent> {
  static const initialTabIndex = 0;
  List<HomeTabbarTabModel> get tabs => HomeTabbarTabModel.tabs;

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
              for (final tab in tabs)
                tab.buildNavigationRailDestination(context)
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
                for (final tab in tabs) tab.buildRoute(context),
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

final class HomeTabbarPageMobileContent extends StatefulWidget {
  const HomeTabbarPageMobileContent({super.key});

  @override
  State<HomeTabbarPageMobileContent> createState() =>
      _HomeTabbarPageMobileContentState();
}

final class _HomeTabbarPageMobileContentState
    extends State<HomeTabbarPageMobileContent> {
  static const initialTabIndex = 0;

  List<HomeTabbarTabModel> get tabs => HomeTabbarTabModel.tabs;

  int _selectedIndex = initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          for (final tab in tabs) tab.buildRoute(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (final tab in tabs) tab.buildNavigationBarItem(context),
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

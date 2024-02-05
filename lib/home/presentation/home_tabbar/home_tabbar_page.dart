import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_tab_model.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/home_tabbar_bloc.dart';
import 'bloc/home_tabbar_bloc_state.dart';

final class HomeTabbarPage extends StatelessWidget {
  const HomeTabbarPage({super.key});

  void _listener(BuildContext context, HomeTabbarBlocState state) {}
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeTabbarBloc(
        remoteConfigurationsProvider: DiStorage.shared.resolve(),
      ),
      child: BlocConsumer<HomeTabbarBloc, HomeTabbarBlocState>(
        listener: _listener,
        builder: (context, state) {
          return LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > constraints.maxHeight) {
              return HomeTabbarPageDesktopContent(tabs: state.data.tabs);
            } else {
              return HomeTabbarPageMobileContent(
                tabs: state.data.tabs,
              );
            }
          });
        },
      ),
    );
  }
}

final class HomeTabbarPageDesktopContent extends StatefulWidget {
  final List<HomeTabbarTabModel> tabs;
  const HomeTabbarPageDesktopContent({super.key, required this.tabs});

  @override
  State<HomeTabbarPageDesktopContent> createState() =>
      _HomeTabbarPageDesktopContentState();
}

final class _HomeTabbarPageDesktopContentState
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
              for (final tab in widget.tabs)
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
                for (final tab in widget.tabs) tab.buildRoute(context),
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
  final List<HomeTabbarTabModel> tabs;

  const HomeTabbarPageMobileContent({super.key, required this.tabs});

  @override
  State<HomeTabbarPageMobileContent> createState() =>
      _HomeTabbarPageMobileContentState();
}

final class _HomeTabbarPageMobileContentState
    extends State<HomeTabbarPageMobileContent> {
  static const initialTabIndex = 0;

  int _selectedIndex = initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          for (final tab in widget.tabs) tab.buildRoute(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (final tab in widget.tabs) tab.buildNavigationBarItem(context),
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

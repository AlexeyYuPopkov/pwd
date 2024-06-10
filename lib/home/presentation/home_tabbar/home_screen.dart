import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/home/presentation/home_tabbar/bloc/home_tabbar_bloc.dart';
import 'package:pwd/home/presentation/home_tabbar/bloc/home_tabbar_bloc_state.dart';
import 'package:pwd/theme/common_size.dart';
import 'bloc/home_tabbar_bloc_event.dart';

final class HomeScreen extends StatelessWidget {
  final HomeTabbarBloc bloc;
  final Widget child;

  const HomeScreen({super.key, required this.bloc, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlockingLoadingIndicator(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > constraints.maxHeight) {
            return HomDesktopScreen(
              bloc: bloc,
              onTap: _onTap,
              child: child,
            );
          } else {
            return HomeMobileScreen(
              bloc: bloc,
              onTap: _onTap,
              child: child,
            );
          }
        },
      ),
    );
  }

  void _onTap(int index) => bloc.add(
        HomeTabbarBlocEvent.shouldChangeSelectedTabIndex(
          index: index,
        ),
      );
}

final class HomeMobileScreen extends StatelessWidget {
  final HomeTabbarBloc bloc;
  final Widget child;
  final ValueChanged<int> onTap;

  const HomeMobileScreen({
    super.key,
    required this.bloc,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<HomeTabbarBloc, HomeTabbarBlocState>(
        builder: (context, state) {
          return Scaffold(
            body: state.data.tabs.isEmpty ? const SizedBox() : child,
            bottomNavigationBar: state.data.tabs.isEmpty
                ? null
                : BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    items: [
                      for (final tab in state.data.tabs)
                        tab.buildNavigationBarItem(context),
                    ],
                    currentIndex: state.data.index,
                    onTap: onTap,
                  ),
          );
        },
      ),
    );
  }
}

final class HomDesktopScreen extends StatelessWidget {
  final HomeTabbarBloc bloc;
  final Widget child;
  final ValueChanged<int> onTap;

  const HomDesktopScreen({
    super.key,
    required this.bloc,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<HomeTabbarBloc, HomeTabbarBlocState>(
        builder: (context, state) {
          return Scaffold(
            body: state.data.tabs.isEmpty
                ? const SizedBox()
                : Row(
                    children: [
                      NavigationRail(
                        selectedIndex: state.data.index,
                        onDestinationSelected: onTap,
                        destinations: [
                          for (final tab in state.data.tabs)
                            tab.buildNavigationRailDestination(context)
                        ],
                      ),
                      const VerticalDivider(
                        thickness: CommonSize.thickness,
                        width: CommonSize.thickness,
                      ),
                      Expanded(child: child),
                      // Expanded(
                      //   child: IndexedStack(
                      //     index: state.data.index,
                      //     children: [
                      //       for (final tab in state.data.tabs)
                      //         tab.buildRoute(context),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

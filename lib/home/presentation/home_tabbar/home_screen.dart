import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/presentation/adaptive_layout_helper.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/common_highlighted_row.dart';
import 'package:pwd/home/presentation/home_tabbar/bloc/home_folders_bloc.dart';
import 'package:pwd/home/presentation/home_tabbar/bloc/home_folders_bloc_state.dart';
import 'package:pwd/l10n/localization_helper.dart';
import 'package:pwd/theme/common_size.dart';
import 'package:pwd/theme/common_theme.dart';
import 'bloc/home_folders_bloc_event.dart';
import 'folder_model.dart';

final class HomeScreen extends StatelessWidget with AdaptiveLayoutHelper {
  final HomeFoldersBloc bloc;
  final Widget child;

  const HomeScreen({super.key, required this.bloc, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlockingLoadingIndicator(
      child: isLandscape(context)
          ? HomDesktopScreen(
              bloc: bloc,
              onTap: _onTap,
              child: child,
            )
          : HomeMobileScreen(
              bloc: bloc,
              onTap: _onTap,
              child: child,
            ),
    );
  }

  void _onTap(int index) => bloc.add(
        HomeFoldersBlocEvent.shouldChangeSelectedTabIndex(
          index: index,
        ),
      );
}

final class HomDesktopScreen extends StatelessWidget {
  final HomeFoldersBloc bloc;
  final Widget child;
  final ValueChanged<int> onTap;

  const HomDesktopScreen({
    super.key,
    required this.bloc,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<HomeFoldersBloc, HomeFoldersBlocState>(
          builder: (context, state) {
            return Scaffold(
              body: state.data.folders.isEmpty
                  ? const SizedBox()
                  : Row(
                      children: [
                        NavigationRail(
                          selectedIndex: state.data.index,
                          onDestinationSelected: onTap,
                          destinations: [
                            for (final tab in state.data.folders)
                              tab.buildNavigationRailDestination(context)
                          ],
                        ),
                        const VerticalDivider(
                          thickness: CommonSize.thickness,
                          width: CommonSize.thickness,
                        ),
                        Expanded(child: child),
                      ],
                    ),
            );
          },
        ),
      );
}

final class HomeMobileScreen extends StatelessWidget {
  final HomeFoldersBloc bloc;
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
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<HomeFoldersBloc, HomeFoldersBlocState>(
        builder: (context, state) {
          final itemsCount = state.data.folders.length;
          return Scaffold(
            body: child,
            drawer: Drawer(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: CommonSize.indent4x,
                        left: CommonSize.indent2x,
                        right: CommonSize.indent,
                        bottom: CommonSize.indent2x,
                      ),
                      child: Text(
                        context.drawerTitle,
                        style: theme.textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: state.data.folders.isEmpty
                          ? const SizedBox()
                          : ListView.builder(
                              cacheExtent: CommonSize.rowHeight,
                              itemBuilder: (context, index) =>
                                  state.data.folders[index].folderDrawerItem(
                                context,
                                isSelected: index == state.data.index,
                                onTap: () {
                                  Scaffold.of(context).closeDrawer();
                                  onTap(index);
                                },
                              ),
                              itemCount: itemsCount,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

final class FolderDrawerItem extends StatelessWidget {
  final FolderModel item;
  final bool isSelected;
  final VoidCallback? onTap;

  const FolderDrawerItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);
    return SizedBox(
      height: CommonSize.rowHeight,
      child: CommonHighlightedRow(
        highlightedColor: commonTheme.highlightColor,
        onTap: onTap,
        color: isSelected ? commonTheme.highlightColor : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: CommonSize.indent2x),
          child: Row(
            children: [
              item.buildDrawerItemIcon(context),
              const SizedBox(width: CommonSize.indent),
              Expanded(
                child: Text(
                  item.buildDrawerItemName(context),
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on BuildContext {
  String get drawerTitle => localization.homeScreenDrawerTitle;
}

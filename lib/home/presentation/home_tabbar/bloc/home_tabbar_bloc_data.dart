import 'package:equatable/equatable.dart';

import 'package:pwd/home/presentation/home_tabbar/home_tabbar_tab_model.dart';

final class HomeTabbarBlocData extends Equatable {
  final int index;
  final List<HomeTabbarTabModel> tabs;

  const HomeTabbarBlocData._({required this.index, required this.tabs});

  factory HomeTabbarBlocData.initial() {
    return const HomeTabbarBlocData._(
      index: 0,
      tabs: [],
    );
  }

  @override
  List<Object?> get props => [tabs, index];

  HomeTabbarBlocData copyWith({
    int? index,
    List<HomeTabbarTabModel>? tabs,
  }) {
    if (index != null) {
      assert(index >= 0);
      if (index < 0) {
        return this;
      }
    }

    return HomeTabbarBlocData._(
      index: index ?? this.index,
      tabs: tabs ?? this.tabs,
    );
  }
}

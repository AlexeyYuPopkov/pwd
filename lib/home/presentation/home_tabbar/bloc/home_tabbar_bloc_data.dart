import 'package:equatable/equatable.dart';

import 'package:pwd/home/presentation/home_tabbar/home_tabbar_tab_model.dart';

final class HomeTabbarBlocData extends Equatable {
  final List<HomeTabbarTabModel> tabs;

  const HomeTabbarBlocData._({required this.tabs});

  factory HomeTabbarBlocData.initial() {
    return const HomeTabbarBlocData._(
      tabs: [
        ConfigurationUndefinedTab(),
        SettingsTab(),
      ],
    );
  }

  @override
  List<Object?> get props => [tabs];

  HomeTabbarBlocData copyWith({
    List<HomeTabbarTabModel>? tabs,
  }) {
    return HomeTabbarBlocData._(
      tabs: tabs ?? this.tabs,
    );
  }
}

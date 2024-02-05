import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_tab_model.dart';

import 'home_tabbar_bloc_data.dart';
import 'home_tabbar_bloc_event.dart';
import 'home_tabbar_bloc_state.dart';

final class HomeTabbarBloc
    extends Bloc<HomeTabbarBlocEvent, HomeTabbarBlocState> {
  final RemoteStorageConfigurationProvider remoteConfigurationsProvider;
  HomeTabbarBlocData get data => state.data;

  HomeTabbarBloc({required this.remoteConfigurationsProvider})
      : super(
          HomeTabbarBlocState.common(
            data: HomeTabbarBlocData.initial(),
          ),
        ) {
    _setupHandlers();

    add(const HomeTabbarBlocEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<HomeTabbarBlocState> emit,
  ) {
    try {
      final configuration = remoteConfigurationsProvider.currentConfiguration;

      final tabs = <HomeTabbarTabModel>[
        ...configuration.configurations.map(
          (e) {
            switch (e) {
              case GitConfiguration():
                return const GitTab();
              case GoogleDriveConfiguration():
                return const GoogleTab();
            }
          },
        ),
        const SettingsTab(),
      ];

      emit(
        HomeTabbarBlocState.common(data: data.copyWith(tabs: tabs)),
      );
    } catch (e) {
      emit(HomeTabbarBlocState.error(e: e, data: data));
    }
  }
}

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_tab_model.dart';

import 'home_tabbar_bloc_data.dart';
import 'home_tabbar_bloc_event.dart';
import 'home_tabbar_bloc_state.dart';

final class HomeTabbarBloc
    extends Bloc<HomeTabbarBlocEvent, HomeTabbarBlocState> {
  final RemoteConfigurationProvider remoteConfigurationsProvider;
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
    on<InitialEvent>(
      _onInitialEvent,
      transformer: sequential(),
    );
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<HomeTabbarBlocState> emit,
  ) async {
    try {
      emit(HomeTabbarBlocState.loading(data: data));

      final configuration =
          await remoteConfigurationsProvider.readConfiguration();

      final tabs = <HomeTabbarTabModel>[
        if (configuration.configurations.isEmpty)
          const ConfigurationUndefinedTab()
        else
          ...configuration.configurations.map(
            (e) {
              switch (e) {
                case GitConfiguration():
                  return GitTab(configuration: e);
                case GoogleDriveConfiguration():
                  return GoogleDriveTab(configuration: e);
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

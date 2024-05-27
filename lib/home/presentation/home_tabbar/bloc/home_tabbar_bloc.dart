import 'dart:async';
import 'package:pwd/common/tools/list_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_tab_model.dart';

import 'home_tabbar_bloc_data.dart';
import 'home_tabbar_bloc_event.dart';
import 'home_tabbar_bloc_state.dart';

final class HomeTabbarBloc
    extends Bloc<HomeTabbarBlocEvent, HomeTabbarBlocState> with ListHelper {
  final RemoteConfigurationProvider remoteConfigurationsProvider;
  late final StreamSubscription configurationSubscription;

  HomeTabbarBlocData get data => state.data;

  HomeTabbarBloc({required this.remoteConfigurationsProvider})
      : super(
          HomeTabbarBlocState.common(
            data: HomeTabbarBlocData.initial(),
          ),
        ) {
    _subscribeToStreams();
    _setupHandlers();
  }

  void _setupHandlers() {
    on<DidChangeEvent>(
      _onDidChangeEvent,
      // transformer: sequential(),
    );
  }

  void _subscribeToStreams() {
    configurationSubscription = remoteConfigurationsProvider.configuration
        .debounceTime(Durations.short1)
        .distinct()
        .listen(
          (e) => add(
            HomeTabbarBlocEvent.didChange(
              configurations: e.configurations,
            ),
          ),
        );
  }

  @override
  Future<void> close() {
    configurationSubscription.cancel();
    return super.close();
  }

  void _onDidChangeEvent(
    DidChangeEvent event,
    Emitter<HomeTabbarBlocState> emit,
  ) async {
    try {
      final tabs = <HomeTabbarTabModel>[
        if (event.configurations.isEmpty)
          const ConfigurationUndefinedTab()
        else
          ...event.configurations.map(
            (e) => NotesTab(configuration: e),
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

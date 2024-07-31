import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/tools/list_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/home/presentation/home_tabbar/folder_model.dart';

import 'home_folders_bloc_data.dart';
import 'home_folders_bloc_event.dart';
import 'home_folders_bloc_state.dart';

final class HomeFoldersBloc
    extends Bloc<HomeFoldersBlocEvent, HomeFoldersBlocState> with ListHelper {
  final RemoteConfigurationProvider remoteConfigurationsProvider;
  final PinUsecase pinUsecase;
  late final StreamSubscription configurationSubscription;

  HomeFoldersBlocData get data => state.data;

  HomeFoldersBloc({
    required this.remoteConfigurationsProvider,
    required this.pinUsecase,
  }) : super(
          HomeFoldersBlocState.loading(
            data: HomeFoldersBlocData.initial(),
          ),
        ) {
    _setupHandlers();
    _subscribeToStreams();
  }

  void _setupHandlers() {
    on<DidChangeEvent>(
      _onDidChangeEvent,
      transformer: restartable(),
    );

    on<ShouldChangeSelectedTabEvent>(
      _onShouldChangeSelectedTabEvent,
    );
    on<ShouldChangeSelectedTabIndexEvent>(
      _onShouldChangeSelectedTabIndexEvent,
    );
    on<LogoutEvent>(_onLogoutEvent);
  }

  void _subscribeToStreams() {
    configurationSubscription = remoteConfigurationsProvider.configuration
        .debounceTime(Durations.short2)
        .distinct()
        .listen(
      (e) {
        add(
          HomeFoldersBlocEvent.didChange(configuration: e),
        );
      },
    );
  }

  @override
  Future<void> close() {
    configurationSubscription.cancel();
    return super.close();
  }

  void _onDidChangeEvent(
    DidChangeEvent event,
    Emitter<HomeFoldersBlocState> emit,
  ) {
    final tabs = event.configuration.toFoldersList();

    emit(
      HomeFoldersBlocState.common(data: data.copyWith(folders: tabs)),
    );
  }

  void _onShouldChangeSelectedTabEvent(
    ShouldChangeSelectedTabEvent event,
    Emitter<HomeFoldersBlocState> emit,
  ) {
    final index = data.folders.indexWhere((tab) {
      return tab == event.tab;
    });

    add(
      HomeFoldersBlocEvent.shouldChangeSelectedTabIndex(index: index),
    );
  }

  void _onShouldChangeSelectedTabIndexEvent(
    ShouldChangeSelectedTabIndexEvent event,
    Emitter<HomeFoldersBlocState> emit,
  ) {
    if (event.index >= 0 &&
        event.index < data.folders.length &&
        event.index != data.index) {
      final targetItem = data.folders[event.index];

      if (targetItem is LogoutItem) {
        add(const HomeFoldersBlocEvent.logout());
      } else {
        emit(
          HomeFoldersBlocState.common(
            data: data.copyWith(index: event.index),
          ),
        );
      }
    }
  }

  void _onLogoutEvent(
    LogoutEvent event,
    Emitter<HomeFoldersBlocState> emit,
  ) async {
    try {
      emit(HomeFoldersBlocState.loading(data: data));

      await pinUsecase.dropPin();

      emit(HomeFoldersBlocState.common(data: data));
    } catch (e) {
      emit(HomeFoldersBlocState.error(data: data, e: e));
    }
  }
}

extension on RemoteConfigurations {
  List<FolderModel> toFoldersList() {
    return [
      if (configurations.isEmpty)
        const ConfigurationUndefinedItem()
      else
        ...configurations.map(
          (e) => NotesItem(configuration: e),
        ),
      const SettingsItem(),
      const LogoutItem(),
    ];
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/model/app_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/support/optional_box.dart';

import 'developer_settings_page_data.dart';

part 'developer_settings_page_state.dart';
part 'developer_settings_page_event.dart';

class DeveloperSettingsPageBloc
    extends Bloc<DeveloperSettingsPageEvent, DeveloperSettingsPageState> {
  final AppConfigurationProvider appConfigurationProvider;
  final PinUsecase pinUsecase;
  DeveloperSettingsPageData get data => state.data;

  DeveloperSettingsPageBloc({
    required this.appConfigurationProvider,
    required this.pinUsecase,
  }) : super(
          DeveloperSettingsPageState.common(
            data: DeveloperSettingsPageData.initial(),
          ),
        ) {
    _setupHandlers();
    add(const DeveloperSettingsPageEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<ShowsRawErrorsFlagChangedEvent>(_onShowsRawErrorsFlagChangedEvent);
    on<SaveEvent>(_onSaveEvent);
    on<FormChangedEvent>(_onFormChangedEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<DeveloperSettingsPageState> emit,
  ) async {
    try {
      emit(DeveloperSettingsPageState.loading(data: data));

      final configuration =
          await appConfigurationProvider.getAppConfiguration();

      emit(
        DeveloperSettingsPageState.common(
          data: DeveloperSettingsPageData.withAppConfiguration(configuration),
        ),
      );
    } catch (e) {
      emit(DeveloperSettingsPageState.error(data: data, error: e));
    }
  }

  void _onShowsRawErrorsFlagChangedEvent(
    ShowsRawErrorsFlagChangedEvent event,
    Emitter<DeveloperSettingsPageState> emit,
  ) =>
      emit(
        DeveloperSettingsPageState.common(
          data: data.copyWith(showRawErrors: event.flag),
        ),
      );

  void _onSaveEvent(
    SaveEvent event,
    Emitter<DeveloperSettingsPageState> emit,
  ) async {
    try {
      emit(DeveloperSettingsPageState.loading(data: data));

      final proxy = event.proxy.isEmpty ? null : event.proxy;

      final newData = data.copyWith(proxy: OptionalBox(proxy));

      await appConfigurationProvider.setEnvironment(newData.appConfiguration);

      await pinUsecase.dropPin();

      emit(DeveloperSettingsPageState.didSave(data: newData));
    } catch (e) {
      emit(DeveloperSettingsPageState.error(data: data, error: e));
    }
  }

  void _onFormChangedEvent(
    FormChangedEvent event,
    Emitter<DeveloperSettingsPageState> emit,
  ) async {
    try {
      emit(DeveloperSettingsPageState.loading(data: data));

      final proxy = event.proxy.isEmpty ? null : event.proxy;

      final newData = data.copyWith(proxy: OptionalBox(proxy));

      emit(DeveloperSettingsPageState.didSave(data: newData));
    } catch (e) {
      emit(DeveloperSettingsPageState.error(data: data, error: e));
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/app_configuration_provider.dart';
import 'package:pwd/common/domain/model/app_configuration.dart';
import 'package:pwd/common/domain/pin_repository.dart';

part 'developer_settings_page_state.dart';
part 'developer_settings_page_event.dart';

class DeveloperSettingsPageBloc
    extends Bloc<DeveloperSettingsPageEvent, DeveloperSettingsPageState> {
  final AppConfigurationProvider appConfigurationProvider;
  final PinRepository pinRepository;
  AppConfiguration get data => state.data;

  DeveloperSettingsPageBloc({
    required this.appConfigurationProvider,
    required this.pinRepository,
  }) : super(
          DeveloperSettingsPageState.common(
            data: AppConfiguration.empty(),
          ),
        ) {
    _setupHandlers();
    add(const DeveloperSettingsPageEvent.initial());
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<SaveEvent>(_onSaveEvent);
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<DeveloperSettingsPageState> emit,
  ) async {
    try {
      emit(DeveloperSettingsPageState.loading(data: data));

      final configuration = await appConfigurationProvider.appConfiguration;

      emit(DeveloperSettingsPageState.common(data: configuration));
    } catch (e) {
      emit(DeveloperSettingsPageState.error(data: data, error: e));
    }
  }

  void _onSaveEvent(
    SaveEvent event,
    Emitter<DeveloperSettingsPageState> emit,
  ) async {
    try {
      emit(DeveloperSettingsPageState.loading(data: data));

      final newData = AppConfiguration(
        proxyIp: event.proxy,
        proxyPort: event.port,
      );

      await appConfigurationProvider.setEnvironment(newData);

      await pinRepository.dropPin();

      emit(DeveloperSettingsPageState.didSave(data: newData));
    } catch (e) {
      emit(DeveloperSettingsPageState.error(data: data, error: e));
    }
  }
}

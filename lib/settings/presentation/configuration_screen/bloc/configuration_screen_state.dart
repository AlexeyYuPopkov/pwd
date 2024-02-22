import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'configuration_screen_data.dart';

sealed class ConfigurationScreenState extends Equatable {
  final ConfigurationScreenData data;

  const ConfigurationScreenState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory ConfigurationScreenState.common({
    required ConfigurationScreenData data,
  }) = CommonState;

  const factory ConfigurationScreenState.loading({
    required ConfigurationScreenData data,
  }) = LoadingState;

  const factory ConfigurationScreenState.error({
    required ConfigurationScreenData data,
    required Object e,
  }) = ErrorState;

  const factory ConfigurationScreenState.shouldSetup({
    required ConfigurationScreenData data,
    required ConfigurationType type,
    required RemoteStorageConfiguration? configuration,
  }) = ShouldSetupState;
}

final class CommonState extends ConfigurationScreenState {
  const CommonState({required super.data});
}

final class LoadingState extends ConfigurationScreenState {
  const LoadingState({required super.data});
}

final class ErrorState extends ConfigurationScreenState {
  final Object e;
  const ErrorState({
    required super.data,
    required this.e,
  });
}

final class ShouldSetupState extends ConfigurationScreenState {
  final ConfigurationType type;
  final RemoteStorageConfiguration? configuration;

  const ShouldSetupState({
    required this.type,
    required super.data,
    required this.configuration,
  });

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => Object.hashAll({super.hashCode, type, data});
}

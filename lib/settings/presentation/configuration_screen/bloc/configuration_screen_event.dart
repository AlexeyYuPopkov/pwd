import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

sealed class ConfigurationScreenEvent extends Equatable {
  const ConfigurationScreenEvent();

  const factory ConfigurationScreenEvent.initial() = InitialEvent;

  const factory ConfigurationScreenEvent.setGitConfiguration({
    required GitConfiguration configuration,
  }) = SetGitConfigurationEvent;

  const factory ConfigurationScreenEvent.setGoogleDriveConfiguration({
    required GoogleDriveConfiguration configuration,
  }) = SetGoogleDriveConfigurationEvent;

  const factory ConfigurationScreenEvent.toggleConfiguration({
    required bool isOn,
    required ConfigurationType type,
  }) = ToggleConfigurationEvent;

  const factory ConfigurationScreenEvent.next() = NextEvent;

  @override
  List<Object?> get props => const [];
}

final class InitialEvent extends ConfigurationScreenEvent {
  const InitialEvent();
}

final class SetGitConfigurationEvent extends ConfigurationScreenEvent {
  final GitConfiguration configuration;

  const SetGitConfigurationEvent({
    required this.configuration,
  });
}

final class SetGoogleDriveConfigurationEvent extends ConfigurationScreenEvent {
  final GoogleDriveConfiguration configuration;

  const SetGoogleDriveConfigurationEvent({
    required this.configuration,
  });
}

final class ToggleConfigurationEvent extends ConfigurationScreenEvent {
  final bool isOn;
  final ConfigurationType type;

  const ToggleConfigurationEvent({
    required this.isOn,
    required this.type,
  });
}

final class NextEvent extends ConfigurationScreenEvent {
  const NextEvent();
}

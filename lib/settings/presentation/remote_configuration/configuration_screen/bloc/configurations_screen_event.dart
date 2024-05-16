import 'package:equatable/equatable.dart';

sealed class ConfigurationsScreenEvent extends Equatable {
  const ConfigurationsScreenEvent();

  const factory ConfigurationsScreenEvent.initial() = InitialEvent;

  @override
  List<Object?> get props => const [];
}

final class InitialEvent extends ConfigurationsScreenEvent {
  const InitialEvent();
}

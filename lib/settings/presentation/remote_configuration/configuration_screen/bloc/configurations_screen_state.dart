import 'package:equatable/equatable.dart';

import 'configurations_screen_data.dart';

sealed class ConfigurationsScreenState extends Equatable {
  final ConfigurationsScreenData data;

  const ConfigurationsScreenState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory ConfigurationsScreenState.common({
    required ConfigurationsScreenData data,
  }) = CommonState;

  const factory ConfigurationsScreenState.loading({
    required ConfigurationsScreenData data,
  }) = LoadingState;

  const factory ConfigurationsScreenState.error({
    required ConfigurationsScreenData data,
    required Object e,
  }) = ErrorState;
}

final class CommonState extends ConfigurationsScreenState {
  const CommonState({required super.data});
}

final class LoadingState extends ConfigurationsScreenState {
  const LoadingState({required super.data});
}

final class ErrorState extends ConfigurationsScreenState {
  final Object e;
  const ErrorState({
    required super.data,
    required this.e,
  });
}

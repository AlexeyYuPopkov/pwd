import 'package:equatable/equatable.dart';

import 'set_configuration_bloc_data.dart';

sealed class SetConfigurationBlocState extends Equatable {
  final SetConfigurationBlocData data;

  const SetConfigurationBlocState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory SetConfigurationBlocState.common({
    required SetConfigurationBlocData data,
  }) = CommonState;

  const factory SetConfigurationBlocState.loading({
    required SetConfigurationBlocData data,
  }) = LoadingState;

  const factory SetConfigurationBlocState.savedState({
    required SetConfigurationBlocData data,
  }) = SavedState;

  const factory SetConfigurationBlocState.error({
    required SetConfigurationBlocData data,
    required Object e,
  }) = ErrorState;
}

final class CommonState extends SetConfigurationBlocState {
  const CommonState({required super.data});
}

final class LoadingState extends SetConfigurationBlocState {
  const LoadingState({required super.data});
}

final class ErrorState extends SetConfigurationBlocState {
  final Object e;
  const ErrorState({
    required super.data,
    required this.e,
  });
}

final class SavedState extends SetConfigurationBlocState {
  const SavedState({required super.data});
}

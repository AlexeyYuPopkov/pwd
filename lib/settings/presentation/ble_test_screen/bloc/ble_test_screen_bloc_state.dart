import 'package:equatable/equatable.dart';

import 'ble_test_screen_bloc_data.dart';

sealed class BleTestScreenBlocState extends Equatable {
  final BleTestScreenBlocData data;

  const BleTestScreenBlocState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory BleTestScreenBlocState.common({
    required BleTestScreenBlocData data,
  }) = CommonState;

  const factory BleTestScreenBlocState.loading({
    required BleTestScreenBlocData data,
  }) = LoadingState;

  const factory BleTestScreenBlocState.error({
    required BleTestScreenBlocData data,
    required Object e,
  }) = ErrorState;
}

final class CommonState extends BleTestScreenBlocState {
  const CommonState({required super.data});
}

final class LoadingState extends BleTestScreenBlocState {
  const LoadingState({required super.data});
}

final class ErrorState extends BleTestScreenBlocState {
  final Object e;
  const ErrorState({
    required super.data,
    required this.e,
  });
}

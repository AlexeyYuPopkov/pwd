part of 'pin_page_bloc.dart';

abstract class PinPageBlocState extends Equatable {
  final PinPageBlocData data;

  const PinPageBlocState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory PinPageBlocState.initializing({required PinPageBlocData data}) =
      InitializingState;

  const factory PinPageBlocState.shouldFillConfiguration(
      {required PinPageBlocData data}) = ShouldFillConfigurationState;

  const factory PinPageBlocState.shouldEnterThePin(
      {required PinPageBlocData data}) = ShouldEnterThePinState;

  const factory PinPageBlocState.loading({required PinPageBlocData data}) =
      LoadingState;

  const factory PinPageBlocState.didLogin({required PinPageBlocData data}) =
      DidLoginState;

  const factory PinPageBlocState.error({
    required PinPageBlocData data,
    required Object error,
  }) = ErrorState;

  int get page => this is ShouldEnterThePinState ? 1 : 0;
}

class InitializingState extends PinPageBlocState {
  const InitializingState({required super.data});
}

class ShouldFillConfigurationState extends PinPageBlocState {
  const ShouldFillConfigurationState({required super.data});
}

class ShouldEnterThePinState extends PinPageBlocState {
  const ShouldEnterThePinState({required super.data});
}

class DidLoginState extends PinPageBlocState {
  const DidLoginState({required super.data});
}

class LoadingState extends PinPageBlocState {
  const LoadingState({required super.data});
}

class ErrorState extends PinPageBlocState {
  final Object error;
  const ErrorState({
    required super.data,
    required this.error,
  });
}

// Data
class PinPageBlocData extends Equatable {
  const PinPageBlocData();

  @override
  List<Object?> get props => const [];
}

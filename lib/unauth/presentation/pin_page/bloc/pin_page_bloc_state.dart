part of 'pin_page_bloc.dart';

sealed class PinPageBlocState extends Equatable {
  final PinPageBlocData data;

  const PinPageBlocState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory PinPageBlocState.initializing({required PinPageBlocData data}) =
      InitializingState;

  const factory PinPageBlocState.loading({required PinPageBlocData data}) =
      LoadingState;

  const factory PinPageBlocState.didLogin({required PinPageBlocData data}) =
      DidLoginState;

  const factory PinPageBlocState.error({
    required PinPageBlocData data,
    required Object error,
  }) = ErrorState;
}

final class InitializingState extends PinPageBlocState {
  const InitializingState({required super.data});
}

final class DidLoginState extends PinPageBlocState {
  const DidLoginState({required super.data});
}

final class LoadingState extends PinPageBlocState {
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
final class PinPageBlocData extends Equatable {
  final EnterPinKeyboardType enterPinKeyboardType;

  const PinPageBlocData._({
    this.enterPinKeyboardType = AppSettings.defaultKeyboardTyupe,
  });

  const factory PinPageBlocData.initial() = PinPageBlocData._;

  @override
  List<Object?> get props => [enterPinKeyboardType];

  PinPageBlocData copyWith({
    EnterPinKeyboardType? enterPinKeyboardType,
  }) =>
      PinPageBlocData._(
        enterPinKeyboardType: enterPinKeyboardType ?? this.enterPinKeyboardType,
      );
}

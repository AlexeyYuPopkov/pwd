part of 'pin_page_bloc.dart';

sealed class PinPageBlocEvent extends Equatable {
  const PinPageBlocEvent();

  const factory PinPageBlocEvent.initial() = InitialEvent;

  const factory PinPageBlocEvent.login({required String pin}) = LoginEvent;

  @override
  List<Object?> get props => const [];
}

final class InitialEvent extends PinPageBlocEvent {
  const InitialEvent();
}

final class LoginEvent extends PinPageBlocEvent {
  final String pin;
  const LoginEvent({required this.pin});
}

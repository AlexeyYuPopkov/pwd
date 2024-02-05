import 'package:equatable/equatable.dart';

sealed class HomeTabbarBlocEvent extends Equatable {
  const HomeTabbarBlocEvent();

  const factory HomeTabbarBlocEvent.initial() = InitialEvent;

  @override
  List<Object?> get props => const [];
}

final class InitialEvent extends HomeTabbarBlocEvent {
  const InitialEvent();
}

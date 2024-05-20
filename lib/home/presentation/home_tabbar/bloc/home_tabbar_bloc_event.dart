import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

sealed class HomeTabbarBlocEvent extends Equatable {
  const HomeTabbarBlocEvent();

  const factory HomeTabbarBlocEvent.didChange(
      {required List<RemoteConfiguration> configurations}) = DidChangeEvent;

  @override
  List<Object?> get props => const [];
}

final class DidChangeEvent extends HomeTabbarBlocEvent {
  final List<RemoteConfiguration> configurations;

  const DidChangeEvent({required this.configurations});

  @override
  List<Object?> get props => [configurations];
}

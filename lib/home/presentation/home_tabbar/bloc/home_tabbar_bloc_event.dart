import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/home/presentation/home_tabbar/home_tabbar_tab_model.dart';

sealed class HomeTabbarBlocEvent extends Equatable {
  const HomeTabbarBlocEvent();

  const factory HomeTabbarBlocEvent.didChange({
    required List<RemoteConfiguration> configurations,
  }) = DidChangeEvent;

  const factory HomeTabbarBlocEvent.shouldChangeSelectedTab({
    required HomeTabbarTabModel tab,
  }) = ShouldChangeSelectedTabEvent;

  const factory HomeTabbarBlocEvent.shouldChangeSelectedTabIndex({
    required int index,
  }) = ShouldChangeSelectedTabIndexEvent;

  @override
  List<Object?> get props => const [];
}

final class DidChangeEvent extends HomeTabbarBlocEvent {
  final List<RemoteConfiguration> configurations;

  const DidChangeEvent({required this.configurations});

  @override
  List<Object?> get props => [configurations];
}

final class ShouldChangeSelectedTabEvent extends HomeTabbarBlocEvent {
  final HomeTabbarTabModel tab;

  const ShouldChangeSelectedTabEvent({required this.tab});

  @override
  List<Object?> get props => [tab.runtimeType];
}

final class ShouldChangeSelectedTabIndexEvent extends HomeTabbarBlocEvent {
  final int index;

  const ShouldChangeSelectedTabIndexEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

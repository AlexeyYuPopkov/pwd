import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

sealed class ConfigurationsScreenEvent extends Equatable {
  const ConfigurationsScreenEvent();

  const factory ConfigurationsScreenEvent.shouldReorder({
    required int oldIndex,
    required int newIndex,
  }) = ShouldReorderEvent;

  const factory ConfigurationsScreenEvent.didChange({
    required List<RemoteConfiguration> configurations,
  }) = DidChangeEvent;

  @override
  List<Object?> get props => const [];
}

final class ShouldReorderEvent extends ConfigurationsScreenEvent {
  final int oldIndex;
  final int newIndex;
  const ShouldReorderEvent({required this.oldIndex, required this.newIndex});

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

final class DidChangeEvent extends ConfigurationsScreenEvent {
  final List<RemoteConfiguration> configurations;

  const DidChangeEvent({required this.configurations});
}

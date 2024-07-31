import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/home/presentation/home_tabbar/folder_model.dart';

sealed class HomeFoldersBlocEvent extends Equatable {
  const HomeFoldersBlocEvent();

  const factory HomeFoldersBlocEvent.didChange({
    required RemoteConfigurations configuration,
  }) = DidChangeEvent;

  const factory HomeFoldersBlocEvent.shouldChangeSelectedTab({
    required FolderModel tab,
  }) = ShouldChangeSelectedTabEvent;

  const factory HomeFoldersBlocEvent.shouldChangeSelectedTabIndex({
    required int index,
  }) = ShouldChangeSelectedTabIndexEvent;

  const factory HomeFoldersBlocEvent.logout() = LogoutEvent;

  @override
  List<Object?> get props => const [];
}

final class DidChangeEvent extends HomeFoldersBlocEvent {
  final RemoteConfigurations configuration;

  const DidChangeEvent({required this.configuration});

  @override
  List<Object?> get props => [configuration];
}

final class ShouldChangeSelectedTabEvent extends HomeFoldersBlocEvent {
  final FolderModel tab;

  const ShouldChangeSelectedTabEvent({required this.tab});

  @override
  List<Object?> get props => [tab.runtimeType];
}

final class ShouldChangeSelectedTabIndexEvent extends HomeFoldersBlocEvent {
  final int index;

  const ShouldChangeSelectedTabIndexEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

final class LogoutEvent extends HomeFoldersBlocEvent {
  const LogoutEvent();
}

part of 'remote_storage_settings_page_bloc.dart';

sealed class RemoteStorageSettingsPageEvent extends Equatable {
  const RemoteStorageSettingsPageEvent();

  const factory RemoteStorageSettingsPageEvent.initial() = InitialEvent;

  const factory RemoteStorageSettingsPageEvent.drop() = DropEvent;

  @override
  List<Object?> get props => const [];
}

final class InitialEvent extends RemoteStorageSettingsPageEvent {
  const InitialEvent();
}

final class DropEvent extends RemoteStorageSettingsPageEvent {
  const DropEvent();
}

part of 'remote_storage_settings_page_bloc.dart';

abstract class RemoteStorageSettingsPageEvent extends Equatable {
  const RemoteStorageSettingsPageEvent();

  const factory RemoteStorageSettingsPageEvent.initial() = InitialEvent;

  const factory RemoteStorageSettingsPageEvent.drop() = DropEvent;

  @override
  List<Object?> get props => const [];
}

class InitialEvent extends RemoteStorageSettingsPageEvent {
  const InitialEvent();
}

class DropEvent extends RemoteStorageSettingsPageEvent {
  const DropEvent();
}

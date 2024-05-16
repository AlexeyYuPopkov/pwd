import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

sealed class SetConfigurationBlocEvent extends Equatable {
  const SetConfigurationBlocEvent();

  // const factory SetConfigurationBlocEvent.initial() = InitialEvent;

  const factory SetConfigurationBlocEvent.newConfiguration({
    required RemoteConfiguration configuration,
  }) = NewConfigurationEvent;

  const factory SetConfigurationBlocEvent.deleteConfiguration() =
      DeleteConfigurationEvent;

  @override
  List<Object?> get props => const [];
}

final class NewConfigurationEvent extends SetConfigurationBlocEvent {
  final RemoteConfiguration configuration;

  const NewConfigurationEvent({required this.configuration});
}

final class DeleteConfigurationEvent extends SetConfigurationBlocEvent {
  const DeleteConfigurationEvent();
}

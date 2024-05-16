import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/support/optional_box.dart';

final class SetConfigurationBlocData extends Equatable {
  final OptionalBox<RemoteConfiguration> initialData;
  const SetConfigurationBlocData._({required this.initialData});

  factory SetConfigurationBlocData.initial({
    required RemoteConfiguration? initialData,
  }) {
    return SetConfigurationBlocData._(
      initialData: OptionalBox(initialData),
    );
  }

  SetConfigurationBlocMode get mode => initialData.isNull
      ? SetConfigurationBlocMode.newConfiguration
      : SetConfigurationBlocMode.editConfiguration;

  @override
  List<Object?> get props => [
        initialData,
      ];
}

enum SetConfigurationBlocMode {
  newConfiguration,
  editConfiguration,
}

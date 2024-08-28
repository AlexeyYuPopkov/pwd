import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/support/optional_box.dart';

final class SetConfigurationBlocData extends Equatable {
  final OptionalBox<String> configId;
  final OptionalBox<RemoteConfiguration> config;
  const SetConfigurationBlocData._({
    required this.configId,
    required this.config,
  });

  factory SetConfigurationBlocData.initial({required String? configId}) =>
      SetConfigurationBlocData._(
        configId: OptionalBox(configId),
        config: OptionalBox.empty(),
      );

  SetConfigurationBlocMode get mode => configId.isNull
      ? SetConfigurationBlocMode.newConfiguration
      : SetConfigurationBlocMode.editConfiguration;

  @override
  List<Object?> get props => [
        config,
      ];

  SetConfigurationBlocData copyWith({
    OptionalBox<RemoteConfiguration>? config,
  }) {
    return SetConfigurationBlocData._(
      configId: configId,
      config: config ?? this.config,
    );
  }
}

enum SetConfigurationBlocMode {
  newConfiguration,
  editConfiguration,
}

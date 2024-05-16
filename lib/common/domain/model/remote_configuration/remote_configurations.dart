import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/errors/app_error.dart';

import 'remote_configuration.dart';

final class RemoteConfigurations extends Equatable {
  static const int maxCount = 4;
  final List<RemoteConfiguration> configurations;

  const RemoteConfigurations._({required this.configurations});

  factory RemoteConfigurations.createOrThrow({
    required List<RemoteConfiguration> configurations,
  }) {
    if (configurations.length > maxCount) {
      throw const RemoteConfigurationsError.maxCount();
    }

    if (Set.from(configurations).length != configurations.length) {
      throw const RemoteConfigurationsError.configurationDublicate();
    }

    final filenamesList = configurations.map((e) => e.fileName).toList();
    final filenamesSet = filenamesList.toSet();

    if (filenamesList.length != filenamesSet.length) {
      throw const RemoteConfigurationsError.filenemeDublicate();
    }

    return RemoteConfigurations._(configurations: configurations);
  }

  factory RemoteConfigurations.empty() =>
      const RemoteConfigurations._(configurations: []);

  bool get isNotEmpty => !isEmpty;
  bool get isEmpty => configurations.isEmpty;

  @override
  List<Object?> get props => [configurations];

  RemoteConfigurations addAndCopy(RemoteConfiguration configuration) =>
      RemoteConfigurations.createOrThrow(
        configurations: [...configurations, configuration],
      );

  RemoteConfigurations removeAndCopy(RemoteConfiguration configuration) =>
      RemoteConfigurations.createOrThrow(
        configurations: configurations
            .where(
              (e) => e != configuration,
            )
            .toList(),
      );
}

sealed class RemoteConfigurationsError extends AppError {
  const RemoteConfigurationsError({
    required super.message,
    super.reason,
  });

  const factory RemoteConfigurationsError.configurationDublicate() =
      DublicateError;

  const factory RemoteConfigurationsError.filenemeDublicate() =
      FilenemeDublicateError;

  const factory RemoteConfigurationsError.maxCount() = MaxCountError;
}

final class DublicateError extends RemoteConfigurationsError {
  const DublicateError()
      : super(
          message: '',
          reason: 'The same configuration already exists',
        );
}

final class FilenemeDublicateError extends RemoteConfigurationsError {
  const FilenemeDublicateError()
      : super(
          message: '',
          reason: 'A configuration with the same name already exists',
        );
}

final class MaxCountError extends RemoteConfigurationsError {
  const MaxCountError()
      : super(
          message: '',
          reason: 'Max count of possible configurations is 4',
        );
}

import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/errors/app_error.dart';

import 'remote_configuration.dart';

final class RemoteConfigurations extends Equatable {
  static const int maxCount = 4;
  final List<RemoteConfiguration> configurations;
  late final Map<String, int> _map = {};

  RemoteConfigurations._({required this.configurations}) {
    for (int i = 0; i < configurations.length; i++) {
      _map[configurations[i].id] = i;
    }
  }

  factory RemoteConfigurations.createOrThrow({
    required List<RemoteConfiguration> configurations,
  }) {
    _checkForMaxCount(configurations);
    _checkForFilenemeDublicates(configurations);

    return RemoteConfigurations._(configurations: configurations);
  }

  static void _checkForMaxCount(
    List<RemoteConfiguration> configurations,
  ) {
    if (configurations.length > maxCount) {
      throw const RemoteConfigurationsError.maxCount();
    }
  }

  static void _checkForFilenemeDublicates(
      List<RemoteConfiguration> configurations) {
    final filenamesList = configurations.map((e) => e.fileName).toList();
    final filenamesSet = filenamesList.toSet();

    if (filenamesList.length != filenamesSet.length) {
      throw const RemoteConfigurationsError.filenemeDublicate();
    }
  }

  factory RemoteConfigurations.empty() =>
      RemoteConfigurations._(configurations: const []);

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

  RemoteConfiguration? withId(String id) {
    final index = _map[id];

    if (index == null || index < 0 || index >= configurations.length) {
      return null;
    } else {
      assert(index >= 0 && index < configurations.length);
      return configurations[index];
    }
  }
}

sealed class RemoteConfigurationsError extends AppError {
  const RemoteConfigurationsError({
    required super.message,
    super.reason,
  });

  const factory RemoteConfigurationsError.filenemeDublicate() =
      FilenemeDublicateError;

  const factory RemoteConfigurationsError.maxCount() = MaxCountError;
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

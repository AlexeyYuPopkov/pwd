import 'package:equatable/equatable.dart';

import 'remote_configuration.dart';

final class RemoteConfigurations extends Equatable {
  final List<RemoteConfiguration> configurations;
  late final Map<ConfigurationType, int> _configurationIndexes;

  RemoteConfigurations({required this.configurations}) {
    var configurationIndexes = <ConfigurationType, int>{};
    for (int i = 0; i < configurations.length; i++) {
      configurationIndexes[configurations[i].type] = i;
    }

    _configurationIndexes = configurationIndexes;

    assert(Set.from(configurations).length == configurations.length);
  }

  factory RemoteConfigurations.empty() =>
      RemoteConfigurations(configurations: const []);

  bool get isNotEmpty => configurations.isNotEmpty;
  bool get isEmpty => configurations.isEmpty;

  bool hasConfiguration(ConfigurationType type) => withType(type) != null;

  @override
  List<Object?> get props => [configurations];

  RemoteConfiguration? withType(ConfigurationType type) {
    final index = _configurationIndexes[type];

    if (index == null) {
      return null;
    }

    final idValidIndex = index >= 0 && index < configurations.length;
    assert(idValidIndex);

    return idValidIndex ? configurations[index] : null;
  }

  RemoteConfigurations copyRemovedType(ConfigurationType type) {
    final index = _configurationIndexes[type];

    if (index is! int) {
      return this;
    }
    assert(index >= 0 && index < configurations.length);
    if (index >= 0 && index < configurations.length) {
      var newConfigurations = configurations;
      newConfigurations.removeAt(index);

      return RemoteConfigurations(
        configurations: newConfigurations,
      );
    } else {
      return this;
    }
  }

  RemoteConfigurations copyAppendedType(
    RemoteConfiguration configuration,
  ) =>
      hasConfiguration(configuration.type)
          ? this
          : RemoteConfigurations(
              configurations: [
                ...configurations,
                configuration,
              ],
            );
}

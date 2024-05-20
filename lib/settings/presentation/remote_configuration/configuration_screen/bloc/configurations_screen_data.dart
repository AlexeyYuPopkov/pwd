import 'package:equatable/equatable.dart';

import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

class ConfigurationsScreenData extends Equatable {
  final List<RemoteConfiguration> items;

  const ConfigurationsScreenData._({
    required this.items,
  });

  factory ConfigurationsScreenData.initial() {
    return const ConfigurationsScreenData._(
      items: [],
    );
  }

  @override
  List<Object?> get props => [items];

  ConfigurationsScreenData copyWith({
    List<RemoteConfiguration>? items,
  }) {
    return ConfigurationsScreenData._(
      items: items ?? this.items,
    );
  }
}

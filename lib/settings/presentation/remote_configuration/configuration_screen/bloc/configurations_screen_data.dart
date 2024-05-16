import 'package:equatable/equatable.dart';

import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

class ConfigurationsScreenData extends Equatable {
  final List<RemoteConfiguration> items;
  final List<RemoteConfiguration> initialItems;

  bool get canContinue => !items.isEqualTo(other: initialItems);

  const ConfigurationsScreenData._({
    required this.initialItems,
    required this.items,
  });

  factory ConfigurationsScreenData.initial() {
    return const ConfigurationsScreenData._(
      initialItems: [],
      items: [],
    );
  }

  @override
  List<Object?> get props => const [];

  ConfigurationsScreenData copyWith({
    List<RemoteConfiguration>? items,
  }) {
    return ConfigurationsScreenData._(
      initialItems: initialItems,
      items: items ?? this.items,
    );
  }

  ConfigurationsScreenData copyInitialItemsWith({
    required List<RemoteConfiguration> items,
  }) =>
      ConfigurationsScreenData._(
        initialItems: items,
        items: items,
      );
}

extension on List<RemoteConfiguration> {
  bool isEqualTo({required List<RemoteConfiguration> other}) {
    if (identical(this, other)) {
      return true;
    }

    final listLength = length;

    if (listLength != other.length) {
      return false;
    }

    for (var index = 0; index < listLength; index++) {
      if (this[index] != other[index]) {
        return false;
      }
    }

    return true;
  }
}

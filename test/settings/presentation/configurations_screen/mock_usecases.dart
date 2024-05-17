import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/settings/domain/add_configurations_usecase.dart';
import 'package:pwd/settings/domain/remove_configurations_usecase.dart';

final class MockAddConfigurationsUsecase implements AddConfigurationsUsecase {
  late List<dynamic> calls = [];

  var initialConfigurations = RemoteConfigurations.empty();

  @override
  Future<void> execute(RemoteConfiguration configuration) {
    calls.add(configuration);
    initialConfigurations = initialConfigurations.addAndCopy(configuration);
    return Future.delayed(Durations.medium1);
  }
}

final class MockRemoveConfigurationsUsecase
    implements RemoveConfigurationsUsecase {
  late List<dynamic> exeptions = [];
  late List<dynamic> calls = [];
  @override
  Future<void> execute(RemoteConfiguration configuration) {
    calls.add(configuration);
    if (exeptions.isNotEmpty) {
      final exeption = exeptions.removeAt(0);
      return Future.delayed(Durations.medium1).then(
        (_) => throw exeption,
      );
    } else {
      return Future.delayed(Durations.medium1);
    }
  }
}

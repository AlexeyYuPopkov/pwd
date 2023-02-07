import 'package:pwd/common/domain/clock_configuration_provider.dart';
import 'package:pwd/common/domain/model/clock_model.dart';

class ClockUsecase {
  final ClockConfigurationProvider clockConfigurationProvider;

  ClockUsecase({
    required this.clockConfigurationProvider,
  });

  Future<List<ClockModel>> getClocks() async {
    final clocks = await clockConfigurationProvider.clocks;
    return clocks.isEmpty ? [DefaultClockModel(label: '')] : clocks;
  }

  Future<List<ClockModel>> byClockDeletion(ClockModel clock) async {
    final clocks = await getClocks();
    await clockConfigurationProvider.setClocks(
      clocks
          .where(
            (e) => e != clock,
          )
          .toList(),
    );
    return getClocks();
  }

  Future<List<ClockModel>> byAdding(ClockModel clock) async {
    var clocks = await getClocks();

    clocks = clocks.where((e) => e != clock).toList();
    clocks.add(clock);
    await clockConfigurationProvider.setClocks(clocks);
    return getClocks();
  }
}

class DefaultClockModel extends ClockModel {
  DefaultClockModel._({required super.label, required super.timezoneOffset});

  factory DefaultClockModel({
    required String label,
  }) =>
      DefaultClockModel._(
        label: label,
        timezoneOffset: DateTime.now().timeZoneOffset,
      );
}

import 'package:pwd/common/domain/clock_configuration_provider.dart';
import 'package:pwd/common/domain/model/clock_model.dart';

class ClockUsecase {
  final ClockConfigurationProvider clockConfigurationProvider;

  ClockUsecase({
    required this.clockConfigurationProvider,
  });

  Future<List<ClockModel>> getClocks() async {
    try {
      final clocks = await clockConfigurationProvider.clocks;
      return clocks.isEmpty
          ? [
              ClockModel(
                label: '',
                timezoneOffset: DateTime.now().timeZoneOffset,
              ),
            ]
          : clocks;
    } catch (e) {
      return [
        ClockModel(
          label: '',
          timezoneOffset: DateTime.now().timeZoneOffset,
        ),
      ];
    }
  }

  Future<List<ClockModel>> byClockDeletion(ClockModel clock) async {
    final clocks = await getClocks();
    await clockConfigurationProvider.setClocks(
      clocks
          .where(
            (e) => e.id != clock.id,
          )
          .toList(),
    );
    return getClocks();
  }

  Future<List<ClockModel>> changedWithClock(ClockModel clock) async {
    var clocks = await getClocks();

    List<ClockModel> newClocks = [];

    var shouldAppend = true;

    for (final item in clocks) {
      if (item.id == clock.id) {
        newClocks.add(clock);
        shouldAppend = false;
      } else {
        newClocks.add(item);
      }
    }

    if (shouldAppend) {
      newClocks.add(clock);
    }

    await clockConfigurationProvider.setClocks(newClocks);
    return getClocks();
  }
}

// class DefaultClockModel extends ClockModel {
//   DefaultClockModel._({required super.label, required super.timezoneOffset});

//   factory DefaultClockModel({
//     required String label,
//   }) =>
//       DefaultClockModel._(
//         label: label,
//         timezoneOffset: DateTime.now().timeZoneOffset,
//       );
// }

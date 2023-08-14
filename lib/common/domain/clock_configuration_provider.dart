import 'model/clock_model.dart';

abstract class ClockConfigurationProvider {
  Future<List<ClockModel>> get clocks;

  Future<void> setClocks(List<ClockModel> clocks);
}

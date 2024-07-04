import 'package:equatable/equatable.dart';

import 'ble_test_screen_bloc_data.dart';

sealed class BleTestScreenBlocEvent extends Equatable {
  const BleTestScreenBlocEvent();

  const factory BleTestScreenBlocEvent.initial() = InitialEvent;

  const factory BleTestScreenBlocEvent.newDevices({
    required List<BleDevice> devices,
  }) = NewDevicesEvent;

  @override
  List<Object?> get props => const [];
}

final class InitialEvent extends BleTestScreenBlocEvent {
  const InitialEvent();
}

final class NewDevicesEvent extends BleTestScreenBlocEvent {
  final List<BleDevice> devices;
  const NewDevicesEvent({required this.devices});
}

import 'package:equatable/equatable.dart';

final class BleTestScreenBlocData extends Equatable {
  final List<BleDevice> devices;

  const BleTestScreenBlocData._({required this.devices});

  factory BleTestScreenBlocData.initial() {
    return const BleTestScreenBlocData._(devices: []);
  }

  @override
  List<Object?> get props => [devices];

  BleTestScreenBlocData copyWith({
    List<BleDevice>? devices,
  }) {
    return BleTestScreenBlocData._(
      devices: devices ?? this.devices,
    );
  }
}

final class BleDevice extends Equatable {
  final String remoteId;
  final String platformName;
  final String advName;

  const BleDevice({
    required this.remoteId,
    required this.platformName,
    required this.advName,
  });

  @override
  List<Object?> get props => [remoteId];
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:pwd/common/domain/errors/app_error.dart';

import 'ble_test_screen_bloc_data.dart';
import 'ble_test_screen_bloc_event.dart';
import 'ble_test_screen_bloc_state.dart';

final class BleTestScreenBloc
    extends Bloc<BleTestScreenBlocEvent, BleTestScreenBlocState> {
  // final flutterBlue = FlutterBluePlus();
  BluetoothDevice? connectedDevice;
  List<BluetoothService> services = [];
  BluetoothCharacteristic? targetCharacteristic;

  // final service = BluetoothService.fromProto(p)

  // (
  //   uuid: Guid("0000180d-0000-1000-8000-00805f9b34fb"),
  //   characteristics: [
  //     BluetoothCharacteristic(
  //       uuid: Guid("00002a37-0000-1000-8000-00805f9b34fb"),
  //       properties: BluetoothCharacteristicProperties(
  //         read: true,
  //         write: true,
  //         notify: true,
  //       ),
  //       value: [0], // initial value
  //     ),
  //   ],
  // );

  BleTestScreenBlocData get data => state.data;

  StreamSubscription? scanDevices;

  BleTestScreenBloc()
      : super(
          BleTestScreenBlocState.common(
            data: BleTestScreenBlocData.initial(),
          ),
        ) {
    _setupSubscriptions();
    _setupHandlers();

    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

    add(const BleTestScreenBlocEvent.initial());
  }

  @override
  Future<void> close() {
    scanDevices?.cancel();
    return super.close();
  }

  void _setupHandlers() {
    on<InitialEvent>(_onInitialEvent);
    on<NewDevicesEvent>(_onNewDevicesEvent);
  }

  void _setupSubscriptions() {
    scanDevices = FlutterBluePlus.scanResults.listen(
      (results) {
        add(
          BleTestScreenBlocEvent.newDevices(
            devices: [
              for (final result in results)
                BleDevice(
                  remoteId: result.device.remoteId.str,
                  platformName: result.device.platformName,
                  advName: result.device.advName,
                )
            ],
          ),
        );
      },
    );
  }

  void _onInitialEvent(
    InitialEvent event,
    Emitter<BleTestScreenBlocState> emit,
  ) async {
    try {
      emit(BleTestScreenBlocState.loading(data: data));

      if (await FlutterBluePlus.isSupported == false) {
        emit(
          BleTestScreenBlocState.error(
            e: const NotSupportedByDevice(),
            data: data,
          ),
        );
      } else {
        FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

        emit(
          BleTestScreenBlocState.common(data: data),
        );
      }
    } catch (e) {
      emit(BleTestScreenBlocState.error(e: e, data: data));
    }
  }

  void _onNewDevicesEvent(
    NewDevicesEvent event,
    Emitter<BleTestScreenBlocState> emit,
  ) {
    emit(
      BleTestScreenBlocState.common(
          data: data.copyWith(devices: event.devices)),
    );
  }

  void startScan() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    // FlutterBluePlus.scanResults.listen((results) {
    //   for (ScanResult result in results) {
    //     print('Found device: ${result.device.name}');
    //     if (result.device.name == "TARGET_DEVICE_NAME") {
    //       FlutterBluePlus.stopScan();
    //       connectToDevice(result.device);
    //       break;
    //     }
    //   }
    // });
  }
}

sealed class BleError extends AppError {
  const BleError({required super.message, super.reason, super.parentError});
}

final class NotSupportedByDevice extends BleError {
  const NotSupportedByDevice({super.reason, super.parentError})
      : super(message: 'Bluetooth not supported by this device');
}

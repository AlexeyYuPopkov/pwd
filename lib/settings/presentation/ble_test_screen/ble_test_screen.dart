import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/ble_test_screen_bloc.dart';
import 'bloc/ble_test_screen_bloc_state.dart';

final class BleTestScreen extends StatelessWidget with ShowErrorDialogMixin {
  const BleTestScreen({super.key});

  void _listener(BuildContext context, BleTestScreenBlocState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    switch (state) {
      case LoadingState():
      case CommonState():
        break;
      case ErrorState(e: final e):
        showError(context, e);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.pageTitle),
      ),
      body: BlocProvider(
        create: (context) => BleTestScreenBloc(),
        child: BlocConsumer<BleTestScreenBloc, BleTestScreenBlocState>(
          listener: _listener,
          builder: (context, state) {
            return ListView.separated(
              itemBuilder: (_, index) {
                final devices = state.data.devices[index];
                return Column(
                  children: [
                    Text(
                      devices.remoteId,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.blueGrey),
                    ),
                    Text(
                      '${devices.platformName}; ${devices.advName}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) => const SizedBox(
                height: CommonSize.indent,
              ),
              itemCount: state.data.devices.length,
            );
          },
        ),
      ),
    );
  }
}

// Localization
extension on BuildContext {
  String get pageTitle => 'Test BLE';
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/unauth/presentation/configuration_screen/enter_configuration_form.dart';

import 'bloc/configuration_screen_bloc.dart';
import 'bloc/configuration_screen_state.dart';

final class OnPinPageRoute {
  const OnPinPageRoute();
}

final class ConfigurationScreen extends StatelessWidget
    with ShowErrorDialogMixin {
  const ConfigurationScreen({super.key});

  void _listener(BuildContext context, ConfigurationScreenState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;
    switch (state) {
      case CommonState():
      case LoadingState():
        break;
      case ErrorState():
        showError(context, state.e);
        break;
      case SavedState():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfigurationScreenBloc(
        remoteStorageConfigurationProvider: DiStorage.shared.resolve(),
        shouldCreateRemoteStorageFileUsecase: DiStorage.shared.resolve(),
      ),
      child: BlocConsumer<ConfigurationScreenBloc, ConfigurationScreenState>(
        listener: _listener,
        builder: (_, __) {
          return const Scaffold(
            body: EnterConfigurationForm(),
          );
        },
      ),
    );
  }
}

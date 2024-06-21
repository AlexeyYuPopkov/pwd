import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:di_storage/di_storage.dart';

import 'bloc/pin_page_bloc.dart';
import 'pin_screen_enter_pin_form.dart';
import 'pin_screen_test_helper.dart';

final class PinScreen extends StatelessWidget with ShowErrorDialogMixin {
  TimeFormatter get timeFormatter => DiStorage.shared.resolve();

  const PinScreen({super.key});

  void _listener(BuildContext context, PinPageBlocState state) async {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    switch (state) {
      case InitializingState():
      case DidLoginState():
      case LoadingState():
        break;
      case ErrorState():
        showError(context, state.error);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocProvider(
          create: (_) => PinPageBloc(
            loginUsecase: DiStorage.shared.resolve(),
            settingsUsecase: DiStorage.shared.resolve(),
          ),
          child: BlocConsumer<PinPageBloc, PinPageBlocState>(
            key: const Key(PinScreenTestHelper.blocConsumer),
            listener: _listener,
            builder: (_, state) {
              return _Content(
                timeFormatter: timeFormatter,
              );
            },
          ),
        ),
      ),
    );
  }
}

final class _Content extends StatelessWidget {
  final TimeFormatter timeFormatter;

  const _Content({required this.timeFormatter});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PinScreenEnterPinForm(timeFormatter: timeFormatter),
    );
  }
}

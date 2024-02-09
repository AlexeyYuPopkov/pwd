import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:di_storage/di_storage.dart';

import 'bloc/pin_page_bloc.dart';
import 'pin_page_enter_pin_form.dart';

final class PinPage extends StatelessWidget with ShowErrorDialogMixin {
  final Future Function(BuildContext, Object) onRoute;

  TimeFormatter get timeFormatter => DiStorage.shared.resolve();

  PinPage({super.key, required this.onRoute});

  void _listener(BuildContext context, PinPageBlocState state) async {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    if (state is ErrorState) {
      showError(context, state.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocProvider(
          create: (context) => PinPageBloc(
            pinUsecase: DiStorage.shared.resolve(),
            hashUsecase: DiStorage.shared.resolve(),
          ),
          child: BlocConsumer<PinPageBloc, PinPageBlocState>(
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
      child: PinPageEnterPinForm(timeFormatter: timeFormatter),
    );
  }
}

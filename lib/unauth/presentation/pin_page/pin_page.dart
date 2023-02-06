import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';

import 'bloc/pin_page_bloc.dart';
import 'pin_page_enter_pin_form.dart';
import 'pin_page_enter_configuration_form.dart';

class PinPage extends StatelessWidget with ShowErrorDialogMixin {
  final Future Function(BuildContext, Object) onRoute;
  final _pageViewKey = GlobalKey<_PageViewState>();
  TimeFormatter get timeFormatter => DiStorage.shared.resolve();

  PinPage({super.key, required this.onRoute});

  void _listener(BuildContext context, PinPageBlocState state) async {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    if (state is ErrorState) {
      showError(context, state.error);
    } else if (state is ShouldEnterThePinState) {
      _pageViewKey.currentState?.toPinPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocProvider(
          create: (context) => PinPageBloc(
            remoteStorageConfigurationProvider: DiStorage.shared.resolve(),
            pinUsecase: DiStorage.shared.resolve(),
            hashUsecase: DiStorage.shared.resolve(),
            shouldCreateRemoteStorageFileUsecase: DiStorage.shared.resolve(),
          ),
          child: BlocConsumer<PinPageBloc, PinPageBlocState>(
            listener: _listener,
            builder: (_, state) {
              return state is InitializingState
                  ? const Center(child: CircularProgressIndicator())
                  : _PageView(
                      key: _pageViewKey,
                      initialPage: state.page,
                      timeFormatter: timeFormatter,
                    );
            },
          ),
        ),
      ),
    );
  }
}

class _PageView extends StatefulWidget {
  final int initialPage;
  final TimeFormatter timeFormatter;
  const _PageView({
    super.key,
    required this.initialPage,
    required this.timeFormatter,
  });

  @override
  State<_PageView> createState() => _PageViewState();
}

class _PageViewState extends State<_PageView> {
  late final controller = PageController(initialPage: widget.initialPage);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toPinPage() {
    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const PinPageEnterConfigurationForm(),
          PinPageEnterPinForm(timeFormatter: widget.timeFormatter),
        ],
      ),
    );
  }
}

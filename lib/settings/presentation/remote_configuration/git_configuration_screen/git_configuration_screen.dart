import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/presentation/validators/noEmpty/no_empty_validator.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/file_name_validator.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/remote_settings_field_validator.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/remote_settings_field_validator_not_required.dart';
import 'package:pwd/common/presentation/validators/remote_settings_field_validator/remote_settings_file_name_validator.dart';
import 'package:pwd/common/presentation/widgets/common_text_field_row.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc_data.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc_state.dart';
import 'package:pwd/settings/presentation/remote_configuration/widgets/configuration_form_next_buttom_widget.dart';
import 'package:pwd/theme/common_size.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc_event.dart';
import 'git_configuration_screen_test_helper.dart';

part 'git_configuration_form.dart';

final class GitConfigurationScreen extends StatelessWidget
    with ShowErrorDialogMixin {
  final GitConfiguration? initial;
  const GitConfigurationScreen({super.key, required this.initial});

  void _listener(BuildContext context, SetConfigurationBlocState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    switch (state) {
      case LoadingState():
      case CommonState():
        break;
      case SavedState():
        Navigator.of(context).maybePop();
        break;
      case ErrorState(e: final e):
        showError(context, e);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.screenTitle),
        ),
        body: SafeArea(
          child: BlocProvider(
            create: (_) => SetConfigurationBloc(
              initialData: initial,
              addConfigurationsUsecase: DiStorage.shared.resolve(),
              removeConfigurationsUsecase: DiStorage.shared.resolve(),
            ),
            child:
                BlocConsumer<SetConfigurationBloc, SetConfigurationBlocState>(
              listener: _listener,
              builder: (_, state) => GitConfigurationForm(
                initial: initial,
                mode: state.data.mode,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Localization
extension on BuildContext {
  String get screenTitle => 'Setup synchronization';
}

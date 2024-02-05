import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/theme/common_size.dart';
import 'package:pwd/unauth/presentation/configuration_screen/git_configuration_form.dart';

import 'bloc/configuration_screen_bloc.dart';
import 'bloc/configuration_screen_event.dart';
import 'bloc/configuration_screen_state.dart';
import 'google_drive_configuration_screen.dart';

final class ConfigurationsScreen extends StatelessWidget
    with ShowErrorDialogMixin {
  final Future Function(BuildContext context, Object action) onRoute;

  const ConfigurationsScreen({super.key, required this.onRoute});

  void _listener(BuildContext context, ConfigurationScreenState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;
    switch (state) {
      case CommonState():
      case LoadingState():
        break;
      case ErrorState():
        showError(context, state.e);
        break;
      case ShouldSetupState():
        onRoute(
          context,
          OnSetupConfigurationRoute(state.type),
        ).then(
          (e) {
            // _updateState(context);
            if (e == null) {
              return;
            } else if (e is GitConfigurationFormResult) {
              _onGitConfiguration(context, e);
            } else if (e is GoogleDriveConfigurationFormResult) {
              _onGoogleDriveConfiguration(context, e);
            } else {
              assert(false);
            }
          },
        );
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
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(CommonSize.indent4x),
                      child: Text(
                        context.headerText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  for (final item in state.data.configurationTypes)
                    SliverToBoxAdapter(
                      child: _ConfigurationItem(
                        type: item,
                        isOn: state.data.hasConfiguration(item),
                        onChange: (e) => _onConfigurationAction(
                          context,
                          isOn: e,
                          type: item,
                        ),
                      ),
                    ),
                  SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          key: const Key(
                            'configurations_screen_next_button',
                          ),
                          onPressed: state.data.canContinue
                              ? () => _onNext(context)
                              : null,
                          child: Text(context.nextButtonTitle),
                        ),
                        const SizedBox(height: CommonSize.indent2x),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onConfigurationAction(
    BuildContext context, {
    required bool isOn,
    required ConfigurationType type,
  }) =>
      context.read<ConfigurationScreenBloc>().add(
            ConfigurationScreenEvent.toggleConfiguration(
              isOn: isOn,
              type: type,
            ),
          );

  void _onGitConfiguration(
    BuildContext context,
    GitConfigurationFormResult result,
  ) =>
      context.read<ConfigurationScreenBloc>().add(
            ConfigurationScreenEvent.setGitConfiguration(
              configuration: result.configuration,
              needsCreateNewFile: result.needsCreateNewFile,
            ),
          );

  void _onGoogleDriveConfiguration(
    BuildContext context,
    GoogleDriveConfigurationFormResult result,
  ) =>
      context.read<ConfigurationScreenBloc>().add(
            ConfigurationScreenEvent.setGoogleDriveConfiguration(
              configuration: result.configuration,
            ),
          );

  void _onNext(BuildContext context) =>
      context.read<ConfigurationScreenBloc>().add(
            const ConfigurationScreenEvent.next(),
          );
}

final class _ConfigurationItem extends StatelessWidget {
  final ConfigurationType type;

  final bool isOn;
  final Function(bool) onChange;

  const _ConfigurationItem({
    required this.type,
    required this.isOn,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      key: Key('configurations_screen_switch_key_${type.toString()}'),
      title: Text(type.itemTitle(context)),
      subtitle: Text(type.itemDescription(context)),
      value: isOn,
      onChanged: onChange,
    );
  }
}

// Localization
extension on BuildContext {
  String get headerText => 'Setup synchronisation method';
  String get nextButtonTitle => 'Next';
}

// Tools
extension on ConfigurationType {
  String itemTitle(BuildContext context) {
    switch (this) {
      case ConfigurationType.git:
        return 'Git';
      case ConfigurationType.googleDrive:
        return 'Google Drive';
    }
  }

  String itemDescription(BuildContext context) {
    switch (this) {
      case ConfigurationType.git:
        return 'Setup configuration for synchronization with Git API';
      case ConfigurationType.googleDrive:
        return 'Setup configuration for synchronization Google Drive API';
    }
  }
}

// Routing

sealed class ConfigurationScreenRoute {
  const ConfigurationScreenRoute();
}

final class OnPinPageRoute extends ConfigurationScreenRoute {
  const OnPinPageRoute();
}

final class OnSetupConfigurationRoute extends ConfigurationScreenRoute {
  final ConfigurationType type;
  const OnSetupConfigurationRoute(this.type);
}

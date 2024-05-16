import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/presentation/app_bar_button.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/action_sheet.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:di_storage/di_storage.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/configurations_screen_bloc.dart';
import 'bloc/configurations_screen_state.dart';
import 'configurations_screen_test_helper.dart';

part 'configurations_screen_routing.dart';

typedef _TestHelper = ConfigurationsScreenTestHelper;

final class ConfigurationsScreen extends StatelessWidget
    with ShowErrorDialogMixin, ActionSheetHelper {
  final Future Function(BuildContext context, Object action) onRoute;

  const ConfigurationsScreen({super.key, required this.onRoute});

  void _listener(BuildContext context, ConfigurationsScreenState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;
    switch (state) {
      case CommonState():
      case LoadingState():
        break;
      case ErrorState():
        showError(context, state.e);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfigurationsScreenBloc(
        remoteStorageConfigurationProvider: DiStorage.shared.resolve(),
      ),
      child: BlocConsumer<ConfigurationsScreenBloc, ConfigurationsScreenState>(
        listener: _listener,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.headerText),
              leading: BackButton(
                onPressed: () => onRoute(
                  context,
                  const MaybePopRoute(),
                ),
              ),
              actions: [
                AppBarButton(
                  key: const Key(_TestHelper.addNoteConfigurationButton),
                  iconData: Icons.add,
                  onPressed: () => _onNew(context),
                ),
              ],
            ),
            body: SafeArea(
              child: state.data.items.isEmpty
                  ? _NoDataPlaceholder(
                      key: const Key(
                        _TestHelper.noDataPlaceholder,
                      ),
                      onAdd: () => _onNew(context),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final item in state.data.items)
                            _ConfigurationItem(
                              item: item,
                              onTap: () => _onOnSetupConfiguration(
                                context,
                                type: item.type,
                                configuration: item,
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  void _onNew(BuildContext context) {
    showActionSheet(
      context,
      title: context.actionSheetHeaderTitle,
      items: [
        ActionSheetItemBuilder(
          title: ConfigurationType.googleDrive.itemTitle(context),
          keyString: _TestHelper.addActionSheetGoogleDrive,
          onTap: (dialogContext) {
            Navigator.of(dialogContext).maybePop();
            _onOnSetupConfiguration(
              context,
              type: ConfigurationType.googleDrive,
            );
          },
        ),
        ActionSheetItemBuilder(
          title: ConfigurationType.git.itemTitle(context),
          keyString: _TestHelper.addActionSheetGit,
          onTap: (dialogContext) {
            Navigator.of(dialogContext).maybePop();
            _onOnSetupConfiguration(
              context,
              type: ConfigurationType.git,
            );
          },
        ),
      ],
      bottomItem: ActionSheetItemBuilder(
        title: context.actionSheetCancelButtonTitle,
        keyString: _TestHelper.addActionSheetCancel,
        type: ActionSheetItemType.isDestructive,
        onTap: (context) => Navigator.of(context).maybePop(),
      ),
    );
  }

  void _onOnSetupConfiguration(
    BuildContext context, {
    required ConfigurationType type,
    RemoteConfiguration? configuration,
  }) =>
      onRoute(
        context,
        OnSetupConfigurationRoute(type: type, configuration: configuration),
      );
}

// _ConfigurationItem
final class _ConfigurationItem extends StatelessWidget {
  final RemoteConfiguration item;

  final Function() onTap;

  const _ConfigurationItem({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(_TestHelper.getItemKeyFor(item.type)),
      title: Text(item.itemTitle(context)),
      subtitle: Text(item.itemDescription(context)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// _NoDataPlaceholder
class _NoDataPlaceholder extends StatelessWidget {
  final VoidCallback onAdd;
  const _NoDataPlaceholder({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(CommonSize.indent2x),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.noDataPlaceholder,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CommonSize.indent2x),
              OutlinedButton(
                key: const Key(_TestHelper.noDataPlaceholderButton),
                onPressed: onAdd,
                child: Text(context.noDataButtonTitle),
              )
            ],
          ),
        ),
      );
}

// Localization
extension on BuildContext {
  String get headerText => 'Sync. method';
  String get actionSheetHeaderTitle => 'Synchronisation methods';
  String get actionSheetCancelButtonTitle => 'Cancel';

// TODO:
  String get noDataPlaceholder => 'Setup synchronization method';
  String get noDataButtonTitle => 'Continue';
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
}

extension on RemoteConfiguration {
  String itemTitle(BuildContext context) => fileName;

  String itemDescription(BuildContext context) {
    switch (type) {
      case ConfigurationType.git:
        return 'Synchronization with Git API';
      case ConfigurationType.googleDrive:
        return 'Synchronization with Google Drive API';
    }
  }
}

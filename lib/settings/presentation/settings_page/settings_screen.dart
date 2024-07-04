import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/common_highlighted_row.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/l10n/localization_helper.dart';
import 'package:pwd/theme/common_size.dart';
import 'package:pwd/theme/common_theme.dart';

import 'bloc/settings_page_bloc.dart';
import 'settings_screen_routes.dart';
import 'settings_screen_test_helper.dart';

final class SettingsScreen extends StatelessWidget with ShowErrorDialogMixin {
  final Future Function(BuildContext, SettingsRouteData) onRoute;

  const SettingsScreen({super.key, required this.onRoute});

  void _listener(BuildContext context, SettingsPageState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    if (state is ErrorState) {
      showError(context, state.error);
    }

    switch (state) {
      case CommonState():
      case DidLogoutState():
      case LoadingState():
        break;
      case ErrorState():
        showError(context, state.error);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsPageBloc(
        pinUsecase: DiStorage.shared.resolve(),
      ),
      child: BlocListener<SettingsPageBloc, SettingsPageState>(
        listener: _listener,
        child: Scaffold(
          appBar: AppBar(title: Text(context.pageTitle)),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Item(
                key: const Key(
                  SettingsScreenTestHelper.remoteConfigurationItem,
                ),
                title: context.remoteConfigurationPageButtonTitle,
                onTap: () => _onRemoteConfiguration(context),
              ),
              const Divider(height: CommonSize.zero),
              _Item(
                key: const Key(SettingsScreenTestHelper.developerSettingsItem),
                title: context.developerSettingsPageButtonTitle,
                onTap: () => _onDeveloperSettingsPage(context),
              ),
              const Divider(height: CommonSize.zero),
              _Item(
                key: const Key('BleTestScreen.Key'),
                title: 'Test BLE',
                onTap: () => _onBleTestScreen(context),
              ),
              const Divider(height: CommonSize.zero),
              BlocBuilder<SettingsPageBloc, SettingsPageState>(
                builder: (context, state) => _Item(
                  key: const Key(SettingsScreenTestHelper.logoutItem),
                  title: context.logoutButtonTitle,
                  onTap: () => _onLogout(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRemoteConfiguration(BuildContext context) {
    onRoute(context, SettingsRouteData.onRemoteConfiguration());
  }

  void _onDeveloperSettingsPage(BuildContext context) {
    onRoute(context, SettingsRouteData.onDeveloperSettingsScreen());
  }

  void _onBleTestScreen(BuildContext context) {
    onRoute(context, SettingsRouteData.onBleTestScreen());
  }

  void _onLogout(BuildContext context) => context.read<SettingsPageBloc>().add(
        const SettingsPageEvent.logout(),
      );
}

class _Item extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _Item({
    required super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);
    return CommonHighlightedRow(
      highlightedColor: commonTheme.highlightColor,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: CommonSize.indentVariant2x,
          horizontal: CommonSize.indent2x,
        ),
        child: Row(
          children: [
            Expanded(child: Text(title)),
            const Padding(
              padding: EdgeInsets.only(left: CommonSize.indent),
              child: Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
    );
  }
}

// Localization
extension on BuildContext {
  String get pageTitle => localization.settingsScreenTitle;
  String get remoteConfigurationPageButtonTitle =>
      localization.settingsScreenRemoteConfigurationItem;
  String get developerSettingsPageButtonTitle =>
      localization.settingsScreenDeveloperSettingsItem;
  String get logoutButtonTitle => localization.settingsScreenLogoutItem;
}

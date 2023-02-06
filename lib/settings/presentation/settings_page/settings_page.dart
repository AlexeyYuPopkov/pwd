import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/settings_page_bloc.dart';

abstract class SettingsRouteData {
  const SettingsRouteData();

  factory SettingsRouteData.onRemoteStorageSettings() =
      OnRemoteStorageSettingsPage;

  factory SettingsRouteData.onDeveloperSettingsPage() = OnDeveloperSettingsPage;

  factory SettingsRouteData.onClockSettingsPage() = OnClockSettingsPage;
}

class OnRemoteStorageSettingsPage extends SettingsRouteData {
  const OnRemoteStorageSettingsPage();
}

class OnDeveloperSettingsPage extends SettingsRouteData {
  const OnDeveloperSettingsPage();
}

class OnClockSettingsPage extends SettingsRouteData {
  const OnClockSettingsPage();
}

class SettingsPage extends StatelessWidget with ShowErrorDialogMixin {
  final Future Function(BuildContext, SettingsRouteData) onRoute;

  const SettingsPage({super.key, required this.onRoute});

  void _listener(BuildContext context, SettingsPageState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    if (state is ErrorState) {
      showError(context, state.error);
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
              const SizedBox(height: CommonSize.indent2x),
              CupertinoButton(
                key: const Key('test_remote_storage_settings_menu_item'),
                child: Text(context.remoteStorageSettingsPageButtonTitle),
                onPressed: () => _onRemoteStorageSettingsPage(context),
              ),
              const Divider(height: CommonSize.indent2x),
              CupertinoButton(
                child: Text(context.developerSettingsPageButtonTitle),
                onPressed: () => _onDeveloperSettingsPage(context),
              ),
              const Divider(height: CommonSize.indent2x),
              CupertinoButton(
                child: Text(context.clockSettingsPageButtonTitle),
                onPressed: () => _onClockSettingsPage(context),
              ),
              const Divider(height: CommonSize.indent2x),
              BlocBuilder<SettingsPageBloc, SettingsPageState>(
                builder: (context, state) => CupertinoButton(
                  child: Text(context.logoutButtonTitle),
                  onPressed: () => _onLogout(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRemoteStorageSettingsPage(BuildContext context) {
    onRoute(context, SettingsRouteData.onRemoteStorageSettings());
  }

  void _onDeveloperSettingsPage(BuildContext context) {
    onRoute(context, SettingsRouteData.onDeveloperSettingsPage());
  }

  void _onClockSettingsPage(BuildContext context) {
    onRoute(context, SettingsRouteData.onClockSettingsPage());
  }

  void _onLogout(BuildContext context) => context.read<SettingsPageBloc>().add(
        const SettingsPageEvent.logout(),
      );
}

// Localization
extension on BuildContext {
  String get pageTitle => 'Settings';
  String get remoteStorageSettingsPageButtonTitle => 'Remote storage settings';

  String get developerSettingsPageButtonTitle => 'Developer settings';

  String get clockSettingsPageButtonTitle => 'Clock widget settings';
  String get logoutButtonTitle => 'Logout';
}

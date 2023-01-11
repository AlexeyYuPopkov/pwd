import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';

import 'bloc/settings_page_bloc.dart';

abstract class SettingsRouteData {
  const SettingsRouteData();

  factory SettingsRouteData.onTest() = OnTestPage;
}

class OnTestPage extends SettingsRouteData {
  const OnTestPage();
}

class SettingsPage extends StatelessWidget {
  final Future Function(BuildContext, SettingsRouteData) onRoute;

  const SettingsPage({super.key, required this.onRoute});

  void _listener(BuildContext context, SettingsPageState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocProvider(
        create: (context) => SettingsPageBloc(
          syncDataUsecases: DiStorage.shared.resolve(),
        ),
        child: BlocConsumer<SettingsPageBloc, SettingsPageState>(
          listener: _listener,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                CupertinoButton(
                  child: const Text('Push'),
                  onPressed: () => _onPush(context),
                ),
                const SizedBox(height: 32),
                CupertinoButton(
                  child: const Text('Pull'),
                  onPressed: () => _onPull(context),
                ),
                const SizedBox(height: 32),
                CupertinoButton(
                  child: const Text('On test page'),
                  onPressed: () => _onTest(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onPush(BuildContext context) {
    context.read<SettingsPageBloc>().add(const SettingsPageEvent.push());
  }

  void _onPull(BuildContext context) {
    context.read<SettingsPageBloc>().add(const SettingsPageEvent.pull());
  }

  void _onTest(BuildContext context) {
    onRoute(context, SettingsRouteData.onTest());
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';

import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/remote_storage_settings_page_bloc.dart';

class RemoteStorageSettingsPage extends StatelessWidget
    with ShowErrorDialogMixin, DialogHelper {
  const RemoteStorageSettingsPage({super.key});

  void _listener(BuildContext context, RemoteStorageSettingsPageState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    if (state is ErrorState) {
      showError(context, state.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final di = DiStorage.shared;
    return Scaffold(
      appBar: AppBar(title: Text(context.pageTitle)),
      body: BlocProvider(
        create: (_) => RemoteStorageSettingsPageBloc(
          pinUsecase: di.resolve(),
          remoteStorageConfigurationProvider: di.resolve(),
          notesRepository: di.resolve(),
        ),
        child: BlocConsumer<RemoteStorageSettingsPageBloc,
            RemoteStorageSettingsPageState>(
          listener: _listener,
          builder: (context, state) {
            if (state.data is! ValidConfiguration) {
              return Center(
                child: CupertinoButton(
                  key: const Key(
                    'test_drop_remote_storage_settings_button',
                  ),
                  child: Text(context.dropButtonTitle),
                  onPressed: () => _onDrop(context),
                ),
              );
            }
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ListItemWidget(
                        title: context.tokenLabelTitle,
                        subtitle: state.data.token,
                      ),
                      _ListItemWidget(
                        title: context.repoLabelTitle,
                        subtitle: state.data.repo,
                      ),
                      _ListItemWidget(
                        title: context.ownerLabelTitle,
                        subtitle: state.data.owner,
                      ),
                      _ListItemWidget(
                        title: context.branchLabelTitle,
                        subtitle: state.data.branch ?? '',
                      ),
                      _ListItemWidget(
                        title: context.fileLabelTitle,
                        subtitle: state.data.fileName,
                      ),
                      const SizedBox(height: CommonSize.indent2x),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        key: const Key(
                          'test_drop_remote_storage_settings_button',
                        ),
                        child: Text(context.dropButtonTitle),
                        onPressed: () => _onDrop(context),
                      ),
                      const SizedBox(height: CommonSize.indent2x),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onDrop(BuildContext context) {
    showOkCancelDialog(
      context,
      title: context.dropConfirmationMessage,
      onOk: (dialogContext) {
        Navigator.of(dialogContext).pop();
        context.read<RemoteStorageSettingsPageBloc>().add(
              const RemoteStorageSettingsPageEvent.drop(),
            );
      },
    );
  }
}

class _ListItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ListItemWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CommonSize.indent2x,
        vertical: CommonSize.indent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Localization
extension on BuildContext {
  String get pageTitle => 'Remote storage settings';

  String get tokenLabelTitle => 'Token:';
  String get repoLabelTitle => 'Repo:';
  String get ownerLabelTitle => 'Owner:';
  String get branchLabelTitle => 'Branch:';
  String get fileLabelTitle => 'File name:';

  String get dropButtonTitle => 'Drop';
  String get dropConfirmationMessage =>
      'Do you realy whant to drop remote storage settings?';
}

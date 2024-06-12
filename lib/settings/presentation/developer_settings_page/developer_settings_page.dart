import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/app_configuration.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/l10n/gen_l10n/localization.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/developer_settings_page_bloc.dart';
import 'developer_settings_proxy_form.dart';

final class DeveloperSettingsPage extends StatelessWidget
    with ShowErrorDialogMixin {
  static final formKey = GlobalKey<DeveloperSettingsProxyFormState>();

  const DeveloperSettingsPage({super.key});

  void _listener(BuildContext context, DeveloperSettingsPageState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    switch (state) {
      case DidSaveState():
      case LoadingState():
        break;
      case CommonState():
        formKey.currentState?.setDeveloperSettingsProxyFormData(
          DeveloperSettingsProxyFormData(
            ip: state.data.proxy.data?.ip ?? '',
            port: state.data.proxy.data?.port ?? '',
          ),
        );
        break;
      case ErrorState():
        showError(context, state.error);
        break;
    }

    // setDeveloperSettingsProxyFormData
  }

  @override
  Widget build(BuildContext context) {
    final di = DiStorage.shared;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(context.screenTitle)),
        body: BlocProvider(
          create: (_) => DeveloperSettingsPageBloc(
            appConfigurationProvider: di.resolve(),
            pinUsecase: di.resolve(),
          ),
          child: BlocConsumer<DeveloperSettingsPageBloc,
              DeveloperSettingsPageState>(
            listener: _listener,
            builder: (context, state) => CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Container(
                    title: context.proxySectionLabelTitle,
                    padding: const EdgeInsets.only(
                      left: CommonSize.indent2x,
                      right: CommonSize.indent2x,
                      bottom: CommonSize.indent2x,
                    ),
                    child: DeveloperSettingsProxyForm(
                      key: formKey,
                      onSave: (formData) =>
                          onFormChanged(context, formData: formData),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _Container(
                    title: context.otherLabelTitle,
                    padding: EdgeInsets.zero,
                    child: BlocBuilder<DeveloperSettingsPageBloc,
                        DeveloperSettingsPageState>(
                      buildWhen: (a, b) =>
                          a.data.showRawErrors != b.data.showRawErrors,
                      builder: (context, state) {
                        return _ShowsRawErrors(
                          value: state.data.showRawErrors,
                          onChange: (e) => onShowsRawErrorsFlagChanged(
                            context,
                            value: e,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: state.isSubmitEnabled
                            ? () {
                                final formData = formKey.currentState?.data;

                                assert(formData != null);

                                if (formData != null) {
                                  onSave(context, formData: formData);
                                }
                              }
                            : null,
                        child: Text(context.saveButtonTitle),
                      ),
                      const SizedBox(height: CommonSize.indent2x),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onShowsRawErrorsFlagChanged(
    BuildContext context, {
    required bool value,
  }) =>
      context.read<DeveloperSettingsPageBloc>().add(
            DeveloperSettingsPageEvent.showsRawErrorsFlagChanged(flag: value),
          );

  void onFormChanged(
    BuildContext context, {
    required DeveloperSettingsProxyFormData formData,
  }) {
    if (formKey.currentState?.validate() == true) {
      context.read<DeveloperSettingsPageBloc>().add(
            DeveloperSettingsPageEvent.formChanged(
              proxy: ProxyAppConfiguration(
                ip: formData.ip,
                port: formData.port,
              ),
            ),
          );
    }
  }

  void onSave(
    BuildContext context, {
    required DeveloperSettingsProxyFormData formData,
  }) {
    if (formKey.currentState?.validate() == true) {
      context.read<DeveloperSettingsPageBloc>().add(
            DeveloperSettingsPageEvent.save(
              proxy: ProxyAppConfiguration(
                ip: formData.ip,
                port: formData.port,
              ),
            ),
          );
    }
  }
}

final class _ShowsRawErrors extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChange;
  const _ShowsRawErrors({required this.onChange, required this.value});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(context.showRawErrorsSectionLabelTitle),
      subtitle: Text(context.showRawErrorsSectionLabelDescription),
      value: value,
      onChanged: onChange,
    );
  }
}

final class _Container extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets padding;

  const _Container({
    required this.title,
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CommonSize.indent,
            vertical: CommonSize.indent,
          ),
          child: Text(
            title,
            style: theme.textTheme.titleMedium,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(
              CommonSize.borderRadius,
            ),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: CommonSize.indent2x,
            vertical: CommonSize.indent,
          ),
          padding: padding,
          child: child,
        ),
      ],
    );
  }
}

// Localization
extension on BuildContext {
  Localization get localization => Localization.of(this)!;
  String get screenTitle => localization.developerSettingsScreenTitle;
  String get proxySectionLabelTitle =>
      localization.developerSettingsScreenProxyLabel;
  String get otherLabelTitle => localization.developerSettingsScreenOtherLabel;
  String get showRawErrorsSectionLabelTitle =>
      localization.developerSettingsScreenOshowRawErrorsLabel;
  String get showRawErrorsSectionLabelDescription =>
      localization.developerSettingsScreenOshowRawErrorsDescription;
  String get saveButtonTitle => localization.commonSave;
}

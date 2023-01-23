import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/developer_settings_page_bloc.dart';

class DeveloperSettingsPage extends StatelessWidget with ShowErrorDialogMixin {
  const DeveloperSettingsPage({super.key});

  void _listener(BuildContext context, DeveloperSettingsPageState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    if (state is ErrorState) {
      showError(context, state.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final di = DiStorage.shared;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(context.pageTitle)),
        body: BlocProvider(
          create: (_) => DeveloperSettingsPageBloc(
            appConfigurationProvider: di.resolve(),
            pinUsecase: di.resolve(),
          ),
          child: BlocConsumer<DeveloperSettingsPageBloc,
              DeveloperSettingsPageState>(
            listener: _listener,
            builder: (_, state) => SingleChildScrollView(
              child: _Form(
                proxy: state.data.proxyIp ?? '',
                port: state.data.proxyPort ?? '',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  final String proxy;
  final String port;

  const _Form({
    Key? key,
    required this.proxy,
    required this.port,
  }) : super(key: key);

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  late final formKey = GlobalKey<FormState>();
  late final proxyController = TextEditingController();
  late final portController = TextEditingController();

  @override
  void dispose() {
    proxyController.dispose();
    portController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _Form oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.proxy != proxyController.text ||
        widget.port != portController.text) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        proxyController.value = TextEditingValue(text: widget.proxy);
        portController.value = TextEditingValue(text: widget.port);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CommonSize.indent2x),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: CommonSize.indent2x),
            TextFormField(
              controller: proxyController,
              decoration: InputDecoration(
                labelText: context.proxyLabelTitle,
              ),
            ),
            const SizedBox(height: CommonSize.indent2x),
            TextFormField(
              controller: portController,
              decoration: InputDecoration(
                labelText: context.portLabelTitle,
              ),
            ),
            const SizedBox(height: CommonSize.indent2x),
            CupertinoButton(
              onPressed: () => _onSave(context),
              child: Text(context.saveButtonTitle),
            ),
            const SizedBox(height: CommonSize.indent2x),
          ],
        ),
      ),
    );
  }

  void _onSave(BuildContext context) {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();
      final String proxy = proxyController.text;
      final String port = portController.text;

      context.read<DeveloperSettingsPageBloc>().add(
            DeveloperSettingsPageEvent.save(proxy: proxy, port: port),
          );
    }
  }
}

// Localization
extension on BuildContext {
  String get pageTitle => 'Developer settings';

  String get proxyLabelTitle => 'Proxy:';
  String get portLabelTitle => 'Proxy port:';

  String get saveButtonTitle => 'Save';
}

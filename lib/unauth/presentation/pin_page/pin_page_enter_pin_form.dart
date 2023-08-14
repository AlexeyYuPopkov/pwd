import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/clocks_widget.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/pin_page_bloc.dart';

class PinPageEnterPinForm extends StatefulWidget {
  final TimeFormatter timeFormatter;
  const PinPageEnterPinForm({
    Key? key,
    required this.timeFormatter,
  }) : super(key: key);

  @override
  State<PinPageEnterPinForm> createState() => _PinPageEnterPinFormState();
}

class _PinPageEnterPinFormState extends State<PinPageEnterPinForm> {
  late final formKey = GlobalKey<FormState>();
  late final pinController = TextEditingController();

  @override
  void dispose() {
    pinController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const maxWidth = 400.0;
    return Padding(
      padding: const EdgeInsets.all(CommonSize.indent2x),
      child: Form(
        key: formKey,
        child: LayoutBuilder(builder: (context, constraints) {
          final topSpace = (constraints.maxHeight ~/ 3).toDouble();
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: topSpace,
                      child: Center(
                        child: RepaintBoundary(
                          child: ClocksWidget(formatter: widget.timeFormatter),
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: maxWidth),
                      child: TextFormField(
                        key: const Key('test_pin_text_field_key'),
                        controller: pinController,
                        decoration: InputDecoration(
                          labelText: context.pinTextFieldTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: CommonSize.indent2x),
                  ],
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: CommonSize.indent2x,
                      right: CommonSize.indent2x,
                      bottom: CommonSize.indent4x,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          key: const Key('test_on_auth_zone_button'),
                          onPressed: () => _onLogin(context),
                          child: Text(context.saveButtonTitle),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _onLogin(BuildContext context) {
    if (formKey.currentState?.validate() == true) {
      final String pin = pinController.text;

      if (pin.isNotEmpty) {
        formKey.currentState?.save();
        context.read<PinPageBloc>().add(
              PinPageBlocEvent.login(pin: pin),
            );
      }
    }
  }
}

extension on BuildContext {
  String get pinTextFieldTitle => 'Pin';
  String get saveButtonTitle => 'Login';
}

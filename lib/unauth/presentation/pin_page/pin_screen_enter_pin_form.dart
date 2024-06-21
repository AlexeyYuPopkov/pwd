import 'dart:math' show max, min;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/app_settings.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/clocks_widget.dart';
import 'package:pwd/l10n/localization_helper.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/pin_page_bloc.dart';
import 'pin_screen_test_helper.dart';

final class PinScreenEnterPinForm extends StatefulWidget {
  static const maxWidth = 400.0;
  final TimeFormatter timeFormatter;
  const PinScreenEnterPinForm({
    super.key,
    required this.timeFormatter,
  });

  @override
  State<PinScreenEnterPinForm> createState() => PinScreenEnterPinFormState();
}

final class PinScreenEnterPinFormState extends State<PinScreenEnterPinForm> {
  late final formKey = GlobalKey<FormState>();
  late final pinController = TextEditingController();
  bool isPinVisible = false;

  @override
  void dispose() {
    pinController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textFieldTopPadding = 60.0;
    return Form(
      key: formKey,
      child: LayoutBuilder(builder: (context, constraints) {
        final topSpace = max(
          constraints.maxHeight / 3.0,
          ClocksWidget.minClocksContainerHeight,
        ).round().toDouble();

        final textFieldWidth = min(
          constraints.maxWidth,
          PinScreenEnterPinForm.maxWidth,
        );

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: topSpace,
                child: ClocksWidget(
                  formatter: widget.timeFormatter,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: textFieldTopPadding,
                  bottom: CommonSize.indent2x,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: textFieldWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: CommonSize.indent2x),
                        child: BlocBuilder<PinPageBloc, PinPageBlocState>(
                          buildWhen: (one, other) =>
                              one.data.enterPinKeyboardType !=
                              other.data.enterPinKeyboardType,
                          builder: (context, state) {
                            return TextFormField(
                              key: const Key(PinScreenTestHelper.pinTextField),
                              controller: pinController,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  key: const Key(
                                    PinScreenTestHelper.pinVisibilityButtonKey,
                                  ),
                                  icon: Icon(
                                    isPinVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPinVisible = !isPinVisible;
                                    });
                                  },
                                ),
                                labelText: context.pinTextFieldTitle,
                              ),
                              keyboardType:
                                  state.data.enterPinKeyboardType.textInputType,
                              obscureText: !isPinVisible,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
                        key: const Key(PinScreenTestHelper.nextButton),
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

extension on EnterPinKeyboardType {
  TextInputType get textInputType {
    switch (this) {
      case EnterPinKeyboardType.number:
        return TextInputType.number;
      case EnterPinKeyboardType.password:
        return TextInputType.visiblePassword;
    }
  }
}

extension on BuildContext {
  String get pinTextFieldTitle => localization.pinScreenEnterPinFormLabelPin;
  String get saveButtonTitle => localization.pinScreenEnterPinFormButtonLogin;
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/theme/common_size.dart';

import 'bloc/pin_page_bloc.dart';

class PinPageEnterPinForm extends StatefulWidget {
  const PinPageEnterPinForm({Key? key}) : super(key: key);

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
    return Padding(
      padding: const EdgeInsets.all(CommonSize.indent2x),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: CommonSize.indent2x),
            TextFormField(
              controller: pinController,
              decoration: InputDecoration(
                labelText: context.pinTextFieldTitle,
              ),
            ),
            const SizedBox(height: CommonSize.indent2x),
            CupertinoButton(
              onPressed: () => _onLogin(context),
              child: Text(context.saveButtonTitle),
            ),
            const SizedBox(height: CommonSize.indent2x),
          ],
        ),
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

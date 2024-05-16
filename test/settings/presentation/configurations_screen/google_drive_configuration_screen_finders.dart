import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/settings/presentation/remote_configuration/google_drive_configuration_screen/google_drive_configuration_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/google_drive_configuration_screen/google_drive_configuration_screen_test_helper.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc.dart';

typedef _TestHelper = GoogleDriveConfigurationScreenTestHelper;

final class GoogleDriveConfigurationScreenFinders {
  late final screen = find.byType(GoogleDriveConfigurationScreen);

  late final filenameTextField = find.byKey(
    const Key(_TestHelper.filenameTextFieldKey),
  );

  late final nextButton = find.byKey(
    const Key(_TestHelper.nextButton),
  );

  late final deleteConfirmationDialog = find.byKey(
    const Key(DialogHelperTestHelper.okCancelDialog),
  );

  late final deleteConfirmationDialogOkButton = find.byKey(
    const Key(DialogHelperTestHelper.okCancelDialogOkButton),
  );

  TextField? filenameTextFormFieldWidget(WidgetTester tester) => tester
      .element(
        find.descendant(
          of: filenameTextField,
          matching: find.byType(TextField),
        ),
      )
      .widget as TextField;

  OutlinedButton? nextButtonWidget(WidgetTester tester) =>
      tester.element(nextButton).widget as OutlinedButton;

  SetConfigurationBloc bloc(WidgetTester tester) => tester
      .element(
        find.descendant(
          of: screen,
          matching: find.byType(CustomScrollView),
        ),
      )
      .read<SetConfigurationBloc>();
}

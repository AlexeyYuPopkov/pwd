import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/settings/presentation/remote_configuration/git_configuration_screen/git_configuration_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/git_configuration_screen/git_configuration_screen_test_helper.dart';
import 'package:pwd/settings/presentation/remote_configuration/set_configuration_bloc/set_configuration_bloc.dart';
import 'package:pwd/settings/presentation/remote_configuration/widgets/configuration_form_next_buttom_widget.dart';

final class GitConfigurationScreenFinders {
  final screen = find.byType(GitConfigurationScreen);

  final tokenTextField = find.byKey(
    const Key(GitConfigurationScreenTestHelper.tokenTextField),
  );
  final repoTextField = find.byKey(
    const Key(GitConfigurationScreenTestHelper.repoTextField),
  );
  final ownerTextField = find.byKey(
    const Key(GitConfigurationScreenTestHelper.ownerTextField),
  );
  final branchTextField = find.byKey(
    const Key(GitConfigurationScreenTestHelper.branchTextField),
  );
  final fileNameTextField = find.byKey(
    const Key(GitConfigurationScreenTestHelper.fileNameTextField),
  );

  final nextButton = find.byKey(
    const Key(ConfigurationFormNextButtomWidget.outlinedButtonKey),
  );

  late final deleteConfirmationDialog = find.byKey(
    const Key(DialogHelperTestHelper.okCancelDialog),
  );

  late final deleteConfirmationDialogOkButton = find.byKey(
    const Key(DialogHelperTestHelper.okCancelDialogOkButton),
  );

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

  TextField? tokenTextFieldWidget(WidgetTester tester) => tester
      .element(
        find.descendant(
          of: tokenTextField,
          matching: find.byType(TextField),
        ),
      )
      .widget as TextField;

  TextField? repoTextFieldWidget(WidgetTester tester) => tester
      .element(
        find.descendant(
          of: repoTextField,
          matching: find.byType(TextField),
        ),
      )
      .widget as TextField;

  TextField? ownerTextFieldWidget(WidgetTester tester) => tester
      .element(
        find.descendant(
          of: ownerTextField,
          matching: find.byType(TextField),
        ),
      )
      .widget as TextField;

  TextField? branchTextFieldWidget(WidgetTester tester) => tester
      .element(
        find.descendant(
          of: branchTextField,
          matching: find.byType(TextField),
        ),
      )
      .widget as TextField;

  TextField? fileNameTextFieldWidget(WidgetTester tester) => tester
      .element(
        find.descendant(
          of: fileNameTextField,
          matching: find.byType(TextField),
        ),
      )
      .widget as TextField;
}

import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/data/clock_configuration_provider_impl.dart';
import 'package:pwd/common/domain/clock_configuration_provider.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/domain/usecases/clock_usecase.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/unauth/domain/usecases/login_usecase.dart';
import 'package:pwd/unauth/presentation/pin_page/bloc/pin_page_bloc.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_screen.dart';
import 'package:pwd/unauth/presentation/pin_page/pin_screen_enter_pin_form.dart';

import '../../../integration_test/pages/pin_screen/pin_screen_finders.dart';
import '../../test_tools/app_configuration_provider_tool.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

void main() {
  group('PinScreen - UI', () {
    setUpAll(() {
      final di = DiStorage.shared;

      AppConfigurationProviderTool.bindAppConfigurationProvider();

      di.bind<TimeFormatter>(
        () => TimeFormatterImpl(),
        module: null,
        lifeTime: const LifeTime.single(),
      );

      di.bind<ClockConfigurationProvider>(
        () => ClockConfigurationProviderImpl(),
        module: null,
        lifeTime: const LifeTime.single(),
      );

      di.bind<ClockUsecase>(
        () => ClockUsecase(
          clockConfigurationProvider: di.resolve(),
        ),
        module: null,
        lifeTime: const LifeTime.single(),
      );

      di.bind<LoginUsecase>(
        () => MockLoginUsecase(),
        module: null,
        lifeTime: const LifeTime.single(),
      );
    });

    tearDownAll(() {
      DiStorage.shared.removeAll();
    });

    testWidgets(
      'PinScreen: enter pin and login',
      (tester) async {
        final finders = PinScreenFinders();

        await _Tools.setupAndShowScreen(tester, finders: finders);

        final testField = find.descendant(
          of: finders.pinField,
          matching: find.byType(TextField),
        );

        expect(tester.widget<TextField>(testField).obscureText, true);

        await tester.tap(finders.pinField);
        await tester.enterText(finders.pinField, '1234');

        await tester.tap(finders.pinVisibilityButton);

        await tester.pumpAndSettle();

        expect(tester.widget<TextField>(testField).obscureText, false);

        await tester.pumpAndSettle();

        expect(
          tester
              .state<PinScreenEnterPinFormState>(finders.form)
              .pinController
              .text,
          '1234',
        );

        final LoginUsecase usecase = DiStorage.shared.resolve();

        when(
          () => usecase.execute('1234'),
        ).thenAnswer(
          (invocation) => Future.value(),
        );

        await tester.tap(finders.nextButton);

        await tester.pumpAndSettle();

        expect(
          tester.element(finders.form).read<PinPageBloc>().state,
          isA<DidLoginState>(),
        );

        verify(() => usecase.execute('1234'));
      },
    );

    testWidgets(
      'PinScreen: enter pin and login with error',
      (tester) async {
        final finders = PinScreenFinders();

        await _Tools.setupAndShowScreen(tester, finders: finders);

        final testField = find.descendant(
          of: finders.pinField,
          matching: find.byType(TextField),
        );

        expect(tester.widget<TextField>(testField).obscureText, true);

        await tester.tap(finders.pinField);
        await tester.enterText(finders.pinField, '1234');

        await tester.tap(finders.pinVisibilityButton);

        await tester.pumpAndSettle();

        expect(tester.widget<TextField>(testField).obscureText, false);

        await tester.pumpAndSettle();

        expect(
          tester
              .state<PinScreenEnterPinFormState>(finders.form)
              .pinController
              .text,
          '1234',
        );

        final LoginUsecase usecase = DiStorage.shared.resolve();

        when(
          () => usecase.execute('1234'),
        ).thenThrow(TestException());

        await tester.tap(finders.nextButton);

        await tester.pumpAndSettle();

        expect(
          tester.element(finders.form).read<PinPageBloc>().state,
          isA<ErrorState>(),
        );

        final errorDialog = find.byKey(
          const Key(DialogHelperTestHelper.errorDialog),
        );

        expect(errorDialog, findsOneWidget);
        expect(find.text(TestException.messageText), findsOneWidget);

        verify(() => usecase.execute('1234'));
      },
    );
  });
}

final class _Tools {
  static Future<void> setupAndShowScreen(
    WidgetTester tester, {
    required PinScreenFinders finders,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlockingLoadingIndicator(
          child: const PinScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(finders.screen, findsOneWidget);
    expect(finders.blocConsumer, findsOneWidget);
    expect(finders.form, findsOneWidget);
    expect(finders.pinField, findsOneWidget);
    expect(finders.pinVisibilityButton, findsOneWidget);
    expect(finders.nextButton, findsOneWidget);

    expect(tester.widget<OutlinedButton>(finders.nextButton).enabled, true);

    expect(finders.blocConsumer, findsOneWidget);

    expect(
      tester.element(finders.form).read<PinPageBloc>().state,
      isA<InitializingState>(),
    );
  }
}

final class TestException extends AppError {
  static const messageText = 'error text';
  TestException() : super(message: messageText);
}

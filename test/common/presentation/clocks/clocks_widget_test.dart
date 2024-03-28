import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/data/clock_configuration_provider_impl.dart';
import 'package:pwd/common/domain/clock_configuration_provider.dart';
import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/domain/usecases/clock_timer_usecase.dart';
import 'package:pwd/common/domain/usecases/clock_usecase.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/bloc/clocks_widget_bloc.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/clocks_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clocks_widget_finders.dart';

class ClockTimerUsecaseMock implements ClockTimerUsecase {
  @override
  late final timerStream = Stream.fromFuture(
    Future.value(DateTime.now()),
  ).asBroadcastStream();
}

void main() {
  group('ClocksWidget', () {
    late final TimeFormatter formatter = TimeFormatterImpl();
    late ClocksWidgetFinders finders;
    late ClockConfigurationProvider clockConfigurationProvider;

    setUp(() {
      finders = ClocksWidgetFinders();

      SharedPreferences.setMockInitialValues(
        {
          'ClockConfigurationProviderImpl.Clocks': '',
        },
      );

      clockConfigurationProvider = ClockConfigurationProviderImpl();

      final di = DiStorage.shared;

      di.bind<ClockTimerUsecase>(
        () => ClockTimerUsecaseMock(),
        module: null,
        lifeTime: const LifeTime.single(),
      );

      di.bind<ClockUsecase>(
        () => ClockUsecase(
          clockConfigurationProvider: clockConfigurationProvider,
        ),
        module: null,
        lifeTime: const LifeTime.single(),
      );
    });

    tearDown(() {
      DiStorage.shared.removeAll();
    });

    Future<void> setupAndShowScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlockingLoadingIndicator(
            child: SizedBox(
              width: 400.0,
              height: 600.0,
              child: ClocksWidget(
                formatter: formatter,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('Initial state', (tester) async {
      await setupAndShowScreen(tester);
      expect(finders.blocBuilder, findsOneWidget);
      expect(finders.list, findsOneWidget);
      expect(finders.clockItem(0), findsNothing);

      await tester.pumpAndSettle(Durations.extralong1);

      await tester.ensureVisible(finders.list);

      final now = DateTime.now();

      final expected = ClockModel(
        id: '1',
        label: '',
        timeZoneOffset: now.timeZoneOffset,
      );

      final bloc = tester.element(finders.blocBuilder).read<ClocksWidgetBloc>();

      expect(bloc.state is CommonState, true);

      expect(bloc.state.data.clocks.length, 1);
      expect(bloc.state.data.clocks[0].label, expected.label);
      expect(
        bloc.state.data.clocks[0].timeZoneOffset,
        expected.timeZoneOffset,
      );

      expect(finders.clockItem(0), findsOneWidget);

      // await tester.pumpWidget(Container());
      // await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('Long tap and show menu', (tester) async {
      await setupAndShowScreen(tester);
      await tester.pumpAndSettle(Durations.extralong1);

      expect(finders.clockItem(0), findsOneWidget);
      expect(finders.clockWidgets(), findsNWidgets(1));

      await tester.longPress(finders.clockItem(0));

      await tester.pumpAndSettle();

      expect(finders.menu, findsOneWidget);

      await tester.ensureVisible(finders.menu);
    });

    testWidgets('Edit', (tester) async {
      await setupAndShowScreen(tester);
      await tester.pumpAndSettle(Durations.extralong1);

      final bloc = tester.element(finders.blocBuilder).read<ClocksWidgetBloc>();

      expect(bloc.state.data.clocks[0].label, '');
      expect(
        bloc.state.data.clocks[0].timeZoneOffset,
        const Duration(hours: 2),
      );

      await tester.longPress(finders.clockItem(0));

      await tester.pumpAndSettle();

      expect(finders.menu, findsOneWidget);

      await tester.tap(finders.menuEditButton);

      await tester.pumpAndSettle();

      expect(finders.addClockDialog, findsOneWidget);
      expect(finders.addClockDialogTextField, findsOneWidget);
      expect(finders.addClockDialogSlider, findsOneWidget);
      expect(finders.addClockDialogSaveButton, findsOneWidget);

      await Future.wait([
        tester.ensureVisible(finders.addClockDialog),
        tester.ensureVisible(finders.addClockDialogTextField),
        tester.ensureVisible(finders.addClockDialogSlider),
        tester.ensureVisible(finders.addClockDialogSaveButton),
      ]);

      await tester.tap(finders.addClockDialogTextField);
      await tester.enterText(finders.addClockDialogTextField, '123');
      await tester.drag(finders.addClockDialogSlider, const Offset(100, 0));
      await tester.tap(finders.addClockDialogSaveButton);

      await tester.pumpAndSettle(Durations.extralong1);

      expect(finders.addClockDialog, findsNothing);

      expect(bloc.state.data.clocks[0].label, '123');
      expect(
        bloc.state.data.clocks[0].timeZoneOffset != const Duration(hours: 2),
        true,
      );
    });

    testWidgets('Add then delete', (tester) async {
      await setupAndShowScreen(tester);
      await tester.pumpAndSettle(Durations.extralong1);

      expect(finders.clockItem(0), findsOneWidget);
      expect(finders.clockWidgets(), findsNWidgets(1));

      await tester.longPress(finders.clockItem(0));

      await tester.pumpAndSettle();

      expect(finders.menu, findsOneWidget);

      await tester.tap(finders.menuAddButton);

      await tester.pumpAndSettle();

      expect(finders.addClockDialog, findsOneWidget);
      expect(finders.addClockDialogTextField, findsOneWidget);
      expect(finders.addClockDialogSlider, findsOneWidget);
      expect(finders.addClockDialogSaveButton, findsOneWidget);

      await Future.wait([
        tester.ensureVisible(finders.addClockDialog),
        tester.ensureVisible(finders.addClockDialogTextField),
        tester.ensureVisible(finders.addClockDialogSlider),
        tester.ensureVisible(finders.addClockDialogSaveButton),
      ]);

      await tester.tap(finders.addClockDialogTextField);
      await tester.enterText(finders.addClockDialogTextField, '123');
      await tester.drag(finders.addClockDialogSlider, const Offset(100, 0));
      await tester.tap(finders.addClockDialogSaveButton);

      await tester.pumpAndSettle(Durations.extralong1);

      expect(finders.addClockDialog, findsNothing);

      expect(finders.clockItem(0), findsOneWidget);
      expect(finders.clockItem(1), findsOneWidget);
      expect(finders.clockWidgets(), findsNWidgets(2));

      await tester.longPress(finders.clockItem(1));

      expect(finders.menu, findsOneWidget);

      await tester.tap(finders.menuDeleteButton);

      await tester.pumpAndSettle();

      expect(finders.menu, findsNothing);

      expect(finders.clockItem(0), findsOneWidget);
      expect(finders.clockWidgets(), findsNWidgets(1));
    });
  });
}

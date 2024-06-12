import 'package:di_storage/di_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/data/remote_configuration_provider_impl.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/settings/domain/reorder_configurations_usecase.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/configurations_screen.dart';

import '../../../test_tools/app_configuration_provider_tool.dart';
import '../../../test_tools/test_tools.dart';
import 'configurations_screen_finders.dart';

class MockSecureStorage extends Mock implements SecureStorageBox {}

class DummyOnRouter {
  final List<Object> calls = [];

  Future dummyOnRoute(BuildContext context, Object route) async =>
      calls.add(route);
}

void main() {
  final finders = ConfigurationsScreenFinders();

  const gitConfiguration = GitConfiguration(
    token: '',
    repo: '',
    owner: '',
    branch: '',
    fileName: 'fileName1',
  );

  const googleDriveConfiguration = GoogleDriveConfiguration(
    fileName: 'fileName2',
  );

  late MockSecureStorage storage;

  late DummyOnRouter mockRouter;

  setUp(
    () {
      AppConfigurationProviderTool.bindAppConfigurationProvider();

      storage = MockSecureStorage();

      DiStorage.shared.bind<RemoteConfigurationProvider>(
        module: null,
        () => RemoteConfigurationProviderImpl(storage: storage),
        lifeTime: const LifeTime.single(),
      );

      DiStorage.shared.bind<ReorderConfigurationsUsecase>(
        module: null,
        () => ReorderConfigurationsUsecase(
          remoteStorageConfigurationProvider: DiStorage.shared.resolve(),
        ),
        lifeTime: const LifeTime.single(),
      );

      mockRouter = DummyOnRouter();
    },
  );

  tearDown(
    () => DiStorage.shared.removeAll(),
  );

  Future<void> setupAndShowScreen(
    WidgetTester tester, {
    required ConfigurationsScreenFinders finders,
  }) async {
    await tester.pumpWidget(
      CreateApp.createMaterialApp(
        child: ConfigurationsScreen(
          onRoute: mockRouter.dummyOnRoute,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(finders.addNoteConfigurationButton, findsOneWidget);
  }

  group('ConfigurationsScreen tests', () {
    testWidgets('noDataPlaceholder if there are no configurations',
        (tester) async {
      when(
        () => storage.readConfiguration(),
      ).thenAnswer(
        (_) async => RemoteConfigurations.empty(),
      );

      await setupAndShowScreen(tester, finders: finders);

      await tester.pumpAndSettle();

      expect(finders.noDataPlaceholder, findsOneWidget);
      expect(finders.addNoteConfigurationButton, findsOneWidget);
      expect(finders.noDataPlaceholderButton, findsOneWidget);

      await tester.tap(finders.noDataPlaceholderButton);
      await tester.pumpAndSettle();

      expect(finders.googleActionSheetFinder, findsOneWidget);
      expect(finders.gitActionSheetFinder, findsOneWidget);
      expect(finders.cancelActionSheetFinder, findsOneWidget);

      await tester.tap(finders.cancelActionSheetFinder);
      await tester.pumpAndSettle();

      expect(finders.googleActionSheetFinder, findsNothing);
      expect(finders.gitActionSheetFinder, findsNothing);
      expect(finders.cancelActionSheetFinder, findsNothing);
    });

    testWidgets('Check route to git config', (tester) async {
      when(
        () => storage.readConfiguration(),
      ).thenAnswer(
        (invocation) async {
          return RemoteConfigurations.createOrThrow(
            configurations: const [
              gitConfiguration,
              googleDriveConfiguration,
            ],
          );
        },
      );

      await setupAndShowScreen(tester, finders: finders);

      await tester.pumpAndSettle();
      await tester.tap(finders.getItemFor(gitConfiguration));
      await tester.pumpAndSettle();

      final routerData =
          mockRouter.calls.whereType<OnSetupConfigurationRoute>().firstOrNull;

      expect(routerData?.type == ConfigurationType.git, true);
      expect(routerData?.configuration is Equatable, true);
      expect(routerData?.configuration == gitConfiguration, true);
    });

    testWidgets('Check route to google drive config', (tester) async {
      when(
        () => storage.readConfiguration(),
      ).thenAnswer(
        (invocation) async {
          return RemoteConfigurations.createOrThrow(
            configurations: const [
              gitConfiguration,
              googleDriveConfiguration,
            ],
          );
        },
      );

      await setupAndShowScreen(tester, finders: finders);

      await tester.pumpAndSettle();
      await tester.tap(finders.getItemFor(googleDriveConfiguration));
      await tester.pumpAndSettle();

      final routerData =
          mockRouter.calls.whereType<OnSetupConfigurationRoute>().firstOrNull;

      expect(routerData?.type == ConfigurationType.googleDrive, true);
      expect(routerData?.configuration is Equatable, true);
      expect(routerData?.configuration == googleDriveConfiguration, true);
    });

    testWidgets('Check route to new git drive config', (tester) async {
      when(
        () => storage.readConfiguration(),
      ).thenAnswer(
        (invocation) async {
          return RemoteConfigurations.createOrThrow(
            configurations: const [],
          );
        },
      );

      await setupAndShowScreen(tester, finders: finders);
      await tester.pumpAndSettle();

      expect(finders.addNoteConfigurationButton, findsOneWidget);

      await tester.tap(finders.addNoteConfigurationButton);
      await tester.pumpAndSettle();

      await tester.tap(finders.gitActionSheetFinder);
      await tester.pumpAndSettle();

      expect(finders.gitActionSheetFinder, findsNothing);

      expect(
        mockRouter.calls
                .whereType<OnSetupConfigurationRoute>()
                .firstOrNull
                ?.type ==
            ConfigurationType.git,
        true,
      );
    });

    testWidgets('Check route to new google drive config', (tester) async {
      when(
        () => storage.readConfiguration(),
      ).thenAnswer(
        (invocation) async {
          return RemoteConfigurations.createOrThrow(
            configurations: const [],
          );
        },
      );

      await setupAndShowScreen(tester, finders: finders);
      await tester.pumpAndSettle();

      expect(finders.addNoteConfigurationButton, findsOneWidget);

      await tester.tap(finders.addNoteConfigurationButton);
      await tester.pumpAndSettle();

      await tester.tap(finders.googleActionSheetFinder);
      await tester.pumpAndSettle();

      expect(finders.googleActionSheetFinder, findsNothing);

      expect(
        mockRouter.calls
                .whereType<OnSetupConfigurationRoute>()
                .firstOrNull
                ?.type ==
            ConfigurationType.googleDrive,
        true,
      );
    });
  });

  group('ConfigurationsScreen check items reorder', () {
    testWidgets('Check route to git config', (tester) async {
      // setup mocks
      final originalConfigurations = RemoteConfigurations.createOrThrow(
        configurations: const [
          gitConfiguration,
          googleDriveConfiguration,
        ],
      );

      when(() => storage.readConfiguration()).thenAnswer(
        (_) async => originalConfigurations,
      );
      // end setup mocks

      await setupAndShowScreen(tester, finders: finders);

      await tester.pumpAndSettle();

      final bloc = finders.bloc(tester);

      expect(bloc.state.data.items.length, 2);
      expect(bloc.state.data.items[0], gitConfiguration);
      expect(bloc.state.data.items[1], googleDriveConfiguration);

      // setup mocks
      final newConfigurations = RemoteConfigurations.createOrThrow(
        configurations: const [
          googleDriveConfiguration,
          gitConfiguration,
        ],
      );

      when(
        () => storage.writeConfigurations(newConfigurations),
      ).thenAnswer(
        (_) async {},
      );

      when(() => storage.readConfiguration()).thenAnswer(
        (_) async => newConfigurations,
      );
      // end setup mocks

      await tester.ensureVisible(
        finders.getReorderIconKeyFor(gitConfiguration),
      );
      await tester.ensureVisible(
        finders.getReorderIconKeyFor(googleDriveConfiguration),
      );

      final item = finders.getReorderIconKeyFor(gitConfiguration);

      final drag = await tester.startGesture(
        tester.getCenter(item),
      );

      await tester.pump(kLongPressTimeout + kPressTimeout);

      final offset = tester.getBottomLeft(
        finders.getItemFor(gitConfiguration),
      );

      await drag.moveTo(Offset(offset.dx, offset.dy * 2));
      await drag.up();

      await tester.pumpAndSettle(Durations.extralong1);

      expect(bloc.state.data.items.length, 2);
      expect(bloc.state.data.items[1], gitConfiguration);
      expect(bloc.state.data.items[0], googleDriveConfiguration);
    });
  });
}

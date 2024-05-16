import 'package:di_storage/di_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/configurations_screen.dart';
import 'package:pwd/theme/theme_data.dart';

import 'configurations_screen_finders.dart';
import '../../../test_tools/app_configuration_provider_tool.dart';

class MockRemoteStorageConfigurationProvider extends Mock
    implements RemoteConfigurationProvider {}

class DummyOnRouter {
  final List<Object> calls = [];

  Future dummyOnRoute(BuildContext context, Object route) async {
    calls.add(route);
  }
}

void main() {
  final finders = ConfigurationsScreenFinders();

  const gitConfiguration = GitConfiguration(
    token: '',
    repo: '',
    owner: '',
    branch: '',
    fileName: 'fileName',
  );

  const googleDriveConfiguration = GoogleDriveConfiguration(
    fileName: 'fileName',
  );

  late RemoteConfigurationProvider remoteStorageConfigurationProvider;

  late DummyOnRouter mockRouter;

  setUp(
    () {
      AppConfigurationProviderTool.bindAppConfigurationProvider();

      DiStorage.shared.bind<RemoteConfigurationProvider>(
        module: null,
        () => MockRemoteStorageConfigurationProvider(),
        lifeTime: const LifeTime.single(),
      );

      remoteStorageConfigurationProvider = DiStorage.shared.resolve();
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
      MaterialApp(
        theme: lightThemeData,
        home: BlockingLoadingIndicator(
          child: ConfigurationsScreen(
            onRoute: mockRouter.dummyOnRoute,
          ),
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
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(
        RemoteConfigurations(configurations: const []),
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

    testWidgets('Check route to git drive config', (tester) async {
      when(
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(
        RemoteConfigurations(
          configurations: const [
            gitConfiguration,
            googleDriveConfiguration,
          ],
        ),
      );

      await setupAndShowScreen(tester, finders: finders);

      await tester.pumpAndSettle();
      await tester.tap(finders.getItemFor(ConfigurationType.git));
      await tester.pumpAndSettle();

      final routerData =
          mockRouter.calls.whereType<OnSetupConfigurationRoute>().firstOrNull;

      expect(routerData?.type == ConfigurationType.git, true);
      expect(routerData?.configuration is Equatable, true);
      expect(routerData?.configuration == gitConfiguration, true);
    });

    testWidgets('Check route to google drive config', (tester) async {
      when(
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(
        RemoteConfigurations(
          configurations: const [
            gitConfiguration,
            googleDriveConfiguration,
          ],
        ),
      );

      await setupAndShowScreen(tester, finders: finders);

      await tester.pumpAndSettle();
      await tester.tap(finders.getItemFor(ConfigurationType.googleDrive));
      await tester.pumpAndSettle();

      final routerData =
          mockRouter.calls.whereType<OnSetupConfigurationRoute>().firstOrNull;

      expect(routerData?.type == ConfigurationType.googleDrive, true);
      expect(routerData?.configuration is Equatable, true);
      expect(routerData?.configuration == googleDriveConfiguration, true);
    });

    testWidgets('Check route to new git drive config', (tester) async {
      when(
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(
        RemoteConfigurations(
          configurations: const [],
        ),
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
        () => remoteStorageConfigurationProvider.currentConfiguration,
      ).thenReturn(
        RemoteConfigurations(
          configurations: const [],
        ),
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
}

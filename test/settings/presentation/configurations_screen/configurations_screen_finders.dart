import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/presentation/dialogs/action_sheet.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/bloc/configurations_screen_bloc.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/configurations_screen.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/configurations_screen_test_helper.dart';

typedef _TestHelper = ConfigurationsScreenTestHelper;

final class ConfigurationsScreenFinders {
  ConfigurationsScreenFinders();

  Finder getItemFor(RemoteConfiguration configuration) => find.byKey(
        Key(_TestHelper.getItemKeyFor(configuration.id)),
      );

  Finder getReorderIconKeyFor(RemoteConfiguration configuration) => find.byKey(
        Key(_TestHelper.getReorderIconKeyFor(configuration.id)),
      );

  late final screen = find.byType(ConfigurationsScreen);

  late final noDataPlaceholder = find.byKey(
    const Key(_TestHelper.noDataPlaceholder),
  );

  late final noDataPlaceholderButton = find.byKey(
    const Key(_TestHelper.noDataPlaceholderButton),
  );

  late final addNoteConfigurationButton = find.byKey(
    const Key(_TestHelper.addNoteConfigurationButton),
  );

  late final googleActionSheetFinder = find.byKey(
    Key(
      ActionSheetTestHelper.getItemKeyFor(
        ConfigurationsScreenTestHelper.addActionSheetGoogleDrive,
      ),
    ),
  );

  late final gitActionSheetFinder = find.byKey(
    Key(
      ActionSheetTestHelper.getItemKeyFor(
        ConfigurationsScreenTestHelper.addActionSheetGit,
      ),
    ),
  );

  late final cancelActionSheetFinder = find.byKey(
    Key(
      ActionSheetTestHelper.getItemKeyFor(
        ConfigurationsScreenTestHelper.addActionSheetCancel,
      ),
    ),
  );

  ConfigurationsScreenBloc bloc(WidgetTester tester) => tester
      .element(
        find.descendant(
          of: screen,
          matching: find.byType(Scaffold),
        ),
      )
      .read<ConfigurationsScreenBloc>();
}

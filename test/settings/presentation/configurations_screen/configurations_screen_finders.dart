import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/presentation/dialogs/action_sheet.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/configurations_screen_test_helper.dart';

typedef _TestHelper = ConfigurationsScreenTestHelper;

final class ConfigurationsScreenFinders {
  Finder getItemFor(ConfigurationType type) => find.byKey(
        Key(_TestHelper.getItemKeyFor(type)),
      );

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
}

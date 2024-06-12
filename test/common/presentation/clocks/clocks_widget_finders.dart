import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/clock/clock_widget.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/bloc/clocks_widget_bloc.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/clocks_widget_test_helper.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/widgets/add_clock_dialog.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/widgets/clock_item_widget.dart';

final class ClocksWidgetFinders {
  final blocBuilder =
      find.byType(BlocBuilder<ClocksWidgetBloc, ClocksWidgetState>);

  Finder clockItem(int index) => find.byKey(
        Key(ClocksWidgetTestHelper.clockItemKey(index)),
      );

  Finder clockWidgets() => find.byType(ClockWidget);

  final menu = find.byType(ClockItemOwerlayMenuContent);

  final menuEditButton = find.byKey(
    Key(ClocksWidgetTestHelper.clockWidgetEditButtonKey),
  );
  final menuAddButton = find.byKey(
    Key(ClocksWidgetTestHelper.clockWidgetAddButtonKey),
  );
  final menuDeleteButton = find.byKey(
    Key(ClocksWidgetTestHelper.clockWidgetDeleteButtonKey),
  );

  final addClockDialog = find.byType(AddClockDialog);

  late final addClockDialogTextField = find.descendant(
    of: addClockDialog,
    matching: find.byType(TextFormField),
  );

  late final addClockDialogSlider = find.descendant(
    of: addClockDialog,
    matching: find.byType(Slider),
  );

  late final addClockDialogSaveButton = find.descendant(
    of: addClockDialog,
    matching: find.byType(OutlinedButton),
  );
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/bloc/clocks_widget_bloc.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/clocks_widget_test_helper.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/widgets/clock_item_widget.dart';

final class ClocksWidgetFinders {
  final blocBuilder =
      find.byType(BlocBuilder<ClocksWidgetBloc, ClocksWidgetState>);
  final list = find.byType(ListView);

  Finder clockItem(int index) => find.byKey(
        Key(ClocksWidgetTestHelper.clockItemKey(index)),
      );

  Finder clockWidget(ClockModel clock) => find.byKey(
        Key(ClocksWidgetTestHelper.clockWidgetKey(clock)),
      );

  final menu = find.byType(ClockItemOwerlayMenuContent);
}

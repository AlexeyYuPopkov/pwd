import 'dart:math' show min, max;

import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/domain/usecases/clock_timer_usecase.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/clocks_widget_test_helper.dart';
import 'package:pwd/theme/common_size.dart';

import 'widgets/add_clock_dialog.dart';
import 'bloc/clocks_widget_bloc.dart';
import 'widgets/clock_item_widget.dart';

final class ClocksWidget extends StatelessWidget {
  static const minClocksContainerHeight = 222.0;
  static const maxClocksContainerHeight = 350.0;
  final TimeFormatter formatter;

  ClockTimerUsecase get clockTimerUsecase => DiStorage.shared.resolve();

  const ClocksWidget({
    super.key,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const separatorWidth = CommonSize.indent;
      final preferredWidth = (constraints.maxWidth ~/ 3) - 2.0 * separatorWidth;
      const minWidth = 90.0;
      const maxWidth = 190.0;

      final itemWidth = min(
        maxWidth,
        max(minWidth, preferredWidth),
      ).round().toDouble();

      return BlocProvider(
        create: (context) => ClocksWidgetBloc(
          clockUsecase: DiStorage.shared.resolve(),
        ),
        child: BlocBuilder<ClocksWidgetBloc, ClocksWidgetState>(
          builder: (context, state) {
            final length = state.data.clocks.length;

            return SizedBox(
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int index = 0; index < length; index++)
                            SizedBox(
                              width: itemWidth,
                              child: ClockItemWidget(
                                key: Key(
                                  ClocksWidgetTestHelper.clockItemKey(index),
                                ),
                                clock: state.data.clocks[index],
                                formatter: formatter,
                                timerStream: clockTimerUsecase.timerStream,
                                onEdit: () => _onEditClock(context,
                                    clock: state.data.clocks[index]),
                                onAppend: () =>
                                    _onEditClock(context, clock: null),
                                onDelete: () => _onDelete(
                                  context,
                                  clock: state.data.clocks[index],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void _onDelete(BuildContext context, {required ClockModel clock}) => context
      .read<ClocksWidgetBloc>()
      .add(ClocksWidgetEvent.delete(clock: clock));

  void _onEditClock(
    BuildContext context, {
    required ClockModel? clock,
  }) async {
    final bloc = context.read<ClocksWidgetBloc>();
    final result = await showDialog(
      context: context,
      builder: (dialogContext) {
        return AddClockDialog(
          clock: clock ?? ClockModel.newClock(),
        );
      },
    );

    if (result is ClockModel) {
      bloc.add(
        ClocksWidgetEvent.addClock(
          parameters: result,
        ),
      );
    }
  }
}

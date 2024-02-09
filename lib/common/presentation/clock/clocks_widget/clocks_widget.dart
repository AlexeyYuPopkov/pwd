import 'dart:math' show min;

import 'package:di_storage/di_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/theme/common_size.dart';

import '../clock_widget.dart';
import '../clock_widget24.dart';
import 'add_clock_dialog.dart';
import 'bloc/clocks_widget_bloc.dart';

class ClocksWidget extends StatelessWidget {
  final TimeFormatter formatter;

  const ClocksWidget({
    super.key,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      final itemSize =
          min(constraints.maxWidth ~/ 3, constraints.maxHeight).toDouble();

      return BlocProvider(
        create: (context) => ClocksWidgetBloc(
          clockUsecase: DiStorage.shared.resolve(),
        ),
        child: BlocBuilder<ClocksWidgetBloc, ClocksWidgetState>(
          builder: (context, state) {
            final bloc = context.read<ClocksWidgetBloc>();
            return Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      for (final clock in state.data.parameters)
                        SizedBox(
                          width: itemSize,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: CommonSize.indent2x,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      clock.label.isNotEmpty
                                          ? clock.label
                                          : context.localClockLabel,
                                    ),
                                    const SizedBox(height: CommonSize.indent),
                                    ClockWidget(
                                      formatter: formatter,
                                      parameters: clock,
                                      timerStream: bloc.timerStream,
                                      onEdit: () => _onEdit(context),
                                    ),
                                    const SizedBox(height: CommonSize.indent),
                                    ClockWidget24(
                                      formatter: formatter,
                                      parameters: clock,
                                      timerStream: bloc.timerStream,
                                    ),
                                  ],
                                ),
                              ),
                              if (state.isEditing)
                                Positioned(
                                  top: CommonSize.zero,
                                  right: CommonSize.zero,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.topRight,
                                    onPressed: () =>
                                        _onDelete(context, clock: clock),
                                    child: Icon(
                                      Icons.close,
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                if (state.isEditing)
                  Positioned(
                    top: CommonSize.zero,
                    right: CommonSize.zero,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.topRight,
                      onPressed: () => _onAddClock(context),
                      child: const Icon(Icons.add),
                    ),
                  ),
              ],
            );
          },
        ),
      );
    });
  }

  void _onEdit(BuildContext context) => context.read<ClocksWidgetBloc>().add(
        const ClocksWidgetEvent.edit(),
      );

  void _onDelete(BuildContext context, {required ClockModel clock}) => context
      .read<ClocksWidgetBloc>()
      .add(ClocksWidgetEvent.delete(clock: clock));

  void _onAddClock(BuildContext context) async {
    final bloc = context.read<ClocksWidgetBloc>();
    final result = await showDialog(
      context: context,
      builder: (dialogContext) {
        return const AddClockDialog();
      },
    );

    if (result is AddClockDialogResult) {
      bloc.add(
        ClocksWidgetEvent.addClock(
          parameters: ClockModel(
            label: result.label,
            timezoneOffset: Duration(hours: result.hours),
          ),
        ),
      );
    }
  }
}

extension on BuildContext {
  String get localClockLabel => 'Local';
}

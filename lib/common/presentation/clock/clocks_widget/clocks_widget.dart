import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/theme/common_size.dart';

import '../clock_widget24.dart';
import 'bloc/clocks_widget_bloc.dart';

class ClocksWidget extends StatelessWidget {
  final TimeFormatter formatter;

  const ClocksWidget({
    super.key,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = constraints.maxWidth / 3;

      return BlocProvider(
        create: (context) => ClocksWidgetBloc(
          localLabelText: context.localClockLabel,
          clockConfigurationProvider: DiStorage.shared.resolve(),
        ),
        child: BlocBuilder<ClocksWidgetBloc, ClocksWidgetState>(
          builder: (context, state) {
            final bloc = context.read<ClocksWidgetBloc>();
            return SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  for (final parameters in state.data.parameters)
                    SizedBox(
                      width: itemWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: CommonSize.indent2x,
                        ),
                        child: Column(
                          children: [
                            Text(parameters.label),
                            const SizedBox(height: CommonSize.indent),
                            ClockWidget(
                              formatter: formatter,
                              parameters: parameters,
                              timerStream: bloc.timerStream,
                            ),
                            const SizedBox(height: CommonSize.indent),
                            ClockWidget24(
                              formatter: formatter,
                              parameters: parameters,
                              timerStream: bloc.timerStream,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}

extension on BuildContext {
  String get localClockLabel => 'Local';
}

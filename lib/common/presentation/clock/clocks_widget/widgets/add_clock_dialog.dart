import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:pwd/theme/common_size.dart';

final class AddClockDialog extends StatefulWidget {
  final ClockModel clock;
  const AddClockDialog({super.key, required this.clock});

  @override
  State<AddClockDialog> createState() => _AddClockDialogState();
}

final class _AddClockDialogState extends State<AddClockDialog> {
  late final controller = TextEditingController(text: widget.clock.label);
  // TODO: fix 'inHours'
  late double value = widget.clock.timeZoneOffset.inHours.toDouble();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        color: theme.colorScheme.background,
        margin: const EdgeInsets.symmetric(horizontal: CommonSize.indent2x),
        padding: const EdgeInsets.symmetric(horizontal: CommonSize.indent),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CommonSize.indent,
                ),
                child: Material(
                  child: TextFormField(
                    controller: controller,
                  ),
                ),
              ),
              const SizedBox(height: CommonSize.indent2x),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CommonSize.indent,
                ),
                child: Text(context.timeZoneOffsetLabel(value.toInt())),
              ),
              Material(
                child: Slider.adaptive(
                  divisions: 24,
                  min: -12,
                  max: 12,
                  value: value,
                  onChanged: (value) => setState(
                    () => this.value = value.roundToDouble(),
                  ),
                ),
              ),
              const SizedBox(height: CommonSize.indent2x),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(
                    CommonSize.indent2x,
                  ),
                  child: OutlinedButton(
                    onPressed: () => _onSave(context),
                    child: Text(context.saveClock),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSave(BuildContext context) => Navigator.of(context).pop(
        widget.clock.copyWith(
          timeZoneOffset: Duration(hours: value.toInt()),
          label: controller.text,
        ),
      );
}

extension on BuildContext {
  String timeZoneOffsetLabel(int hours) => 'Time zone offset: $hours';
  String get saveClock => 'Save clock';
}

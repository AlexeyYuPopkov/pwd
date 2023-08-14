import 'package:flutter/material.dart';
import 'package:pwd/theme/common_size.dart';

class AddClockDialog extends StatefulWidget {
  const AddClockDialog({super.key});

  @override
  State<AddClockDialog> createState() => _AddClockDialogState();
}

class _AddClockDialogState extends State<AddClockDialog> {
  final controller = TextEditingController();

  var value = 0.0;

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
        AddClockDialogResult(
          hours: value.toInt(),
          label: controller.text,
        ),
      );
}

class AddClockDialogResult {
  final int hours;
  final String label;

  const AddClockDialogResult({
    required this.hours,
    required this.label,
  });
}

extension on BuildContext {
  String timeZoneOffsetLabel(int hours) => 'Time zone offset: $hours';
  String get saveClock => 'Save clock';
}

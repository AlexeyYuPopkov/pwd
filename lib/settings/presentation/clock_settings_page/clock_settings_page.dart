import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/settings/presentation/clock_settings_page/bloc/clock_settings_page_bloc.dart';
import 'package:pwd/theme/common_size.dart';

class ClockSettingsPage extends StatefulWidget {
  const ClockSettingsPage({super.key});

  @override
  State<ClockSettingsPage> createState() => _ClockSettingsPageState();
}

class _ClockSettingsPageState extends State<ClockSettingsPage> {
  late final controller = TextEditingController();

  var value = 0.0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _listener(BuildContext context, ClockSettingsPageState state) {
    if (state is DidAddClockState) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.pageTitle)),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ClockSettingsPageBloc(
            clockConfigurationProvider: DiStorage.shared.resolve(),
          ),
          child: BlocConsumer<ClockSettingsPageBloc, ClockSettingsPageState>(
            listener: _listener,
            builder: (context, state) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: CommonSize.indent),
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
              );
            },
          ),
        ),
      ),
    );
  }

  void _onSave(BuildContext context) {
    context.read<ClockSettingsPageBloc>().add(
          ClockSettingsPageEvent.addClock(
            parameters: ClockModel(
              timezoneOffset: Duration(hours: value.toInt()),
              label: controller.text,
            ),
          ),
        );
  }
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
  String get pageTitle => 'Add clock';
  String timeZoneOffsetLabel(int hours) => 'Time zone offset: $hours';
  String get saveClock => 'Save clock';
}

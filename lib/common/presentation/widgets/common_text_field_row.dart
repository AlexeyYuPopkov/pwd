import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/validators/common/common_field_input_formatter.dart';
import 'package:pwd/common/presentation/validators/common/validator.dart';
import 'package:pwd/theme/common_size.dart';

class CommonTextFieldRow extends StatelessWidget {
  final TextEditingController controller;
  final Validator validator;
  final CommonFieldInputFormatter? inputFormatter;
  final String hint;
  final String tooltipMessage;
  final bool isReadOnly;
  final bool isEnabled;

  const CommonTextFieldRow({
    super.key,
    required this.controller,
    required this.validator,
    required this.inputFormatter,
    required this.hint,
    required this.tooltipMessage,
    this.isReadOnly = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            readOnly: isReadOnly,
            enabled: isEnabled,
            controller: controller,
            decoration: InputDecoration(
              labelText: hint,
            ),
            validator: (str) => validator(str)?.message(context),
            inputFormatters: inputFormatter?.call(),
          ),
        ),
        Tooltip(
          margin: const EdgeInsets.symmetric(
            horizontal: CommonSize.indentVariant,
          ),
          message: tooltipMessage,
          child: const Icon(
            Icons.help,
            size: CommonSize.smallIcon,
          ),
        ),
      ],
    );
  }
}

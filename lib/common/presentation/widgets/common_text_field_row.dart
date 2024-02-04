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

  const CommonTextFieldRow({
    super.key,
    required this.controller,
    required this.validator,
    required this.inputFormatter,
    required this.hint,
    required this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: hint,
            ),
            validator: (str) => validator(str)?.message(context),
            inputFormatters: inputFormatter?.call(),
          ),
        ),
        Tooltip(
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

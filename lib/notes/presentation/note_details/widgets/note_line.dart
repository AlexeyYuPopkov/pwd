import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/l10n/localization_helper.dart';
import 'package:pwd/theme/common_size.dart';

final class NoteLine extends StatelessWidget with DialogHelper {
  final String text;
  final TextStyle? style;

  const NoteLine({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CommonSize.halfIndent),
      child: Row(
        children: [
          Expanded(
            child: SelectableText(
              text,
              style: style,
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(width: CommonSize.indent2x),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: CommonSize.smallIcon,
            onPressed: () => _onCopyText(context, text: text),
            child: const Padding(
              padding: EdgeInsets.only(
                left: CommonSize.indent2x,
                right: CommonSize.indent,
              ),
              child: Icon(
                Icons.copy_sharp,
                size: CommonSize.smallIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onCopyText(
    BuildContext context, {
    required String text,
  }) {
    final trimmed = text.trim();
    Clipboard.setData(ClipboardData(text: trimmed));

    showSnackBar(
      context,
      '${context.tooltipMessage} "$trimmed"',
    );
  }
}

extension on BuildContext {
  String get tooltipMessage => localization.noteDetailsScreenTooltipMessage;
}

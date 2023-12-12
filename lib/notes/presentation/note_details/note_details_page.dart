import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwd/common/presentation/dashed_divider.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/theme/common_size.dart';

class NoteDetailsPage extends StatelessWidget with ShowErrorDialogMixin {
  final NoteItem noteItem;

  const NoteDetailsPage({
    super.key,
    required this.noteItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const dashWidth = 2.0;
    const spaceWidth = 2.0;
    const thickness = 0.5;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.pageTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(CommonSize.indent2x),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (noteItem.title.isNotEmpty) ...[
                        const SizedBox(height: CommonSize.indent2x),
                        NoteLine(
                          text: noteItem.title,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                      if (noteItem.description.isNotEmpty) ...[
                        const SizedBox(height: CommonSize.indent2x),
                        NoteLine(
                          text: noteItem.description,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const Divider(thickness: thickness),
                      ],
                      const SizedBox(height: CommonSize.indent2x),
                      ...tags().map(
                        (str) => str.isEmpty
                            ? const DashedDivider(
                                height: CommonSize.indent2x,
                                thickness: thickness,
                                dash: dashWidth,
                                disaredSpace: spaceWidth,
                              )
                            : NoteLine(
                                text: str,
                                style: theme.textTheme.bodyMedium,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> tags() {
    final result = noteItem.content.split('\n').toList();
    return result;
  }
}

class NoteLine extends StatelessWidget with DialogHelper {
  final String text;
  final TextStyle? style;

  const NoteLine({
    super.key,
    required this.text,
    required this.style,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CommonSize.indent4x,
      child: Row(
        children: [
          Expanded(
            child: Text(
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
              padding: EdgeInsets.only(left: CommonSize.indent2x),
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
  String get pageTitle => 'Details';
  String get tooltipMessage => 'Copied:';
}

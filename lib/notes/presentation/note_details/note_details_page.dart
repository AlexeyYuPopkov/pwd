import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pwd/common/presentation/dialogs/show_error_dialog_mixin.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/theme/common_size.dart';

class NoteDetailsPage extends StatelessWidget with ShowErrorDialogMixin {
  final NoteItem noteItem;

  const NoteDetailsPage({
    Key? key,
    required this.noteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tooltipMessage = context.tooltipMessage;

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
                      if (noteItem.title.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: CommonSize.indent2x,
                          ),
                          child: NoteLine(
                            text: noteItem.title,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      if (noteItem.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: CommonSize.indent2x,
                          ),
                          child: NoteLine(
                            text: noteItem.description,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      const SizedBox(height: CommonSize.indent2x),
                      ...tags()
                          .map(
                            (str) => str.isEmpty
                                ? const SizedBox(
                                    height: CommonSize.indentVariant2x,
                                  )
                                : NoteLine(
                                    text: str,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                          )
                          .toList(),
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
    final result = noteItem.content
        .split('\n')
        // .where(
        //   (str) => str.isNotEmpty,
        // )
        // .map((str) => '$str')
        .toList();
    return result;
  }

  void _onCopyText(
    BuildContext context, {
    required String text,
  }) =>
      FlutterClipboard.copy(text);
}

class NoteLine extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const NoteLine({
    Key? key,
    required this.text,
    required this.style,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: style,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          width: CommonSize.indent2x,
        ),
        Tooltip(
          message: context.tooltipMessage,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _onCopyText(context, text: text),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: CommonSize.indent),
              child: Icon(
                Icons.copy_sharp,
                size: CommonSize.smallIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onCopyText(
    BuildContext context, {
    required String text,
  }) =>
      FlutterClipboard.copy(text);
}

extension on BuildContext {
  String get pageTitle => 'Details';
  String get tooltipMessage => 'Copied';
}

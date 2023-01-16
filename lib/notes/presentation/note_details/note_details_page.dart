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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (noteItem.title.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: CommonSize.indent2x),
                  child: Tooltip(
                    message: tooltipMessage,
                    onTriggered: () =>
                        _onCopyText(context, text: noteItem.title),
                    child: Text(
                      noteItem.title,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
              if (noteItem.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: CommonSize.indent2x),
                  child: Tooltip(
                    message: tooltipMessage,
                    onTriggered: () =>
                        _onCopyText(context, text: noteItem.description),
                    child: Text(
                      noteItem.description,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ),
              const SizedBox(height: CommonSize.indent2x),
              ...tags()
                  .map(
                    (str) => str.isEmpty
                        ? const SizedBox(
                            height: CommonSize.indentVariant2x,
                          )
                        : Tooltip(
                            message: tooltipMessage,
                            onTriggered: () => _onCopyText(context, text: str),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: CommonSize.indent,
                              ),
                              child: Text(
                                str,
                                style: theme.textTheme.bodyMedium,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                  )
                  .toList(),
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
        .map((str) => '$str')
        .toList();
    return result;
  }

  void _onCopyText(BuildContext context, {required String text}) {}
}

extension on BuildContext {
  String get pageTitle => 'Details';
  String get tooltipMessage => 'Copy';
}

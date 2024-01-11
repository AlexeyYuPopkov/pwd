import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/common_highlighted_row.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/theme/common_size.dart';

final class NoteListItemWidget extends StatelessWidget {
  final NoteItem note;

  final void Function(
    BuildContext context, {
    required NoteItem note,
  }) onDetailsButton;

  final void Function(
    BuildContext context, {
    required NoteItem note,
  }) onEditButton;

  const NoteListItemWidget({
    super.key,
    required this.note,
    required this.onDetailsButton,
    required this.onEditButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CommonHighlightedBackgroundRow(
      highlightedColor: Colors.grey.shade200,
      onTap: () => onDetailsButton(
        context,
        note: note,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CommonSize.indent2x,
          vertical: CommonSize.indent,
        ),
        child: Row(
          children: [
            Expanded(
              child: IgnorePointer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (note.title.isNotEmpty)
                      Text(
                        note.title,
                        style: theme.textTheme.titleMedium,
                      ),
                    if (note.description.isNotEmpty)
                      Text(
                        note.description,
                        style: theme.textTheme.titleSmall,
                      ),
                  ],
                ),
              ),
            ),
            if (!note.isDecrypted)
              Tooltip(
                message: context.rawNoteTooltipMessage,
                child: const Icon(
                  Icons.warning,
                  size: CommonSize.indent2x,
                ),
              ),
            CupertinoButton(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(left: CommonSize.indent2x),
              onPressed: () => onEditButton(
                context,
                note: note,
              ),
              child: const Icon(
                key: Key('test_npte_page_edit_icon'),
                Icons.edit,
                size: CommonSize.indent2x,
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension on BuildContext {
  String get rawNoteTooltipMessage => 'Not Encrypted';
}

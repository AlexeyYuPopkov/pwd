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

    final models = _createModels(noteItem);

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
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView.separated(
                    itemCount: models.length,
                    itemBuilder: (context, index) {
                      final item = models[index];
                      if (item is _TitleItem) {
                        return NoteLine(
                          text: item.text,
                          style: theme.textTheme.bodyLarge,
                        );
                      } else if (item is _SubtitleItem) {
                        return Column(
                          children: [
                            const SizedBox(height: CommonSize.indent2x),
                            NoteLine(
                              text: item.text,
                              style: theme.textTheme.bodyLarge,
                            ),
                            const Divider(thickness: thickness),
                          ],
                        );
                      } else if (item is _NoteItem) {
                        return NoteLine(
                          text: item.text,
                          style: theme.textTheme.bodyMedium,
                        );
                      } else if (item is _DividerItem) {
                        return const DashedDivider(
                          height: CommonSize.indent2x,
                          thickness: thickness,
                          dash: dashWidth,
                          disaredSpace: spaceWidth,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                    separatorBuilder: (_, __) => const SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_ListItem> _createModels(NoteItem noteItem) => [
        if (noteItem.title.isNotEmpty) _TitleItem(text: noteItem.title),
        if (noteItem.description.isNotEmpty)
          _SubtitleItem(text: noteItem.description),
        for (final item in noteItem.content.items)
          item.text.isEmpty || item.text == ' '
              ? const _DividerItem()
              : _NoteItem(text: item.text)
      ];
}

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
  String get pageTitle => 'Details';
  String get tooltipMessage => 'Copied:';
}

// _ListItem
abstract interface class _ListItem {
  const _ListItem();
}

final class _TitleItem implements _ListItem {
  final String text;
  const _TitleItem({required this.text});
}

final class _SubtitleItem implements _ListItem {
  final String text;
  const _SubtitleItem({required this.text});
}

final class _NoteItem implements _ListItem {
  final String text;
  const _NoteItem({required this.text});
}

final class _DividerItem extends _ListItem {
  const _DividerItem();
}

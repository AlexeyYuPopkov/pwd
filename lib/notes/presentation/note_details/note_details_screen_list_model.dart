import 'package:flutter/material.dart';
import 'package:pwd/common/presentation/dashed_divider.dart';
import 'package:pwd/theme/common_size.dart';

import 'widgets/note_line.dart';

abstract interface class NoteDetailsScreenListModel {
  const NoteDetailsScreenListModel();

  Widget build(BuildContext context);
}

final class TitleModel implements NoteDetailsScreenListModel {
  final String text;
  const TitleModel({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NoteLine(
      text: text,
      style: theme.textTheme.bodyLarge,
    );
  }
}

final class SubtitleModel implements NoteDetailsScreenListModel {
  final String text;
  const SubtitleModel({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: CommonSize.indent2x),
        NoteLine(
          text: text,
          style: theme.textTheme.bodyLarge,
        ),
        const Divider(thickness: CommonSize.thicknessHalf),
      ],
    );
  }
}

final class NoteListModel implements NoteDetailsScreenListModel {
  final String text;
  const NoteListModel({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NoteLine(
      text: text,
      style: theme.textTheme.bodyMedium,
    );
  }
}

final class DividerModel extends NoteDetailsScreenListModel {
  const DividerModel();

  @override
  Widget build(BuildContext context) => const DashedDivider(
        height: CommonSize.indent2x,
        thickness: CommonSize.thicknessHalf,
        dash: CommonSize.tinyIndent,
        disaredSpace: CommonSize.tinyIndent,
      );
}

final class NoteContent {
  String get str => items.map((e) => e.text).join('\n');

  final List<NoteContentItem> items;

  const NoteContent({required this.items});

  factory NoteContent.fromText(String str) {
    return NoteContent(
        items: str
            .split('\n')
            .map(
              (e) => NoteContentItem(text: e.trim()),
            )
            .toList());
  }
}

final class NoteContentItem {
  final String text;

  NoteContentItem({required this.text});
}

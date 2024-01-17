abstract base class NoteContentInterface {
  String get str;
  List<NoteContentItem> get items;

  const NoteContentInterface();

  operator [](int i) => items[i];
}

final class NoteStringContent extends NoteContentInterface {
  @override
  final String str;

  @override
  List<NoteContentItem> get items => str
      .split('\n')
      .map(
        (e) => NoteContentItem(text: e.trim()),
      )
      .toList();

  const NoteStringContent({required this.str});
}

final class NoteContent extends NoteContentInterface {
  @override
  String get str => items.map((e) => e.text).join('\n');

  @override
  final List<NoteContentItem> items;

  const NoteContent({required this.items});
}

final class NoteContentItem {
  final String text;

  NoteContentItem({required this.text});
}

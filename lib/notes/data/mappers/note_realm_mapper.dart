import 'package:pwd/notes/data/realm_model/note_item_realm.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/note_item_content.dart';

final class NoteRealmMapper {
  static const delimeter = '<br>';
  static NoteItem toDomain(NoteItemRealm src) {
    final result = NoteItem(
      id: src.id,

      content: NoteContent(
        items: [
          // for (final item in src.content) NoteContentItem(text: item.text),
          for (final item in src.body.split(delimeter))
            NoteContentItem(text: item),
        ],
      ),
      updated: src.updated,
      // deletedTimestamp: src.deletedTimestamp,
    );
    // debugger();
    return result;
  }

  static NoteItemRealm toData(BaseNoteItem src) {
    return NoteItemRealm(
      src.id,
      src.updated,
      src.content.items
          .map(
            (e) => e.text,
          )
          .join(delimeter),
    );
  }
}

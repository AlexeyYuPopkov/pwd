import 'package:pwd/notes/data/realm_model/note_item_realm.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/note_item_content.dart';

final class NoteRealmMapper {
  static NoteItem toDomain(NoteItemRealm src) {
    return NoteItem(
      id: src.id,
      title: src.title,
      description: src.description,
      content: NoteContent(
        items: [
          for (final item in src.content) NoteContentItem(text: item.text),
        ],
      ),
      timestamp: src.timestamp,
      isDecrypted: true,
    );
  }

  static NoteItemRealm toData(NoteItem src) {
    return NoteItemRealm(
      src.id,
      src.title,
      src.description,
      src.timestamp,
      content: [
        for (final item in src.content.items) NoteItemContentRealm(item.text),
      ],
    );
  }
}

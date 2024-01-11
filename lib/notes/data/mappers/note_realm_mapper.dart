import 'package:pwd/notes/data/realm_model/note_item_realm.dart';
import 'package:pwd/notes/domain/model/note_item.dart';

final class NoteRealmMapper {
  static NoteItem toDomain(NoteItemRealm src) {
    return NoteItem(
      id: src.id,
      title: src.title,
      description: src.description,
      content: src.content.map((e) => e.text).join('\n'),
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
      content: src.content.split('\n').map(
            (e) => NoteItemContentRealm(e.trim()),
          ),
    );
  }
}

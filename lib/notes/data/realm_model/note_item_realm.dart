import 'package:realm/realm.dart';
part 'note_item_realm.realm.dart';

@RealmModel()
class _NoteItemRealm {
  @PrimaryKey()
  late String id;
  late int updated;
  late String body;
  late bool? isDeleted;
}

// TODO: delete class [_NoteItemContentRealm]
@RealmModel(ObjectType.embeddedObject)
class _NoteItemContentRealm {
  late String text;
}

extension MarkDeleted on NoteItemRealm {
  NoteItemRealm deletedCopy({
    required int timestamp,
  }) {
    return NoteItemRealm(
      id,
      timestamp,
      '',
      isDeleted: true,
    );
  }
}

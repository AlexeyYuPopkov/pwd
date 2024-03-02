import 'package:realm/realm.dart';

part 'note_item_realm.g.dart';

@RealmModel()
class _NoteItemRealm {
  @PrimaryKey()
  late String id;
  late String title;
  late String description;
  late List<_NoteItemContentRealm> content;
  late int timestamp;
  late int? deletedTimestamp;
}

@RealmModel(ObjectType.embeddedObject)
class _NoteItemContentRealm {
  late String text;
}

extension MarkDeleted on NoteItemRealm {
  NoteItemRealm deletedCopy({
    required int timestamp,
    required int? deletedTimestamp,
  }) {
    return NoteItemRealm(
      id,
      '',
      '',
      timestamp,
      deletedTimestamp: deletedTimestamp,
      content: [],
    );
  }
}

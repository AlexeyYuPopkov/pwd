import 'package:pwd/common/tools/reusable_isolate/reusable_isolate.dart';
import 'package:pwd/notes/data/realm_model/note_item_realm.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/note_item_content.dart';
import 'package:realm/realm.dart';

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

  static NoteItem _toDomain(_NoteItemRealm src) {
    final result = NoteItem(
      id: src.id,
      content: NoteContent(
        items: [
          for (final item in src.body.split(delimeter))
            NoteContentItem(text: item),
        ],
      ),
      updated: src.updated,
    );

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

final class NotesListRealmMapper {
  static Future<List<NoteItem>> toDomainIsolated({
    required RealmResults<NoteItemRealm> realmResults,
    required bool Function(NoteItemRealm) filter,
  }) async {
    final items = realmResults.where(filter).map(
          (e) => _NoteItemRealm(id: e.id, body: e.body, updated: e.updated),
        );

    final task = ReusableIsolateTask.sync(
      params: items,
      computation: NotesListRealmMapper._toDomain,
    );

    final isolate = await ReusableIsolate.create();

    final result = await isolate.performTask(task);

    return result as List<NoteItem>;
  }

  static dynamic _toDomain(dynamic src) {
    final psrc = src as Iterable<_NoteItemRealm>;
    return [
      for (final item in psrc) NoteRealmMapper._toDomain(item),
    ];
  }
}

final class _NoteItemRealm {
  final String id;
  final String body;
  final int updated;

  _NoteItemRealm({
    required this.id,
    required this.body,
    required this.updated,
  });
}

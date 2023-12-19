import 'package:flutter/foundation.dart';
import 'package:pwd/notes/data/mappers/note_realm_mapper.dart';
import 'package:pwd/notes/domain/local_repository.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:realm/realm.dart';

import 'realm_model/note_item_realm.dart';

final class LocalRepositoryImpl implements LocalRepository {
  Realm _getRealm() {
    final config = Configuration.local([
      NoteItemRealm.schema,
      NoteItemContentRealm.schema,
    ]);
    final realm = Realm(config);

    if (kDebugMode) {
      print('Realm.config.path: ${realm.config.path}');
    }
    return realm;
  }

  @override
  Future<void> saveNotes({required List<NoteItem> notes}) async {
    final realm = _getRealm();
    final items = notes.map((e) => NoteRealmMapper.toData(e));

    realm.write(
      () => realm.addAll(
        items,
        update: true,
      ),
    );
  }
}

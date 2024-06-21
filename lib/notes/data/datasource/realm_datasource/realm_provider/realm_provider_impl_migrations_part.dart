part of 'realm_provider_impl.dart';

// Migrations
extension on RealmProviderImpl {
  void _migration5(Migration migration, int oldSchemaVersion) {
    final now = DateTime.now();
    migration.newRealm.schema.whereType<NoteItemRealm>().forEach(
          (e) => e.updated = TimestampHelper.timestampForDate(now),
        );
  }

  void _migration6(Migration migration, int oldSchemaVersion) {
    final items = migration.oldRealm.all('NoteItemRealm');

    for (final oldItem in items) {
      final newItem = migration.findInNewRealm<NoteItemRealm>(oldItem);
      if (newItem == null) {
        // That item must have been deleted, so nothing to do.
        continue;
      }

      newItem.id = oldItem.dynamic.get<String>('id');
      newItem.updated = oldItem.dynamic.get<int>('updated');

      final title = oldItem.dynamic.get<String>('title');
      final description = oldItem.dynamic.get<String>('description');
      final bodyItems =
          oldItem.dynamic.getList<NoteItemContentRealm>('content');

      newItem.body = [
        if (title.isNotEmpty) NoteItemContentRealm(title),
        if (description.isNotEmpty) NoteItemContentRealm(description),
        ...bodyItems,
      ]
          .map(
            (e) => e.text,
          )
          .join(
            NoteRealmMapper.delimeter,
          );
      newItem.isDeleted = oldItem.dynamic.get<int?>('deletedTimestamp') != null;
    }
  }

  // void _migration7(Migration migration, int oldSchemaVersion) {
  //   migration.deleteType('NoteItemContentRealm');
  // }
}

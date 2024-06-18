part of 'realm_provider_impl.dart';

// Migrations
extension on RealmProviderImpl {
  void _migration5(Migration migration, int oldSchemaVersion) {
    final now = DateTime.now();
    migration.newRealm.schema.whereType<NoteItemRealm>().forEach(
          (e) => e.updated = TimestampHelper.timestampForDate(now),
        );
  }

  // void _migration6(Migration migration, int oldSchemaVersion) {
  //   // final now = DateTime.now();
  //   // migration.deleteType('NoteItemContentRealm');

  //   // migration.newRealm.schema.whereType<NoteItemRealm>().forEach(
  //   //       (e) {
  //   //         e.updated = TimestampHelper.timestampForDate(now);
  //   //       },
  //   //     );
  // }
}

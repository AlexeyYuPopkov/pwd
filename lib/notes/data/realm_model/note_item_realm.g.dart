// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_item_realm.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class NoteItemRealm extends _NoteItemRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  NoteItemRealm(
    String id,
    String title,
    String description,
    int timestamp, {
    int? deletedTimestamp,
    Iterable<NoteItemContentRealm> content = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'timestamp', timestamp);
    RealmObjectBase.set(this, 'deletedTimestamp', deletedTimestamp);
    RealmObjectBase.set<RealmList<NoteItemContentRealm>>(
        this, 'content', RealmList<NoteItemContentRealm>(content));
  }

  NoteItemRealm._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  RealmList<NoteItemContentRealm> get content =>
      RealmObjectBase.get<NoteItemContentRealm>(this, 'content')
          as RealmList<NoteItemContentRealm>;
  @override
  set content(covariant RealmList<NoteItemContentRealm> value) =>
      throw RealmUnsupportedSetError();

  @override
  int get timestamp => RealmObjectBase.get<int>(this, 'timestamp') as int;
  @override
  set timestamp(int value) => RealmObjectBase.set(this, 'timestamp', value);

  @override
  int? get deletedTimestamp =>
      RealmObjectBase.get<int>(this, 'deletedTimestamp') as int?;
  @override
  set deletedTimestamp(int? value) =>
      RealmObjectBase.set(this, 'deletedTimestamp', value);

  @override
  Stream<RealmObjectChanges<NoteItemRealm>> get changes =>
      RealmObjectBase.getChanges<NoteItemRealm>(this);

  @override
  NoteItemRealm freeze() => RealmObjectBase.freezeObject<NoteItemRealm>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(NoteItemRealm._);
    return const SchemaObject(
        ObjectType.realmObject, NoteItemRealm, 'NoteItemRealm', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('content', RealmPropertyType.object,
          linkTarget: 'NoteItemContentRealm',
          collectionType: RealmCollectionType.list),
      SchemaProperty('timestamp', RealmPropertyType.int),
      SchemaProperty('deletedTimestamp', RealmPropertyType.int, optional: true),
    ]);
  }
}

class NoteItemContentRealm extends _NoteItemContentRealm
    with RealmEntity, RealmObjectBase, EmbeddedObject {
  NoteItemContentRealm(
    String text,
  ) {
    RealmObjectBase.set(this, 'text', text);
  }

  NoteItemContentRealm._();

  @override
  String get text => RealmObjectBase.get<String>(this, 'text') as String;
  @override
  set text(String value) => RealmObjectBase.set(this, 'text', value);

  @override
  Stream<RealmObjectChanges<NoteItemContentRealm>> get changes =>
      RealmObjectBase.getChanges<NoteItemContentRealm>(this);

  @override
  NoteItemContentRealm freeze() =>
      RealmObjectBase.freezeObject<NoteItemContentRealm>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(NoteItemContentRealm._);
    return const SchemaObject(ObjectType.embeddedObject, NoteItemContentRealm,
        'NoteItemContentRealm', [
      SchemaProperty('text', RealmPropertyType.string),
    ]);
  }
}

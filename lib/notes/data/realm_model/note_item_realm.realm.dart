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
    int updated, {
    Iterable<NoteItemContentRealm> content = const [],
    int? deletedTimestamp,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set<RealmList<NoteItemContentRealm>>(
        this, 'content', RealmList<NoteItemContentRealm>(content));
    RealmObjectBase.set(this, 'updated', updated);
    RealmObjectBase.set(this, 'deletedTimestamp', deletedTimestamp);
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
  int get updated => RealmObjectBase.get<int>(this, 'updated') as int;
  @override
  set updated(int value) => RealmObjectBase.set(this, 'updated', value);

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
  Stream<RealmObjectChanges<NoteItemRealm>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<NoteItemRealm>(this, keyPaths);

  @override
  NoteItemRealm freeze() => RealmObjectBase.freezeObject<NoteItemRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'title': title.toEJson(),
      'description': description.toEJson(),
      'content': content.toEJson(),
      'updated': updated.toEJson(),
      'deletedTimestamp': deletedTimestamp.toEJson(),
    };
  }

  static EJsonValue _toEJson(NoteItemRealm value) => value.toEJson();
  static NoteItemRealm _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'title': EJsonValue title,
        'description': EJsonValue description,
        'content': EJsonValue content,
        'updated': EJsonValue updated,
        'deletedTimestamp': EJsonValue deletedTimestamp,
      } =>
        NoteItemRealm(
          fromEJson(id),
          fromEJson(title),
          fromEJson(description),
          fromEJson(updated),
          content: fromEJson(content),
          deletedTimestamp: fromEJson(deletedTimestamp),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(NoteItemRealm._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, NoteItemRealm, 'NoteItemRealm', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('content', RealmPropertyType.object,
          linkTarget: 'NoteItemContentRealm',
          collectionType: RealmCollectionType.list),
      SchemaProperty('updated', RealmPropertyType.int),
      SchemaProperty('deletedTimestamp', RealmPropertyType.int, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
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
  Stream<RealmObjectChanges<NoteItemContentRealm>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<NoteItemContentRealm>(this, keyPaths);

  @override
  NoteItemContentRealm freeze() =>
      RealmObjectBase.freezeObject<NoteItemContentRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'text': text.toEJson(),
    };
  }

  static EJsonValue _toEJson(NoteItemContentRealm value) => value.toEJson();
  static NoteItemContentRealm _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'text': EJsonValue text,
      } =>
        NoteItemContentRealm(
          fromEJson(text),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(NoteItemContentRealm._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.embeddedObject, NoteItemContentRealm,
        'NoteItemContentRealm', [
      SchemaProperty('text', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

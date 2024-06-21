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
    int updated,
    String body, {
    bool? isDeleted,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'updated', updated);
    RealmObjectBase.set(this, 'body', body);
    RealmObjectBase.set(this, 'isDeleted', isDeleted);
  }

  NoteItemRealm._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get updated => RealmObjectBase.get<int>(this, 'updated') as int;
  @override
  set updated(int value) => RealmObjectBase.set(this, 'updated', value);

  @override
  String get body => RealmObjectBase.get<String>(this, 'body') as String;
  @override
  set body(String value) => RealmObjectBase.set(this, 'body', value);

  @override
  bool? get isDeleted => RealmObjectBase.get<bool>(this, 'isDeleted') as bool?;
  @override
  set isDeleted(bool? value) => RealmObjectBase.set(this, 'isDeleted', value);

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
      'updated': updated.toEJson(),
      'body': body.toEJson(),
      'isDeleted': isDeleted.toEJson(),
    };
  }

  static EJsonValue _toEJson(NoteItemRealm value) => value.toEJson();
  static NoteItemRealm _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'updated': EJsonValue updated,
        'body': EJsonValue body,
        'isDeleted': EJsonValue isDeleted,
      } =>
        NoteItemRealm(
          fromEJson(id),
          fromEJson(updated),
          fromEJson(body),
          isDeleted: fromEJson(isDeleted),
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
      SchemaProperty('updated', RealmPropertyType.int),
      SchemaProperty('body', RealmPropertyType.string),
      SchemaProperty('isDeleted', RealmPropertyType.bool, optional: true),
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

// Mocks generated by Mockito 5.4.4 from annotations
// in pwd/test/settings/drop_remote_storage_configuration_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:typed_data' as _i12;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:pwd/common/domain/base_pin.dart' as _i9;
import 'package:pwd/common/domain/model/remote_storage_configuration.dart'
    as _i3;
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart'
    as _i2;
import 'package:pwd/common/domain/usecases/pin_usecase.dart' as _i8;
import 'package:pwd/common/domain/usecases/should_create_remote_storage_file_usecase.dart'
    as _i10;
import 'package:pwd/notes/domain/local_repository.dart' as _i11;
import 'package:pwd/notes/domain/model/note_item.dart' as _i7;
import 'package:pwd/notes/domain/notes_repository.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [RemoteStorageConfigurationProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockRemoteStorageConfigurationProvider extends _i1.Mock
    implements _i2.RemoteStorageConfigurationProvider {
  @override
  _i3.RemoteStorageConfigurations get currentConfiguration =>
      (super.noSuchMethod(
        Invocation.getter(#currentConfiguration),
        returnValue: _i4.dummyValue<_i3.RemoteStorageConfigurations>(
          this,
          Invocation.getter(#currentConfiguration),
        ),
        returnValueForMissingStub:
            _i4.dummyValue<_i3.RemoteStorageConfigurations>(
          this,
          Invocation.getter(#currentConfiguration),
        ),
      ) as _i3.RemoteStorageConfigurations);

  @override
  _i5.Stream<_i3.RemoteStorageConfigurations> get configuration =>
      (super.noSuchMethod(
        Invocation.getter(#configuration),
        returnValue: _i5.Stream<_i3.RemoteStorageConfigurations>.empty(),
        returnValueForMissingStub:
            _i5.Stream<_i3.RemoteStorageConfigurations>.empty(),
      ) as _i5.Stream<_i3.RemoteStorageConfigurations>);

  @override
  _i5.Future<void> setConfigurations(
          _i3.RemoteStorageConfigurations? configuration) =>
      (super.noSuchMethod(
        Invocation.method(
          #setConfiguration,
          [configuration],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> dropConfiguration() => (super.noSuchMethod(
        Invocation.method(
          #dropConfiguration,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [NotesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockNotesRepository extends _i1.Mock implements _i6.NotesRepository {
  @override
  _i5.Future<int> updateNote(_i7.NoteItem? noteItem) => (super.noSuchMethod(
        Invocation.method(
          #updateNote,
          [noteItem],
        ),
        returnValue: _i5.Future<int>.value(0),
        returnValueForMissingStub: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

  @override
  _i5.Future<int> delete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
        ),
        returnValue: _i5.Future<int>.value(0),
        returnValueForMissingStub: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

  @override
  _i5.Future<_i7.NoteItem?> readNote(String? id) => (super.noSuchMethod(
        Invocation.method(
          #readNote,
          [id],
        ),
        returnValue: _i5.Future<_i7.NoteItem?>.value(),
        returnValueForMissingStub: _i5.Future<_i7.NoteItem?>.value(),
      ) as _i5.Future<_i7.NoteItem?>);

  @override
  _i5.Future<List<_i7.NoteItem>> readNotes() => (super.noSuchMethod(
        Invocation.method(
          #readNotes,
          [],
        ),
        returnValue: _i5.Future<List<_i7.NoteItem>>.value(<_i7.NoteItem>[]),
        returnValueForMissingStub:
            _i5.Future<List<_i7.NoteItem>>.value(<_i7.NoteItem>[]),
      ) as _i5.Future<List<_i7.NoteItem>>);

  @override
  _i5.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> updateDb({required String? rawSql}) => (super.noSuchMethod(
        Invocation.method(
          #updateDb,
          [],
          {#rawSql: rawSql},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<int> lastRecordTimestamp() => (super.noSuchMethod(
        Invocation.method(
          #lastRecordTimestamp,
          [],
        ),
        returnValue: _i5.Future<int>.value(0),
        returnValueForMissingStub: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

  @override
  _i5.Future<String> exportNotes() => (super.noSuchMethod(
        Invocation.method(
          #exportNotes,
          [],
        ),
        returnValue: _i5.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #exportNotes,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #exportNotes,
            [],
          ),
        )),
      ) as _i5.Future<String>);

  @override
  _i5.Future<int> importNotes({required Map<String, dynamic>? jsonMap}) =>
      (super.noSuchMethod(
        Invocation.method(
          #importNotes,
          [],
          {#jsonMap: jsonMap},
        ),
        returnValue: _i5.Future<int>.value(0),
        returnValueForMissingStub: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

  @override
  _i5.Future<void> dropDb() => (super.noSuchMethod(
        Invocation.method(
          #dropDb,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  String createEmptyDbContent(int? timestamp) => (super.noSuchMethod(
        Invocation.method(
          #createEmptyDbContent,
          [timestamp],
        ),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.method(
            #createEmptyDbContent,
            [timestamp],
          ),
        ),
        returnValueForMissingStub: _i4.dummyValue<String>(
          this,
          Invocation.method(
            #createEmptyDbContent,
            [timestamp],
          ),
        ),
      ) as String);
}

/// A class which mocks [PinUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockPinUsecase extends _i1.Mock implements _i8.PinUsecase {
  @override
  _i5.Stream<_i9.BasePin> get pinStream => (super.noSuchMethod(
        Invocation.getter(#pinStream),
        returnValue: _i5.Stream<_i9.BasePin>.empty(),
        returnValueForMissingStub: _i5.Stream<_i9.BasePin>.empty(),
      ) as _i5.Stream<_i9.BasePin>);

  @override
  bool get isValidPin => (super.noSuchMethod(
        Invocation.getter(#isValidPin),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i5.Future<void> dropPin() => (super.noSuchMethod(
        Invocation.method(
          #dropPin,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i9.BasePin getPin() => (super.noSuchMethod(
        Invocation.method(
          #getPin,
          [],
        ),
        returnValue: _i4.dummyValue<_i9.BasePin>(
          this,
          Invocation.method(
            #getPin,
            [],
          ),
        ),
        returnValueForMissingStub: _i4.dummyValue<_i9.BasePin>(
          this,
          Invocation.method(
            #getPin,
            [],
          ),
        ),
      ) as _i9.BasePin);

  @override
  _i9.Pin getPinOrThrow() => (super.noSuchMethod(
        Invocation.method(
          #getPinOrThrow,
          [],
        ),
        returnValue: _i4.dummyValue<_i9.Pin>(
          this,
          Invocation.method(
            #getPinOrThrow,
            [],
          ),
        ),
        returnValueForMissingStub: _i4.dummyValue<_i9.Pin>(
          this,
          Invocation.method(
            #getPinOrThrow,
            [],
          ),
        ),
      ) as _i9.Pin);

  @override
  _i5.Future<void> setPin(_i9.Pin? pin) => (super.noSuchMethod(
        Invocation.method(
          #setPin,
          [pin],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [ShouldCreateRemoteStorageFileUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockShouldCreateRemoteStorageFileUsecase extends _i1.Mock
    implements _i10.ShouldCreateRemoteStorageFileUsecase {
  @override
  bool get flag => (super.noSuchMethod(
        Invocation.getter(#flag),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  void setFlag(bool? flag) => super.noSuchMethod(
        Invocation.method(
          #setFlag,
          [flag],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dropFlag() => super.noSuchMethod(
        Invocation.method(
          #dropFlag,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [LocalRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalRepository extends _i1.Mock implements _i11.LocalRepository {
  @override
  _i5.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> delete(
    String? id, {
    required List<int>? key,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [id],
          {#key: key},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> deleteAll({required List<int>? key}) => (super.noSuchMethod(
        Invocation.method(
          #deleteAll,
          [],
          {#key: key},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> saveNotes({
    required List<int>? key,
    required List<_i7.NoteItem>? notes,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveNotes,
          [],
          {
            #key: key,
            #notes: notes,
          },
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i7.NoteItem?> readNote(
    String? id, {
    required List<int>? key,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #readNote,
          [id],
          {#key: key},
        ),
        returnValue: _i5.Future<_i7.NoteItem?>.value(),
        returnValueForMissingStub: _i5.Future<_i7.NoteItem?>.value(),
      ) as _i5.Future<_i7.NoteItem?>);

  @override
  _i5.Future<List<_i7.NoteItem>> readNotes({required List<int>? key}) =>
      (super.noSuchMethod(
        Invocation.method(
          #readNotes,
          [],
          {#key: key},
        ),
        returnValue: _i5.Future<List<_i7.NoteItem>>.value(<_i7.NoteItem>[]),
        returnValueForMissingStub:
            _i5.Future<List<_i7.NoteItem>>.value(<_i7.NoteItem>[]),
      ) as _i5.Future<List<_i7.NoteItem>>);

  @override
  _i5.Future<void> updateNote(
    _i7.NoteItem? noteItem, {
    required List<int>? key,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateNote,
          [noteItem],
          {#key: key},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<int> getTimestamp({required List<int>? key}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTimestamp,
          [],
          {#key: key},
        ),
        returnValue: _i5.Future<int>.value(0),
        returnValueForMissingStub: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

  @override
  _i5.Future<String> getPath({required List<int>? key}) => (super.noSuchMethod(
        Invocation.method(
          #getPath,
          [],
          {#key: key},
        ),
        returnValue: _i5.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #getPath,
            [],
            {#key: key},
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #getPath,
            [],
            {#key: key},
          ),
        )),
      ) as _i5.Future<String>);

  @override
  _i5.Future<void> migrateWithDatabasePath({
    required _i12.Uint8List? bytes,
    required List<int>? key,
    required Set<String>? deleted,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #migrateWithDatabasePath,
          [],
          {
            #bytes: bytes,
            #key: key,
            #deleted: deleted,
          },
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}
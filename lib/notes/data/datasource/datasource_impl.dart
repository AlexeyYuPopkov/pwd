import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:pwd/notes/data/model/note_data.dart';
import 'package:pwd/notes/data/model/note_item_data.dart';
import 'package:rxdart/rxdart.dart';

import 'datasource.dart';

const _fileName = 'note_data';

class DatasourceImpl implements Datasource {
  @override
  Stream<NoteData> get noteStream {
    return _noteStream; //.shareReplay(maxSize: 1);
  }

  late final PublishSubject<NoteData> _noteStream = PublishSubject<NoteData>(
    // NoteData.empty(),
    onListen: () => readNote(),
  );

  @override
  Future<void> updateNote(NoteData note) async {
    final file = await _file;

    final json = note.toJson();

    await file.writeAsString(
      jsonEncode(json),
    );

    readNote();
  }

  @override
  Future<void> readNote() async {
    final file = await _file;

    final jsonString = await file.readAsString();

    if (jsonString.isEmpty) {
      return;
    }

    final json = jsonDecode(jsonString);
    final note = NoteData.fromJson(json);

    _noteStream.add(note);
  }

  Future<File> get _file async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = '${appDocDir.path}/$_fileName';

    final result = File(path);

    if (!result.existsSync()) {
      result.createSync();
    }

    return File(path);
  }

  @override
  NoteItemData newNoteItem() => NoteItemData.empty();
}

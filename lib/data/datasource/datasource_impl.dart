import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:pwd/data/model/note_item_data.dart';
import 'package:rxdart/subjects.dart';
import 'package:pwd/data/datasource/datasource.dart';
import 'package:pwd/data/model/note_data.dart';

const _fileName = 'note_data';

class DatasourceImpl implements Datasource {
  @override
  final BehaviorSubject<NoteData> noteStream = BehaviorSubject<NoteData>.seeded(
    NoteData.empty(),
  );

  @override
  Future<void> updateNote(NoteData note) async {
    final file = await _file;

    final json = note.toJson();

    await file.writeAsString(
      jsonEncode(json),
    );

    noteStream.sink.add(note);
  }

  @override
  Future<void> readNote() async {
    final file = await _file;

    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);
    final note = NoteData.fromJson(json);

    noteStream.sink.add(note);
  }

  Future<File> get _file async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = '${appDocDir.path}/$_fileName';
    return File(path);
  }

  @override
  NoteItemData newNoteItem() => NoteItemData.empty();
}

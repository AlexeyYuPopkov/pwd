import 'package:pwd/domain/model/note_item.dart';

abstract class Note {
  String get id;
  List<NoteItem> get notes;
}


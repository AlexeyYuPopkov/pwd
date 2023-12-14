import 'package:pwd/common/data_tools/mapper.dart';
import 'package:pwd/notes/data/model/note_item_data.dart';

import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:uuid/uuid.dart';

class DbNoteMapper implements Mapper<NoteItemData, NoteItem> {
  @override
  NoteItemData toData(NoteItem data) {
    return NoteItemData(
      id: data.id.isEmpty ? const Uuid().v4() : data.id,
      title: data.title,
      description: data.description,
      content: data.content,
      timestamp: data.timestamp,
    );
  }

  @override
  NoteItem toDomain(NoteItemData data) => data;

  @override
  NoteItemData dataFromMap(Map<String, dynamic> data) => NoteItemData.fromJson(
        data,
      );
}

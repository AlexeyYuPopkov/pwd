import 'package:pwd/common/data_tools/mapper.dart';
import 'package:pwd/notes/data/model/note_item_data.dart';

import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/note_item_content.dart';
import 'package:uuid/uuid.dart';

class DbNoteMapper implements Mapper<NoteItemData, NoteItem> {
  @override
  NoteItemData toData(NoteItem data) {
    return NoteItemData(
      id: data.id.isEmpty ? const Uuid().v4() : data.id,
      title: data.title,
      description: data.description,
      content: data.content.str,
      timestamp: data.timestamp,
    );
  }

  @override
  NoteItem toDomain(NoteItemData src) => NoteItem(
        id: src.id,
        title: src.title,
        description: src.description,
        content: NoteStringContent(str: src.content),
        timestamp: src.timestamp,
        isDecrypted: false,
      );

  @override
  NoteItemData dataFromMap(Map<String, dynamic> data) => NoteItemData.fromJson(
        data,
      );
}

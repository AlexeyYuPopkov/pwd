import 'package:pwd/common/data_tools/mapper.dart';
import 'package:pwd/notes/data/model/note_item_data.dart';

import 'package:pwd/notes/domain/model/note_item.dart';

const _millisecondsPerSecond = 1000;

class DbNoteMapper implements Mapper<Map<String, dynamic>, NoteItem> {
  @override
  Map<String, dynamic> toData(NoteItem data) {
    final date = data.date ?? DateTime.now();
    final timestamp = date.millisecondsSinceEpoch ~/ _millisecondsPerSecond;

    return {
      'title': data.title,
      'description': data.description,
      'content': data.content,
      'timestamp': timestamp,
    };
  }

  @override
  NoteItem toDomain(Map<String, dynamic> data) {
    final id = data['id'];

    if (id is! int) {
      throw UnimplementedError();
    }

    final title = data['title'];

    if (title is! String) {
      throw UnimplementedError();
    }

    final description = data['description'];

    if (description is! String) {
      throw UnimplementedError();
    }

    final content = data['content'];

    if (content is! String) {
      throw UnimplementedError();
    }

    final date = data['timestamp'];

    if (date is! int) {
      throw UnimplementedError();
    }

    return NoteItemData(
      id: id.toString(),
      title: title,
      description: description,
      content: content,
      date: DateTime.fromMillisecondsSinceEpoch(date * _millisecondsPerSecond),
    );
  }
}

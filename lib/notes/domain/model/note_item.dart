import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'note_item_content.dart';

sealed class BaseNoteItem extends Equatable {
  const BaseNoteItem();

  String get id;
  String get title;
  String get description;
  NoteContentInterface get content;
  int get updated;
  int? get deletedTimestamp;

  factory BaseNoteItem.newItem() => UpdatedNoteItem.empty();

  factory BaseNoteItem.updatedItem({
    required String id,
    required String title,
    required String description,
    required NoteContentInterface content,
  }) = UpdatedNoteItem;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        updated,
        deletedTimestamp,
      ];
}

class NoteItem extends BaseNoteItem {
  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final NoteContentInterface content;
  @override
  final int updated;
  @override
  final int? deletedTimestamp;

  const NoteItem({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.updated,
    required this.deletedTimestamp,
  });

  BaseNoteItem copyToUpdatedWith({
    String? title,
    String? description,
    NoteContentInterface? content,
  }) {
    return BaseNoteItem.updatedItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
    );
  }

  NoteItem copyWith({
    String? title,
    String? description,
    NoteContentInterface? content,
    int? updated,
  }) {
    return NoteItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      updated: updated ?? this.updated,
      deletedTimestamp: deletedTimestamp,
    );
  }
}

final class UpdatedNoteItem extends BaseNoteItem {
  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final NoteContentInterface content;
  @override
  final int updated;
  @override
  final int? deletedTimestamp;

  const UpdatedNoteItem._({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.updated,
    required this.deletedTimestamp,
  });

  factory UpdatedNoteItem({
    required String id,
    required String title,
    required String description,
    required NoteContentInterface content,
  }) {
    return UpdatedNoteItem._(
      id: id.isEmpty ? const Uuid().v4() : id,
      title: title,
      description: description,
      content: content,
      updated: TimestampHelper.timestampForDate(DateTime.now()),
      deletedTimestamp: null,
    );
  }

  factory UpdatedNoteItem.empty() {
    return const UpdatedNoteItem._(
      id: '',
      title: '',
      description: '',
      content: NoteStringContent(str: ''),
      updated: 0,
      deletedTimestamp: null,
    );
  }
}

mixin TimestampHelper {
  static int timestampForDate(DateTime date) {
    return (date.millisecondsSinceEpoch / 1000).round();
  }

  static int timestampForDateAppending(DateTime date, Duration duration) {
    return timestampForDate(date.add(duration));
  }
}

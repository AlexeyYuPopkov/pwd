import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'note_item_content.dart';

sealed class BaseNoteItem extends Equatable {
  const BaseNoteItem();

  String get id;
  String get title => content.items.elementAtOrNull(0)?.text ?? '';
  String get description => content.items.elementAtOrNull(1)?.text ?? '';
  NoteContent get content;
  int get updated;

  factory BaseNoteItem.newItem() = NewNoteItem;

  factory BaseNoteItem.updatedItem({
    required String id,
    required NoteContent content,
  }) = UpdatedNoteItem;

  @override
  List<Object?> get props => [
        id,
        content,
        updated,
      ];

  BaseNoteItem copyWith({NoteContent? content});
}

final class NoteItem extends BaseNoteItem {
  @override
  final String id;
  @override
  final NoteContent content;
  @override
  final int updated;

  const NoteItem({
    required this.id,
    required this.content,
    required this.updated,
  });

  BaseNoteItem copyToUpdatedWith({
    String? title,
    String? description,
    NoteContent? content,
  }) {
    return BaseNoteItem.updatedItem(
      id: id,
      content: content ?? this.content,
    );
  }

  @override
  UpdatedNoteItem copyWith({NoteContent? content}) {
    return BaseNoteItem.updatedItem(
      id: id,
      content: content ?? this.content,
    ) as UpdatedNoteItem;
  }
}

final class UpdatedNoteItem extends BaseNoteItem {
  @override
  final String id;
  @override
  final NoteContent content;
  @override
  final int updated;

  const UpdatedNoteItem._({
    required this.id,
    required this.content,
    required this.updated,
  });

  factory UpdatedNoteItem({
    required String id,
    required NoteContent content,
  }) {
    return UpdatedNoteItem._(
      id: id.isEmpty ? const Uuid().v4() : id,
      content: content,
      updated: TimestampHelper.timestampForDate(DateTime.now()),
    );
  }

  @override
  UpdatedNoteItem copyWith({NoteContent? content}) {
    return UpdatedNoteItem._(
      id: id,
      content: content ?? this.content,
      updated: updated,
    );
  }
}

final class NewNoteItem extends BaseNoteItem {
  @override
  final String id;
  @override
  final NoteContent content;
  @override
  final int updated;

  const NewNoteItem._({
    required this.id,
    required this.content,
    required this.updated,
  });

  factory NewNoteItem() {
    return NewNoteItem._(
      id: const Uuid().v4(),
      content: const NoteContent(items: []),
      updated: TimestampHelper.timestampForDate(DateTime.now()),
    );
  }

  @override
  NewNoteItem copyWith({NoteContent? content}) {
    return NewNoteItem._(
      id: id,
      content: content ?? this.content,
      updated: updated,
    );
  }
}

mixin TimestampHelper {
  static int timestampForDate(DateTime date) {
    return (date.millisecondsSinceEpoch / 1000).round();
  }

  // static int timestampForDateAppending(DateTime date, Duration duration) {
  //   return timestampForDate(date.add(duration));
  // }
}

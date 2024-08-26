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

  @override
  NoteItem copyWith({NoteContent? content}) {
    return NoteItem(
      id: id,
      content: content ?? this.content,
      updated: TimestampHelper.timestampForDate(DateTime.now()),
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

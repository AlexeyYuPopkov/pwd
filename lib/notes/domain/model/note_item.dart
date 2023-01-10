import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

abstract class NoteItem extends Equatable {
  final String id;
  final NoteItemValue title;
  final NoteItemValue description;
  final NoteItemValue content;
  final DateTime? date;

  const NoteItem({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        date,
      ];

  factory NoteItem.newItem() = NewNoteItem;

  const factory NoteItem.updatedItem({
    required String id,
    required NoteItemValue title,
    required NoteItemValue description,
    required NoteItemValue content,
    required DateTime? date,
  }) = UpdatedNoteItem;

  NoteItem copyWith({
    String? title,
    String? description,
    String? content,
    DateTime? date,
  }) =>
      NoteItem.updatedItem(
        id: id,
        title: NoteItemValue(
          style: this.title.style,
          text: description ?? this.title.text,
        ),
        description: NoteItemValue(
          style: this.description.style,
          text: description ?? this.description.text,
        ),
        content: NoteItemValue(
          style: this.content.style,
          text: description ?? this.content.text,
        ),
        date: date ?? this.date,
      );
}

class NoteItemValue {
  final String text;
  final NoteItemStyle style;

  const NoteItemValue({
    required this.text,
    required this.style,
  });
}

class NewNoteItemValue extends NoteItemValue {
  const NewNoteItemValue()
      : super(
          style: NoteItemStyle.other,
          text: '',
        );
}

class NewNoteItem extends NoteItem {
  NewNoteItem()
      : super(
          id: const Uuid().v1(),
          title: const NewNoteItemValue(),
          description: const NewNoteItemValue(),
          content: const NewNoteItemValue(),
          date: DateTime.now(),
        );
}

class UpdatedNoteItem extends NoteItem {
  const UpdatedNoteItem({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.date,
  });
}

enum NoteItemStyle {
  @JsonValue('header')
  header,
  @JsonValue('body')
  body,
  @JsonValue('other')
  other,
}

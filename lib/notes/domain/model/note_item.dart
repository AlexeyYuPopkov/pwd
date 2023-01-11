import 'package:equatable/equatable.dart';

abstract class NoteItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String content;
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
    required String title,
    required String description,
    required String content,
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
        title: title ?? this.title,
        description: description ?? this.description,
        content: content ?? this.content,
        date: date ?? this.date,
      );
}

class NewNoteItem extends NoteItem {
  NewNoteItem()
      : super(
          id: '',
          title: '',
          description: '',
          content: '',
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

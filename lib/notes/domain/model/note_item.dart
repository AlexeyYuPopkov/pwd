import 'package:equatable/equatable.dart';

abstract class NoteItem extends Equatable {
  final int? id;
  final String title;
  final String description;
  final String content;
  final int timestamp;

  const NoteItem({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        timestamp,
      ];

  factory NoteItem.newItem() = NewNoteItem;

  const factory NoteItem.updatedItem({
    required int? id,
    required String title,
    required String description,
    required String content,
    required int timestamp,
  }) = UpdatedNoteItem;

  NoteItem copyWith({
    String? title,
    String? description,
    String? content,
    int? timestamp,
  }) =>
      NoteItem.updatedItem(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
      );
}

class NewNoteItem extends NoteItem {
  NewNoteItem()
      : super(
          id: null,
          title: '',
          description: '',
          content: '',
          timestamp: DateTime.now().timestamp,
        );
}

class UpdatedNoteItem extends NoteItem {
  const UpdatedNoteItem({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.timestamp,
  });
}

extension on DateTime {
  int get timestamp => millisecondsSinceEpoch * 1000;
}

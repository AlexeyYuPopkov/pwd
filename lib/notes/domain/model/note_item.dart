import 'package:equatable/equatable.dart';

import 'note_item_content.dart';

class NoteItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final NoteContentInterface content;
  final int timestamp;
  final bool isDecrypted;

  const NoteItem({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.timestamp,
    required this.isDecrypted,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        timestamp,
        isDecrypted,
      ];

  factory NoteItem.newItem() = NewNoteItem;

  factory NoteItem.updatedItem({
    required String id,
    required String title,
    required String description,
    required NoteContentInterface content,
  }) = UpdatedNoteItem;

  factory NoteItem.decrypted({
    required String id,
    required String title,
    required String description,
    required NoteContentInterface content,
    required int timestamp,
  }) =>
      NoteItem(
        id: id,
        title: title,
        description: description,
        content: content,
        timestamp: timestamp,
        isDecrypted: true,
      );

  NoteItem copyToUpdatedWith({
    String? title,
    String? description,
    NoteContentInterface? content,
  }) {
    return NoteItem.updatedItem(
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
    int? timestamp,
    bool? isDecrypted,
  }) {
    return NoteItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isDecrypted: isDecrypted ?? this.isDecrypted,
    );
  }
}

final class NewNoteItem extends NoteItem {
  NewNoteItem()
      : super(
          id: '',
          title: '',
          description: '',
          content: const NoteStringContent(str: ''),
          timestamp: DateTime.now().timestamp,
          isDecrypted: true,
        );
}

final class UpdatedNoteItem extends NoteItem {
  UpdatedNoteItem({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
  }) : super(
          timestamp: DateTime.now().timestamp,
          isDecrypted: true,
        );
}

extension on DateTime {
  int get timestamp => millisecondsSinceEpoch * 1000;
}

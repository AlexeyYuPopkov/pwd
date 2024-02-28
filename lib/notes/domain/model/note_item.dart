import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'note_item_content.dart';

sealed class BaseNoteItem extends Equatable {
  const BaseNoteItem();

  String get id;
  String get title;
  String get description;
  NoteContentInterface get content;
  int get timestamp;
  bool get isDeleted;

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
        timestamp,
        isDeleted,
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
  final int timestamp;
  @override
  final bool isDeleted;

  const NoteItem({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.timestamp,
    required this.isDeleted,
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
    int? timestamp,
    bool? isDeleted,
  }) {
    return NoteItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isDeleted: isDeleted ?? this.isDeleted,
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
  final int timestamp;
  @override
  final bool isDeleted;

  const UpdatedNoteItem._({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.timestamp,
    required this.isDeleted,
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
      timestamp: DateTime.now().timestamp,
      isDeleted: false,
    );
  }

  factory UpdatedNoteItem.empty() {
    return const UpdatedNoteItem._(
      id: '',
      title: '',
      description: '',
      content: NoteStringContent(str: ''),
      timestamp: 0,
      isDeleted: false,
    );
  }
}

extension on DateTime {
  int get timestamp => millisecondsSinceEpoch * 1000;
}

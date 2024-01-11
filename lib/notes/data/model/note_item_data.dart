import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'package:pwd/notes/domain/model/note_item.dart';

part 'note_item_data.g.dart';

@immutable
@JsonSerializable()
class NoteItemData implements NoteItem {
  @override
  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @override
  @JsonKey(name: 'title', defaultValue: '')
  final String title;

  @override
  @JsonKey(name: 'description', defaultValue: '')
  final String description;

  @override
  @JsonKey(name: 'content', defaultValue: '')
  final String content;

  @override
  @JsonKey(name: 'timestamp')
  final int timestamp;

  @override
  final isDecrypted = false;

  const NoteItemData({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.timestamp,
  });

  factory NoteItemData.fromJson(Map<String, dynamic> json) => _fromJson(json);

  Map<String, dynamic> toJson() => _$NoteItemDataToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        timestamp,
      ];

  @override
  bool? get stringify => false;

  @override
  NoteItem copyToUpdatedWith({
    String? title,
    String? description,
    String? content,
    int? timestamp,
  }) =>
      NoteItemData(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
      );

  @override
  NoteItemData copyWith({
    String? title,
    String? description,
    String? content,
    int? timestamp,
    bool? isDecrypted,
  }) {
    return NoteItemData(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

NoteItemData _fromJson(Map<String, dynamic> json) => NoteItemData(
      // id: json['id'] as String? ?? '',
      id: json['id'] is String
          ? json['id'] as String
          : json['id'] is int
              ? json['id'].toString()
              : '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      content: json['content'] as String? ?? '',
      timestamp: json['timestamp'] as int,
    );

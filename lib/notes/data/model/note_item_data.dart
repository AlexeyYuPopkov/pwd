import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'note_item_data.g.dart';

@immutable
@JsonSerializable()
class NoteItemData {
  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @JsonKey(name: 'title', defaultValue: '')
  final String title;

  @JsonKey(name: 'description', defaultValue: '')
  final String description;

  @JsonKey(name: 'content', defaultValue: '')
  final String content;

  @JsonKey(name: 'timestamp')
  final int timestamp;

  const NoteItemData({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.timestamp,
  });

  factory NoteItemData.fromJson(Map<String, dynamic> json) => _fromJson(json);

  Map<String, dynamic> toJson() => _$NoteItemDataToJson(this);
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

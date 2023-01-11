import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';


import 'package:pwd/notes/domain/model/note_item.dart';

part 'note_item_data.g.dart';

@immutable
@JsonSerializable()
class NoteItemData implements NoteItem {
  @override
  @JsonKey(name: 'id')
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
  @JsonKey(name: 'date')
  final DateTime? date;

  const NoteItemData({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    this.date,
  });

  factory NoteItemData.fromJson(Map<String, dynamic> json) =>
      _$NoteItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$NoteItemDataToJson(this);

  factory NoteItemData.empty() => const NoteItemData(
        id: '',
        title: '',
        description: '',
        content: '',
      );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        date,
      ];

  @override
  bool? get stringify => false;

  @override
  NoteItem copyWith({
    String? title,
    String? description,
    String? content,
    DateTime? date,
  }) =>
      NoteItemData(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        content: content ?? this.content,
        date: date ?? this.date,
      );
}

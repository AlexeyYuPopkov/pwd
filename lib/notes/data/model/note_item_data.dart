import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'package:pwd/notes/domain/model/note_item.dart';

part 'note_item_data.g.dart';

@immutable
@JsonSerializable()
class NoteItemData implements NoteItem {
  @override
  @JsonKey(name: 'id')
  final String id;

  @override
  @JsonKey(name: 'title')
  final NoteItemValueData title;

  @override
  @JsonKey(name: 'description')
  final NoteItemValueData description;

  @override
  @JsonKey(name: 'content')
  final NoteItemValueData content;

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

  factory NoteItemData.empty() => NoteItemData(
        id: const Uuid().v1().toString(),
        title: NoteItemValueData.empty(),
        description: NoteItemValueData.empty(),
        content: NoteItemValueData.empty(),
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
        title: NoteItemValueData(
          style: this.title.style,
          text: title ?? this.title.text,
        ),
        description: NoteItemValueData(
          style: this.description.style,
          text: description ?? this.description.text,
        ),
        content: NoteItemValueData(
          style: this.content.style,
          text: content ?? this.content.text,
        ),
        date: date ?? this.date,
      );

// @override
//   NoteItemData copyWith({
//     String? id,
//     NoteItemValueData? title,
//     NoteItemValueData? description,
//     NoteItemValueData? content,
//     DateTime? date,
//   }) {
//     return NoteItemData(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       content: content ?? this.content,
//       date: date ?? this.date,
//     );
//   }
}

@immutable
@JsonSerializable()
class NoteItemValueData implements NoteItemValue {
  @override
  @JsonKey(name: 'text')
  final String text;
  @override
  @JsonKey(name: 'style')
  final NoteItemStyle style;

  const NoteItemValueData({
    required this.text,
    required this.style,
  });

  factory NoteItemValueData.fromJson(Map<String, dynamic> json) =>
      _$NoteItemValueDataFromJson(json);

  Map<String, dynamic> toJson() => _$NoteItemValueDataToJson(this);

  factory NoteItemValueData.empty() => const NoteItemValueData(
        style: NoteItemStyle.body,
        text: '',
      );
}

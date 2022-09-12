import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'package:pwd/domain/model/note_item.dart';
import 'package:uuid/uuid.dart';

part 'note_item_data.g.dart';

@immutable
@JsonSerializable()
class NoteItemData implements NoteItem {
  @override
  @JsonKey(name: 'title')
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

  const NoteItemData({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
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

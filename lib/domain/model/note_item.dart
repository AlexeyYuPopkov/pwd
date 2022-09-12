import 'package:json_annotation/json_annotation.dart';

abstract class NoteItem {
  final String id;
  final NoteItemValue title;
  final NoteItemValue description;
  final NoteItemValue content;

  const NoteItem({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
  });
}

class NoteItemValue {
  final String text;
  final NoteItemStyle style;

  const NoteItemValue({
    required this.text,
    required this.style,
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

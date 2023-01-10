import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pwd/notes/data/model/note_item_data.dart';
import 'package:pwd/notes/domain/model/note.dart';
import 'package:uuid/uuid.dart';

part 'note_data.g.dart';

@immutable
@JsonSerializable()
class NoteData implements Note {
  @override
  @JsonKey(name: 'id')
  final String id;

  @override
  @JsonKey(name: 'notes')
  final List<NoteItemData> notes;

  const NoteData({
    required this.id,
    required this.notes,
  });

  factory NoteData.empty() => NoteData(
        id: const Uuid().v1().toString(),
        notes: const [],
      );

  factory NoteData.fromJson(Map<String, dynamic> json) =>
      _$NoteDataFromJson(json);

  Map<String, dynamic> toJson() => _$NoteDataToJson(this);

  @override
  List<Object?> get props => [id, notes];

  @override
  bool? get stringify => false;
}

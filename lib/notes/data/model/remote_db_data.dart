import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:pwd/notes/data/model/note_item_data.dart';

part 'remote_db_data.g.dart';

@immutable
@JsonSerializable()
class RemoteDbData {
  @JsonKey(name: 'notes', defaultValue: [])
  final List<NoteItemData> notes;

  @JsonKey(name: 'date')
  final DateTime? date;

  const RemoteDbData({
    required this.notes,
    required this.date,
  });

  factory RemoteDbData.fromJson(Map<String, dynamic> json) =>
      _$RemoteDbDataFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDbDataToJson(this);
}

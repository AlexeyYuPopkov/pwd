import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:pwd/notes/data/model/note_item_data.dart';

part 'export_db_data.g.dart';

@immutable
@JsonSerializable()
class ExportDbData {
  @JsonKey(name: 'notes')
  final List<NoteItemData> notes;

  @JsonKey(name: 'date')
  final DateTime? date;

  const ExportDbData({
    required this.notes,
    required this.date,
  });

  factory ExportDbData.fromJson(Map<String, dynamic> json) =>
      _$ExportDbDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExportDbDataToJson(this);
}

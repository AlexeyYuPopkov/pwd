import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'clock_model_data.g.dart';

@immutable
@JsonSerializable()
class ClocksModelData {
  @JsonKey(name: 'content', defaultValue: [])
  final Iterable<ClockModelData> content;

  const ClocksModelData({
    required this.content,
  });

  factory ClocksModelData.fromJson(Map<String, dynamic> json) =>
      _$ClocksModelDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClocksModelDataToJson(this);
}

@immutable
@JsonSerializable()
class ClockModelData {
  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @JsonKey(name: 'label', defaultValue: '')
  final String label;

  @JsonKey(name: 'timezoneOffsetInSeconds', defaultValue: 0)
  final int timezoneOffsetInSeconds;

  const ClockModelData({
    required this.id,
    required this.label,
    required this.timezoneOffsetInSeconds,
  });

  factory ClockModelData.fromJson(Map<String, dynamic> json) =>
      _$ClockModelDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClockModelDataToJson(this);
}

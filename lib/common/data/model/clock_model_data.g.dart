// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_model_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClocksModelData _$ClocksModelDataFromJson(Map<String, dynamic> json) =>
    ClocksModelData(
      content: (json['content'] as List<dynamic>?)?.map(
              (e) => ClockModelData.fromJson(e as Map<String, dynamic>)) ??
          [],
    );

Map<String, dynamic> _$ClocksModelDataToJson(ClocksModelData instance) =>
    <String, dynamic>{
      'content': instance.content.toList(),
    };

ClockModelData _$ClockModelDataFromJson(Map<String, dynamic> json) =>
    ClockModelData(
      label: json['label'] as String? ?? '',
      timezoneOffsetInSeconds: json['timezoneOffsetInSeconds'] as int? ?? 0,
    );

Map<String, dynamic> _$ClockModelDataToJson(ClockModelData instance) =>
    <String, dynamic>{
      'label': instance.label,
      'timezoneOffsetInSeconds': instance.timezoneOffsetInSeconds,
    };

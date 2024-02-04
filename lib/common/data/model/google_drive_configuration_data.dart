import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'google_drive_configuration_data.g.dart';

@immutable
@JsonSerializable()
final class GoogleDriveConfigurationData {
  @JsonKey(name: 'filename', defaultValue: '')
  final String filename;

  const GoogleDriveConfigurationData({
    required this.filename,
  });

  @override
  String toString() {
    return 'type: $runtimeType\n'
        'filename: $filename';
  }

  factory GoogleDriveConfigurationData.fromJson(Map<String, dynamic> json) =>
      _$GoogleDriveConfigurationDataFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleDriveConfigurationDataToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'remote_storage_configurations_data.g.dart';

@immutable
@JsonSerializable()
final class RemoteStorageConfigurationsData {
  @JsonKey(name: 'configurations', defaultValue: null)
  final List<RemoteStorageConfigurationBox> configurations;

  const RemoteStorageConfigurationsData({
    required this.configurations,
  });

  factory RemoteStorageConfigurationsData.fromJson(Map<String, dynamic> json) =>
      _$RemoteStorageConfigurationsDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RemoteStorageConfigurationsDataToJson(this);
}

enum RemoteConfigurationTypeData {
  @JsonValue('git')
  git,
  @JsonValue('googleDrive')
  googleDrive,
  unknown,
}

@immutable
@JsonSerializable()
final class RemoteStorageConfigurationBox {
  @JsonKey(name: 'type', defaultValue: RemoteConfigurationTypeData.unknown)
  final RemoteConfigurationTypeData type;
  @JsonKey(name: 'value', defaultValue: null)
  final dynamic value;

  const RemoteStorageConfigurationBox({
    required this.type,
    required this.value,
  });

  factory RemoteStorageConfigurationBox.fromJson(Map<String, dynamic> json) =>
      _$RemoteStorageConfigurationBoxFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteStorageConfigurationBoxToJson(this);
}

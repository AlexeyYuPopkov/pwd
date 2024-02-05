import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:pwd/common/data/model/git_configuration_data.dart';
import 'package:pwd/common/data/model/google_drive_configuration_data.dart';

part 'remote_storage_configurations_data.g.dart';

@immutable
@JsonSerializable()
final class RemoteStorageConfigurationsData {
  @JsonKey(name: 'git', defaultValue: null)
  final GitConfigurationData? git;
  @JsonKey(name: 'googleDrive', defaultValue: null)
  final GoogleDriveConfigurationData? googleDrive;

  const RemoteStorageConfigurationsData({
    required this.git,
    required this.googleDrive,
  });

  @override
  String toString() {
    return 'git: ${git.toString()}\n'
        'googleDrive: ${googleDrive.toString()}\n';
  }

  factory RemoteStorageConfigurationsData.fromJson(Map<String, dynamic> json) =>
      _$RemoteStorageConfigurationsDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RemoteStorageConfigurationsDataToJson(this);
}

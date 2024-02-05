import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'git_configuration_data.g.dart';

@immutable
@JsonSerializable()
final class GitConfigurationData {
  @JsonKey(name: 'token', defaultValue: null)
  final String token;

  @JsonKey(name: 'repo', defaultValue: '')
  final String repo;

  @JsonKey(name: 'owner', defaultValue: '')
  final String owner;

  @JsonKey(name: 'branch', defaultValue: null)
  final String? branch;

  @JsonKey(name: 'fileName', defaultValue: '')
  final String fileName;

  const GitConfigurationData({
    required this.token,
    required this.repo,
    required this.owner,
    this.branch,
    required this.fileName,
  });

  @override
  bool operator ==(Object other) => other.hashCode == hashCode;

  @override
  int get hashCode => Object.hashAll({token, repo, owner, fileName});

  @override
  String toString() {
    return 'type: $runtimeType\n'
        'token: $token\n'
        'repo: $repo\n'
        'owner: $owner\n'
        'branch: $branch\n'
        'fileName: $fileName\n';
  }

  factory GitConfigurationData.fromJson(Map<String, dynamic> json) =>
      _$GitConfigurationDataFromJson(json);

  Map<String, dynamic> toJson() => _$GitConfigurationDataToJson(this);
}

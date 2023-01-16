import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'put_db_request_data.g.dart';

@immutable
@JsonSerializable()
class PutDbRequestData {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'content')
  final String content;
  @JsonKey(name: 'sha', defaultValue: null)
  final String? sha;
  @JsonKey(name: 'committer')
  final CommitterData committer;
  @JsonKey(name: 'branch', defaultValue: null)
  final String? branch;

  const PutDbRequestData({
    required this.message,
    required this.content,
    required this.sha,
    required this.committer,
    required this.branch,
  });

  factory PutDbRequestData.fromJson(Map<String, dynamic> json) =>
      _$PutDbRequestDataFromJson(json);

  Map<String, dynamic> toJson() => _$PutDbRequestDataToJson(this);
}

@immutable
@JsonSerializable()
class CommitterData {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;

  const CommitterData({
    required this.name,
    required this.email,
  });

  factory CommitterData.fromJson(Map<String, dynamic> json) =>
      _$CommitterDataFromJson(json);

  Map<String, dynamic> toJson() => _$CommitterDataToJson(this);
}

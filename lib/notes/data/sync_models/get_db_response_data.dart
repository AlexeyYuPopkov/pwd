import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';

part 'get_db_response_data.g.dart';

@immutable
@JsonSerializable()
class GetDbResponseData implements GetDbResponse {
  @override
  @JsonKey(name: 'sha', defaultValue: '')
  final String sha;
  @override
  @JsonKey(name: 'content', defaultValue: '')
  final String content;

  const GetDbResponseData({
    required this.sha,
    required this.content,
  });

  factory GetDbResponseData.fromJson(Map<String, dynamic> json) =>
      _$GetDbResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$GetDbResponseDataToJson(this);
}

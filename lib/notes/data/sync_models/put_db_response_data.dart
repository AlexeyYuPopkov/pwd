import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';

part 'put_db_response_data.g.dart';

@immutable
@JsonSerializable()
class PutDbResponseData implements PutDbResponse {
  @override
  @JsonKey(name: 'content')
  final PutDbResponseDataContent content;

  const PutDbResponseData({
    required this.content,
  });

  factory PutDbResponseData.fromJson(Map<String, dynamic> json) =>
      _$PutDbResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$PutDbResponseDataToJson(this);

  @override
  String get checksum => content.checksum;
}

@immutable
@JsonSerializable()
class PutDbResponseDataContent implements PutDbResponseContent {
  @override
  @JsonKey(name: 'sha')
  final String sha;

  const PutDbResponseDataContent({
    required this.sha,
  });

  factory PutDbResponseDataContent.fromJson(Map<String, dynamic> json) =>
      _$PutDbResponseDataContentFromJson(json);

  Map<String, dynamic> toJson() => _$PutDbResponseDataContentToJson(this);

  @override
  String get checksum => sha;
}

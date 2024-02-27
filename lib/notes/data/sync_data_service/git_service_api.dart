import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';
import 'package:pwd/notes/data/sync_models/get_db_response_data.dart';
import 'package:pwd/notes/data/sync_models/put_db_request_data.dart';
import 'package:pwd/notes/data/sync_models/put_db_response_data.dart';

part 'git_service_api.g.dart';

@RestApi(baseUrl: 'https://api.github.com/')
abstract class GitServiceApi {
  factory GitServiceApi(Dio dio, {String baseUrl}) = _GitServiceApi;

  @PUT('repos/{owner}/{repo}/contents/{filename}')
  @Headers({
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
  })
  Future<PutDbResponseData> putDb({
    @Path('owner') required String owner,
    @Path('repo') required String repo,
    @Path('filename') required String filename,
    @Body() required PutDbRequestData body,
    @Query('ref') String? branch,
    @Header('Authorization') required String token,
  });

  @GET('repos/{owner}/{repo}/contents/{filename}')
  @Headers({
    'Accept': 'application/json',
    'X-GitHub-Api-Version': '2022-11-28',
  })
  Future<GetDbResponseData> getDb({
    @Path('owner') required String owner,
    @Path('repo') required String repo,
    @Path('filename') required String filename,
    @Query('ref') String? branch,
    @Header('Authorization') required String token,
  });
}

class GetFileServiceApi {
  GetFileServiceApi(this._dio);

  final Dio _dio;

  Future<List<int>> getFile(String urlStr) async {
    final options = Options(
      method: 'GET',
      responseType: ResponseType.bytes,
    ).compose(_dio.options, '').copyWith(baseUrl: urlStr);

    final result = await _dio.fetch<List<dynamic>>(
      _setStreamType<List<int>>(options),
    );

    final value = result.data!.cast<int>();
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}

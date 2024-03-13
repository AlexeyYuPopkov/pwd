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

final class GetGitFileServiceApi {
  static const baseUrl = 'https://api.github.com/';
  final Dio _dio;

  GetGitFileServiceApi(
    this._dio,
  );

  Future<List<int>> getRawFile({
    required String owner,
    required String repo,
    required String filename,
    String? branch,
    required String token,
  }) async {
    final extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'ref': branch};
    queryParameters.removeWhere((k, v) => v == null);
    final headers = <String, dynamic>{
      r'Accept': 'application/vnd.github.raw+json',
      r'X-GitHub-Api-Version': '2022-11-28',
      r'Authorization': token,
    };
    headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? data = null;
    final result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<int>>(Options(
      method: 'GET',
      headers: headers,
      extra: extra,
    )
            .compose(
              _dio.options.copyWith(responseType: ResponseType.bytes),
              'repos/$owner/$repo/contents/$filename',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
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

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

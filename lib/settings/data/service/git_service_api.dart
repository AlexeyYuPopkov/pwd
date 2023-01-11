import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';
import 'package:pwd/settings/data/model/put_db_request_data.dart';

part 'git_service_api.g.dart';

@RestApi(baseUrl: 'https://api.github.com/')
abstract class GitServiceApi {
  factory GitServiceApi(Dio dio, {String baseUrl}) = _GitServiceApi;

  static const owner = 'AlexeyYuPopkov';
  static const repo = 'notes_storage';
  static const filename = 'note_data.db';
  static const path = 'repos/$owner/$repo/contents/$filename';

  @PUT(path)
  @Headers({
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
  })
  Future<dynamic> putDb({
    @Body() required PutDbRequestData body,
    @Header('Authorization') required String token,
  });
}


// @RestApi()
// class GitService {
//   static const owner = 'AlexeyYuPopkov';
//   static const repo = 'notes_storage';
//   static const filename = 'note_data.db';

//   static const baseUrl = 'https://github.com/';
//   static const path = '$repo/$owner/contents/$filename';

//   final Dio dio;
//   GitService({
//     required this.dio,
//   });

//   Future<Response<dynamic>> putDb(
//     String dbStr,
//     String token,
//   ) async {
//     return dio.fetch<dynamic>(
//       _setStreamType<dynamic>(
//         Options(
//           method: 'PUT',
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         )
//             .compose(
//               dio.options,
//               path,
//               data: dbStr,
//             )
//             .copyWith(
//               baseUrl: baseUrl,
//             ),
//       ),
//     );
//   }

//   RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
//     if (T != dynamic &&
//         !(requestOptions.responseType == ResponseType.bytes ||
//             requestOptions.responseType == ResponseType.stream)) {
//       if (T == String) {
//         requestOptions.responseType = ResponseType.plain;
//       } else {
//         requestOptions.responseType = ResponseType.json;
//       }
//     }
//     return requestOptions;
//   }
// }

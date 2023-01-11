import 'package:pwd/common/data_tools/mapper.dart';
import 'package:pwd/settings/data/model/put_db_request_data.dart';
import 'package:pwd/settings/domain/models/put_db_request.dart';

// class PutDbRequestMapper implements Mapper<PutDbRequestData, PutDbRequest> {
//   @override
//   PutDbRequestData toData(PutDbRequest data) => PutDbRequestData(
//         message: data.message,
//         content: data.content,
//         committer: CommitterData(
//           name: data.committer.name,
//           email: data.committer.email,
//         ),
//       );

//   @override
//   PutDbRequest toDomain(PutDbRequestData data) => PutDbRequest(
//         message: data.message,
//         content: data.content,
//         committer: Committer(
//           name: data.committer.name,
//           email: data.committer.email,
//         ),
//       );

//   @override
//   PutDbRequestData dataFromMap(Map<String, dynamic> data) =>
//       PutDbRequestData.fromJson(data);
// }

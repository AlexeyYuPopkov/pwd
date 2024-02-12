import 'package:pwd/common/support/data_tools/mapper.dart';
import 'package:pwd/notes/data/sync_models/put_db_request_data.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';

class PutDbRequestMapper implements Mapper<PutDbRequestData, PutDbRequest> {
  @override
  PutDbRequestData toData(PutDbRequest data) => PutDbRequestData(
        message: data.message,
        content: data.content,
        sha: data.sha,
        committer: CommitterData(
          name: data.committer.name,
          email: data.committer.email,
        ),
        branch: data.branch,
      );

  @override
  PutDbRequest toDomain(PutDbRequestData data) => PutDbRequest(
        message: data.message,
        content: data.content,
        sha: data.sha,
        committer: Committer(
          name: data.committer.name,
          email: data.committer.email,
        ),
        branch: data.branch,
      );

  @override
  PutDbRequestData dataFromMap(Map<String, dynamic> data) =>
      PutDbRequestData.fromJson(data);
}

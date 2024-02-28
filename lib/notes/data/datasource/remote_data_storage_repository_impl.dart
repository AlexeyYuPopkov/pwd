import 'package:pwd/common/domain/errors/network_error.dart';
import 'package:pwd/common/support/data_tools/mapper.dart';
import 'package:pwd/common/domain/errors/network_error_mapper.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/data/sync_data_service/git_service_api.dart';
import 'package:pwd/notes/data/sync_models/put_db_request_data.dart';
import 'package:pwd/notes/domain/git_repository.dart';

import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';

class RemoteDataStorageRepositoryImpl implements GitRepository {
  final GitServiceApi service;

  final Mapper<PutDbRequestData, PutDbRequest> putDbRequestMapper;

  final NetworkErrorMapper errorMapper;

  RemoteDataStorageRepositoryImpl({
    required this.service,
    required this.errorMapper,
    required this.putDbRequestMapper,
  });

  @override
  Future<PutDbResponse> updateRemote({
    required PutDbRequest request,
    required GitConfiguration configuration,
  }) async {
    PutDbRequest adjustedWithBranch(PutDbRequest request) {
      final branch = configuration.branch;

      if (branch != null && branch.trim().isNotEmpty) {
        return request.copyWithBranch(branch: branch);
      }

      return request;
    }

    return service
        .putDb(
          owner: configuration.owner,
          repo: configuration.repo,
          filename: configuration.fileName,
          body: putDbRequestMapper.toData(adjustedWithBranch(request)),
          token: _adjustedToken(configuration.token),
          branch: configuration.branch,
        )
        .catchError(
          (e) => throw errorMapper(e),
        );
  }

  @override
  Future<GetDbResponse?> getFile({
    required GitConfiguration configuration,
  }) async {
    try {
      final result = await service.getDb(
        token: _adjustedToken(configuration.token),
        owner: configuration.owner,
        repo: configuration.repo,
        filename: configuration.fileName,
        branch: configuration.branch,
      );

      return result;
    } catch (e) {
      final error = errorMapper(e);

      if (error is NotFoundError) {
        return null;
      } else {
        throw error;
      }
    }
  }

  String _adjustedToken(String str) => 'Bearer $str';
}

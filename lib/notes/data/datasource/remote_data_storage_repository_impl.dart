import 'package:pwd/common/support/data_tools/mapper.dart';
import 'package:pwd/common/domain/errors/network_error_mapper.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/data/sync_data_service/git_graph_ql_service.dart';
import 'package:pwd/notes/data/sync_data_service/git_service_api.dart';
import 'package:pwd/notes/data/sync_models/put_db_request_data.dart';
import 'package:pwd/notes/domain/git_repository.dart';

import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';

class RemoteDataStorageRepositoryImpl implements GitRepository {
  final GitServiceApi service;
  final GitGraphQlService graphQlService;
  final GetGitFileServiceApi gitFileService;

  final Mapper<PutDbRequestData, PutDbRequest> putDbRequestMapper;

  final NetworkErrorMapper errorMapper;

  RemoteDataStorageRepositoryImpl({
    required this.service,
    required this.graphQlService,
    required this.gitFileService,
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

      if (branch.trim().isNotEmpty) {
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
      final sha = await graphQlService.getFileSha(
        token: configuration.token,
        configuration: configuration,
      );

      return sha == null ? null : GetDbResponse(sha: sha);
    } catch (e) {
      throw errorMapper(e);
    }
  }

  @override
  Future<List<int>> getRawFile({
    required GitConfiguration configuration,
  }) async {
    final result = await gitFileService.getRawFile(
      token: _adjustedToken(configuration.token),
      owner: configuration.owner,
      repo: configuration.repo,
      filename: configuration.fileName,
      branch: configuration.branch,
    );

    return result;
  }

  String _adjustedToken(String str) => 'Bearer $str';
}

import 'package:pwd/common/data_tools/mapper.dart';
import 'package:pwd/common/domain/errors/network_error_mapper.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/notes/data/sync_data_service/git_service_api.dart';
import 'package:pwd/notes/data/sync_models/put_db_request_data.dart';
import 'package:pwd/notes/domain/remote_data_storage_repository.dart';

import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';

class RemoteDataStorageRepositoryImpl implements RemoteDataStorageRepository {
  final GitServiceApi service;

  final Mapper<PutDbRequestData, PutDbRequest> putDbRequestMapper;

  final NetworkErrorMapper errorMapper;

  RemoteDataStorageRepositoryImpl({
    required this.service,
    required this.errorMapper,
    required this.putDbRequestMapper,
  });

  @override
  Future<PutDbResponse> putDb({
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
        )
        .catchError(
          (e) => throw errorMapper(e),
        );
  }

  @override
  Future<GetDbResponse> getDb({
    required GitConfiguration configuration,
  }) =>
      service
          .getDb(
            token: _adjustedToken(configuration.token),
            owner: configuration.owner,
            repo: configuration.repo,
            filename: configuration.fileName,
            branch: configuration.branch,
          )
          .catchError(
            (e) => throw errorMapper(e),
          );

  // @override
  // Future<PutDbResponse> putRealmDb({
  //   required PutDbRequest request,
  //   required RemoteStorageConfiguration configuration,
  // }) async {
  //   PutDbRequest adjustedWithBranch(PutDbRequest request) {
  //     final branch = configuration.branch;

  //     if (branch != null && branch.trim().isNotEmpty) {
  //       return request.copyWithBranch(branch: branch);
  //     }

  //     return request;
  //   }

  //   return service
  //       .putDb(
  //         owner: configuration.owner,
  //         repo: configuration.repo,
  //         filename: configuration.realmFileName,
  //         body: putDbRequestMapper.toData(adjustedWithBranch(request)),
  //         token: _adjustedToken(configuration.token),
  //       )
  //       .catchError(
  //         (e) => throw errorMapper(e),
  //       );
  // }

  // @override
  // Future<GetDbResponse> getRealmDb({
  //   required RemoteStorageConfiguration configuration,
  // }) =>
  //     service
  //         .getDb(
  //           token: _adjustedToken(configuration.token),
  //           owner: configuration.owner,
  //           repo: configuration.repo,
  //           filename: configuration.realmFileName,
  //           branch: configuration.branch,
  //         )
  //         .catchError(
  //           (e) => throw errorMapper(e),
  //         );

  String _adjustedToken(String str) => 'Bearer $str';
}
